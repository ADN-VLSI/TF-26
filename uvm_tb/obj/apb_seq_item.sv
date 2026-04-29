`include "addr_def.sv"

`ifndef __GUARD_APB_SEQ_ITEM_SV__
`define __GUARD_APB_SEQ_ITEM_SV__ 0

class apb_seq_item extends uvm_sequence_item;

  rand bit [31:0] addr;
  rand bit        write;
  rand bit [31:0] data;

  `uvm_object_utils_begin(apb_seq_item)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(write, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "apb_seq_item");
    super.new(name);
  endfunction

  constraint addr_write_c {
    if (write) addr inside{
      `CTRL_ADDR,
      `CLK_DIV_ADDR,
      `CFG_ADDR,
      `TX_DATA_ADDR,
      `INTR_CTRL_ADDR
    };
    else addr inside{
      `CTRL_ADDR,
      `CLK_DIV_ADDR,
      `CFG_ADDR,
      `TX_FIFO_COUNT_ADDR,
      `RX_FIFO_COUNT_ADDR,
      `RX_DATA_ADDR,
      `INTR_CTRL_ADDR
    };
  }

endclass

`endif
