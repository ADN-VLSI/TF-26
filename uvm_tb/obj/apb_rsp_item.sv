`ifndef __GUARD_APB_RSP_ITEM_SV__
`define __GUARD_APB_RSP_ITEM_SV__ 0

`include "obj/apb_seq_item.sv"

class apb_rsp_item extends apb_seq_item;

  // rand bit [31:0] addr;
  // rand bit        write;
  // rand bit [31:0] data;
  bit slverr;
  
  function new(string name = "apb_rsp_item");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(apb_rsp_item)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(write, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(slverr, UVM_ALL_ON)
  `uvm_object_utils_end

endclass

`endif
