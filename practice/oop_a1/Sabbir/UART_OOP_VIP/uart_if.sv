// UART Interface - Defines the UART communication interface
// This interface provides methods and signals for UART communication

`ifndef __GUARD_UART_IF_SV__
`define __GUARD_UART_IF_SV__ 0

interface uart_if(input bit clk, input bit rst);

  // UART signals
  logic tx;
  logic rx;
  
  // Configuration signals
  logic [1:0] baud_rate_sel;
  logic [2:0] data_bits_sel;
  logic [1:0] stop_bits_sel;
  logic parity_en;
  logic parity_type;
  
  // Status signals
  logic tx_done;
  logic rx_done;
  logic [7:0] rx_data;
  logic parity_error;
  logic framing_error;
  logic overflow_error;

  // Reset task
  task reset();
    baud_rate_sel = 0;
    data_bits_sel = 0;
    stop_bits_sel = 0;
    parity_en = 0;
    parity_type = 0;
    #100ns;
  endtask

  // Configure UART
  task configure(bit [1:0] baud, bit [2:0] data_bits, bit [1:0] stop_bits, 
                 bit parity_e, bit parity_t);
    baud_rate_sel = baud;
    data_bits_sel = data_bits;
    stop_bits_sel = stop_bits;
    parity_en = parity_e;
    parity_type = parity_t;
    #200ns;
  endtask

  // Transmit byte
  task transmit(bit [7:0] data);
    // Simulate TX operation
    tx = 0;  // Start bit
    #100ns;
    
    for (int i = 0; i < 8; i++) begin
      tx = data[i];
      #100ns;
    end
    
    tx = 1;  // Stop bit
    #100ns;
    tx_done = 1;
    #100ns;
    tx_done = 0;
  endtask

  // Receive byte
  task receive(output bit [7:0] data);
    // Simulate RX operation
    data = 8'h55;  // Example data
    @(posedge clk);
    rx_done = 1;
    @(posedge clk);
    rx_done = 0;
  endtask

  // Get transaction info
  task get_transaction(output bit [7:0] data, output bit done, 
                       output bit par_err, output bit frm_err, output bit ovf_err);
    data = rx_data;
    done = rx_done;
    par_err = parity_error;
    frm_err = framing_error;
    ovf_err = overflow_error;
  endtask

  // Wait for idle
  task wait_till_idle(int cycles = 5);
    repeat(cycles) @(posedge clk);
  endtask

endinterface

`endif
