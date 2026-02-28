//.........................................................
//    AUTHOR      : Rifat Alif
//    DATE        : 2026-02-28
//    DESCRIPTION : FIFO buffer implemented using provided mem module.
//........................................................
module fifo_rifatalif #(
    parameter int FIFO_SIZE  = 4,
    parameter int DATA_WIDTH = 8
)(
    input  logic clk_i,
    input  logic arst_ni,
    input  logic [DATA_WIDTH-1:0] data_in_i,
    input  logic                  data_in_valid_i,
    output logic                  data_in_ready_o,
    output logic [DATA_WIDTH-1:0] data_out_o,
    output logic                  data_out_valid_o,
    input  logic                  data_out_ready_i,
    output logic [FIFO_SIZE:0]    count_o
);
    // ......................................................
    // Internal Declarations
    // ......................................................
    logic [FIFO_SIZE:0] wr_pointer;
    logic [FIFO_SIZE:0] rd_pointer;
    logic fifo_full;
    logic fifo_empty;
    logic write_enable;
    logic read_enable;
    logic [DATA_WIDTH-1:0] mem_out;
    // ......................................................
    // Memory Instance
    // ......................................................
    mem #(
        .ADDR_WIDTH(FIFO_SIZE),
        .DATA_WIDTH(DATA_WIDTH)
    ) fifo_mem (
        .clk_i   (clk_i),
        .waddr_i (wr_pointer[FIFO_SIZE-1:0]),
        .wdata_i (data_in_i),
        .we_i    (write_enable),
        .raddr_i (rd_pointer[FIFO_SIZE-1:0]),
        .rdata_o (mem_out)
    );
    // .......................................................
    // Full & Empty Detection
    // .......................................................
    always_comb fifo_empty = (wr_pointer == rd_pointer);
    always_comb fifo_full  = 
        (wr_pointer[FIFO_SIZE] != rd_pointer[FIFO_SIZE]) &&
        (wr_pointer[FIFO_SIZE-1:0] == rd_pointer[FIFO_SIZE-1:0]);
    // Handshake Logic
    always_comb data_in_ready_o  = !fifo_full;
    always_comb data_out_valid_o = !fifo_empty;
    
    // Memory control: write when input valid & ready; read when output valid & ready.
    always_comb write_enable = data_in_valid_i  && data_in_ready_o;
    always_comb read_enable  = data_out_ready_i && data_out_valid_o;
    
    // Pointer Update Logic
    always_ff @(posedge clk_i or negedge arst_ni) begin
        if (!arst_ni)
            wr_pointer <= '0;
        else if (write_enable)
            wr_pointer <= wr_pointer + 1;
    end
    always_ff @(posedge clk_i or negedge arst_ni) begin
        if (!arst_ni)
            rd_pointer <= '0;
        else if (read_enable)
            rd_pointer <= rd_pointer + 1;
    end
    //.......................................................
    // Output & Count
    //........................................................
    always_comb begin
        data_out_o = mem_out;
        count_o    = wr_pointer - rd_pointer;
    end
endmodule
