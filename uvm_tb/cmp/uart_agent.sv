`ifndef __GUARD_UART_AGENT_SV__
`define __GUARD_UART_AGENT_SV__ 0

`include "obj/uart_seq_item.sv"
`include "cmp/uart_driver.sv"
`include "cmp/uart_monitor.sv"

class uart_agent extends uvm_agent;

  `uvm_component_utils(uart_agent)

  uvm_sequencer #(uart_seq_item) sqr;
  uart_driver dvr;
  uart_monitor mon;

  uvm_analysis_port #(uart_rsp_item) ap;

  function new(string name = "uart_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = uvm_sequencer #(uart_seq_item)::type_id::create("sqr", this);
    dvr = uart_driver::type_id::create("dvr", this);
    mon = uart_monitor::type_id::create("mon", this);
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
