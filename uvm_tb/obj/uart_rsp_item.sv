`ifndef __GUARD_UART_RSP_ITEM_SV__
`define __GUARD_UART_RSP_ITEM_SV__ 0

`include "obj/uart_seq_item.sv"

class uart_rsp_item extends uart_seq_item;

  // rand logic [7:0] data;
  // rand int         baud_rate       = 115200;
  // rand bit         parity_enable   = 0;
  // rand bit         parity_type     = 1;  // 0=even, 1=odd
  // rand bit         second_stop_bit = 0;
  // rand int         data_bits       = 8;
  logic parity;
  bit   intf_tx;

  `uvm_object_utils_begin(uart_rsp_item)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(baud_rate, UVM_ALL_ON)
    `uvm_field_int(parity_enable, UVM_ALL_ON)
    `uvm_field_int(parity_type, UVM_ALL_ON)
    `uvm_field_int(second_stop_bit, UVM_ALL_ON)
    `uvm_field_int(data_bits, UVM_ALL_ON)
    `uvm_field_int(parity, UVM_ALL_ON)
    `uvm_field_int(intf_tx, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "uart_rsp_item");
    super.new(name);
  endfunction

endclass

`endif
