`ifndef __GUARD_UART_ENABLE_SEQ_SV__
`define __GUARD_UART_ENABLE_SEQ_SV__ 0

`include "obj/apb_seq_item.sv"

class uart_enable_seq extends uvm_sequence #(apb_seq_item);

  `uvm_object_utils(uart_enable_seq)

  function new(string name = "uart_enable_seq");
    super.new(name);
  endfunction

  task body();
    apb_seq_item item;

    // FLUSH TX RX
    `uvm_do_with(req, {req.addr == `CTRL_ADDR;    req.write == 1; req.data == 32'h006;})

    // Set baud rate to 115200 @ 100MHz
    `uvm_do_with(req, {req.addr == `CLK_DIV_ADDR; req.write == 1; req.data == 32'h364;})

    // Config UART: 8N1
    `uvm_do_with(req, {req.addr == `CFG_ADDR;     req.write == 1; req.data == 32'h000;})

    // Enable UART
    `uvm_do_with(req, {req.addr == `CTRL_ADDR;    req.write == 1; req.data == 32'h001;})

  endtask

endclass

`endif
