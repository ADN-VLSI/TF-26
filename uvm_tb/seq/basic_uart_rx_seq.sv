`ifndef __GUARD_BASIC_UART_RX_SEQ_SV__
`define __GUARD_BASIC_UART_RX_SEQ_SV__ 0

`include "obj/apb_seq_item.sv"

class basic_uart_rx_seq extends uvm_sequence #(apb_seq_item);

  `uvm_object_utils(basic_uart_rx_seq)

  function new(string name = "basic_uart_rx_seq");
    super.new(name);
  endfunction

  task body();
    apb_seq_item item;
    string expected_msg = "Hello World!\n";
    int num_reads = expected_msg.len();  // 13 bytes for "Hello World!\n"
    byte received_data[13];

    // Read RX data from the UART RX FIFO
    `uvm_info("RX_SEQ", $sformatf("Reading %0d bytes from RX FIFO", num_reads), UVM_MEDIUM)
    
    for(int i = 0; i < num_reads; i++) begin
      `uvm_do_with(req, {req.addr == `RX_DATA_ADDR; req.write == 0;})
      // Capture the data from response
      if ($cast(item, req)) begin
        received_data[i] = item.data[7:0];
        `uvm_info("RX_SEQ", $sformatf("Read byte[%0d]: %c (0x%02h)", i, received_data[i], received_data[i]), UVM_LOW)
      end
    end

    // Display received message
    `uvm_info("RX_SEQ", "Received message:", UVM_MEDIUM)
    for(int i = 0; i < num_reads; i++) begin
      $write("%c", received_data[i]);
    end
    $write("\n");

  endtask

endclass

`endif
