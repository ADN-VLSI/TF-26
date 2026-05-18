`ifndef __GUARD_UART_DISABLE_SEQ_SV__
`define __GUARD_UART_DISABLE_SEQ_SV__ 0

`include "obj/apb_seq_item.sv"

class uart_disable_seq extends uvm_sequence #(apb_seq_item);

  `uvm_object_utils(uart_disable_seq)

  function new(string name = "uart_disable_seq");
    super.new(name);
  endfunction

  task body();
    apb_seq_item item;

    `uvm_info("UART_DISABLE_SEQ", "Disabling UART", UVM_MEDIUM)

    // Disable UART by writing 0 to CTRL_ADDR
    `uvm_do_with(req, {req.addr == `CTRL_ADDR; req.write == 1; req.data == 32'h000;})

    `uvm_info("UART_DISABLE_SEQ", "UART disabled successfully", UVM_MEDIUM)

  endtask

endclass

`endif
