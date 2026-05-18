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
    string received_msg = "";

    // Read received data
    for(int i = 0; i < expected_msg.len(); i++) begin
      `uvm_do_with(req, {req.addr == `RX_DATA_ADDR; req.write == 0;})
      received_msg = {received_msg, req.data[7:0]};
    end

    
    `uvm_info(get_type_name(), $sformatf("Received message: %s", received_msg), UVM_LOW)

    //check
    if (received_msg == expected_msg) begin
      `uvm_info(get_type_name(), "RX data matches expected TX data", UVM_LOW)
    end else begin
      `uvm_error(get_type_name(), $sformatf("RX data mismatch! Expected: %s, Received: %s", expected_msg, received_msg))
    end

  endtask

endclass

`endif
