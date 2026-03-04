module protocol_cvtr_rifatalif #(
    parameter int ADDR_WIDTH = 8,  // Address width for APB
    parameter int DATA_WIDTH = 32  // Data width for APB
) (

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Global Signals
    ////////////////////////////////////////////////////////////////////////////////////////////////

    input logic arst_ni,  // active-low asynchronous reset
    input logic clk_i,    // clock input

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Custom Protocol Signals
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Control Channel
    input  logic [ADDR_WIDTH-1:0] c_addr_i,     // Control Channel Address input
    input  logic                  c_wenable_i,  // Control Channel Write Enable input
    input  logic                  c_valid_i,    // Control Channel Valid input
    output logic                  c_ready_o,    // Control Channel Ready output

    // Write Data Channel
    input  logic [  DATA_WIDTH-1:0] w_data_i,   // Write Data input
    input  logic [DATA_WIDTH/8-1:0] w_strb_i,   // Write Strobe input (1 bit per byte lane)
    input  logic                    w_valid_i,  // Write Data Valid input
    output logic                    w_ready_o,  // Write Data Ready output

    // Read Data Channel
    output logic [DATA_WIDTH-1:0] r_data_o,   // Read Data output
    output logic                  r_valid_o,  // Read Data Valid output
    input  logic                  r_ready_i,  // Read Data Ready input

    // Response Channel
    output logic b_slverr_o,  // Response Slave Error output
    output logic b_valid_o,   // Response Valid output
    input  logic b_ready_i,   // Response Ready input

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // APB Signals
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // APB Output Signals (to APB Slave)
    output logic                    psel_o,     // APB Select output
    output logic                    penable_o,  // APB Enable output
    output logic [  ADDR_WIDTH-1:0] paddr_o,    // APB Address output
    output logic                    pwrite_o,   // APB Write output
    output logic [  DATA_WIDTH-1:0] pwdata_o,   // APB Write Data output
    output logic [DATA_WIDTH/8-1:0] pstrb_o,    // APB Write Strobe output (1 bit per byte lane)

    // APB Input Signals (from APB Slave)
    input logic                  pready_i,  // APB Ready input
    input logic [DATA_WIDTH-1:0] prdata_i,  // APB Read Data input
    input logic                  pslverr_i  // APB Slave Error input
);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Type Definations
  //////////////////////////////////////////////////////////////////////////////////////////////////

  typedef enum int unsigned {
    GET_C,
    GET_W,
    APB_SEL,
    APB_EN,
    SEND_R,
    SEND_B
  } state_t;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Internal Signals
  //////////////////////////////////////////////////////////////////////////////////////////////////

  state_t current_state;
  state_t next_state;
  ////////////////////////////////////////////////////////////////////////////////
  // Combinational FSM
  ////////////////////////////////////////////////////////////////////////////////

  // Next-state logic + output control
  // Pure combinational block
  always_comb begin

    // Default stay in same state
    next_state = current_state;

    // Default output values (avoid latch inference)
    c_ready_o  = 1'b0;
    w_ready_o  = 1'b0;
    r_valid_o  = 1'b0;
    b_valid_o  = 1'b0;

    psel_o     = 1'b0;
    penable_o  = 1'b0;

    // Response outputs driven from registered values
    b_slverr_o = slverr_q;
    r_data_o   = rdata_q;

    case (current_state)

      /////////////////////////////////////////////////////////////
      // GET_C : Wait for Control Phase
      // Accept address + write/read information
      /////////////////////////////////////////////////////////////
      GET_C: begin
        c_ready_o = 1'b1;  // Ready to accept control request

        if (c_valid_i) begin
          if (c_wenable_i) next_state = GET_W;  // Write request → need write data
          else next_state = APB_SEL;  // Read request → directly go to APB
        end
      end

      /////////////////////////////////////////////////////////////
      // GET_W : Wait for Write Data Phase
      // Accept write data and strobe
      /////////////////////////////////////////////////////////////
      GET_W: begin
        w_ready_o = 1'b1;  // Ready to accept write data

        if (w_valid_i) next_state = APB_SEL;  // Data received → start APB
      end

      /////////////////////////////////////////////////////////////
      // APB_SEL : APB Select Phase
      // First cycle of APB transfer (PSEL=1, PENABLE=0)
      /////////////////////////////////////////////////////////////
      APB_SEL: begin
        psel_o    = 1'b1;
        penable_o = 1'b0;
        next_state = APB_EN;   // Move to enable phase next cycle
      end

      /////////////////////////////////////////////////////////////
      // APB_EN : APB Enable Phase
      // Second phase of APB (actual transfer happens here)
      /////////////////////////////////////////////////////////////
      APB_EN: begin
        psel_o    = 1'b1;
        penable_o = 1'b1;

        // Wait until APB slave signals ready
        if (pready_i) begin
          if (wenable_q) next_state = SEND_B;  // Write transaction complete
          else next_state = SEND_R;  // Read transaction complete
        end
      end

      /////////////////////////////////////////////////////////////
      // SEND_R : Send Read Data Back to Master
      /////////////////////////////////////////////////////////////
      SEND_R: begin
        r_valid_o = 1'b1;  // Read data valid

        // Wait until master accepts read data
        if (r_ready_i) next_state = GET_C;  // Transaction done → back to idle
      end

      /////////////////////////////////////////////////////////////
      // SEND_B : Send Write Response Back to Master
      /////////////////////////////////////////////////////////////
      SEND_B: begin
        b_valid_o = 1'b1;  // Write response valid

        // Wait until master accepts response
        if (b_ready_i) next_state = GET_C;  // Transaction done → back to idle
      end

      /////////////////////////////////////////////////////////////
      // Default Safety
      /////////////////////////////////////////////////////////////
      default: begin
        next_state = GET_C;
      end

    endcase
  end

endmodule
