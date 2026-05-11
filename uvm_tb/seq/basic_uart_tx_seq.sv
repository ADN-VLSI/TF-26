`ifndef __GUARD_BASIC_UART_TX_SEQ_SV__
`define __GUARD_BASIC_UART_TX_SEQ_SV__ 0

`include "obj/apb_seq_item.sv"

class basic_uart_tx_seq extends uvm_sequence #(apb_seq_item);

  `uvm_object_utils(basic_uart_tx_seq)

  function new(string name = "basic_uart_tx_seq");
    super.new(name);
  endfunction

  task body();
    apb_seq_item item;
    string msg = "Hello World!\n";

    // Send Hello World!
    for(int i = 0; i < msg.len(); i++) begin
      `uvm_do_with(req, {req.addr == `TX_DATA_ADDR; req.write == 1; req.data == msg[i];})
    end

  endtask

endclass

`endif
