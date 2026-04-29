`ifndef __GUARD_APB_AGENT_SV__
`define __GUARD_APB_AGENT_SV__ 0

`include "cmp/apb_driver.sv"
`include "cmp/apb_monitor.sv"

class apb_agent extends uvm_agent;

  `uvm_component_utils(apb_agent)

  apb_driver dvr;
  apb_monitor mon;

  function new(string name = "apb_agent", uvm_component parent = null);
    super.new(name, parent);
    dvr = apb_driver::type_id::create("dvr", this);
    mon = apb_monitor::type_id::create("mon", this);
  endfunction

endclass

`endif
