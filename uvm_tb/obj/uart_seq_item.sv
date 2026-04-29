`ifndef __GUARD_UART_SEQ_ITEM_SV__
`define __GUARD_UART_SEQ_ITEM_SV__ 0

class uart_seq_item extends uvm_sequence_item;

  rand logic [7:0] data;
  rand int         baud_rate       = 115200;
  rand bit         parity_enable   = 0;
  rand bit         parity_type     = 1;  // 0=even, 1=odd
  rand bit         second_stop_bit = 0;
  rand int         data_bits       = 8;

  `uvm_object_utils_begin(uart_seq_item)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(baud_rate, UVM_ALL_ON)
    `uvm_field_int(parity_enable, UVM_ALL_ON)
    `uvm_field_int(parity_type, UVM_ALL_ON)
    `uvm_field_int(second_stop_bit, UVM_ALL_ON)
    `uvm_field_int(data_bits, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "uart_seq_item");
    super.new(name);
  endfunction

  constraint data_c {
    baud_rate inside {9600, 19200, 38400, 57600, 115200};
  }

  constraint data_bits_c {
    data_bits inside {8}; // TODO LATER
    // data_bits inside {5, 6, 7, 8};
  }

endclass

`endif
