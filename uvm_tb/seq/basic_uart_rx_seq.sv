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
    int num_bytes = 12;

    for(int i = 0; i < num_bytes; i++) begin
      `uvm_do_with(req, {req.addr == `RX_DATA_ADDR; req.write == 0;})
    end

  endtask

endclass

`endif