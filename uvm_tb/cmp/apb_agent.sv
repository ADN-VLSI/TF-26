`ifndef __GUARD_APB_AGENT_SV__
`define __GUARD_APB_AGENT_SV__ 0

`include "obj/apb_seq_item.sv"
`include "cmp/apb_driver.sv"
`include "cmp/apb_monitor.sv"

class apb_agent extends uvm_agent;

  `uvm_component_utils(apb_agent)

  uvm_sequencer #(apb_seq_item) sqr;
  apb_driver dvr;
  apb_monitor mon;

  uvm_analysis_port #(apb_rsp_item) ap;

  function new(string name = "apb_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = uvm_sequencer #(apb_seq_item)::type_id::create("sqr", this);
    dvr = apb_driver::type_id::create("dvr", this);
    mon = apb_monitor::type_id::create("mon", this);
    ap = new("ap", this);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    dvr.seq_item_port.connect(sqr.seq_item_export);
    mon.ap.connect(ap);
  endfunction

endclass

`endif
