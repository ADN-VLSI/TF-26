`ifndef __GUARD_UART_AGENT_SV__
`define __GUARD_UART_AGENT_SV__ 0

`include "cmp/uart_driver.sv"
`include "cmp/uart_monitor.sv"

class uart_agent extends uvm_agent;

  `uvm_component_utils(uart_agent)

  uart_driver dvr;
  uart_monitor mon;

  function new(string name = "uart_agent", uvm_component parent = null);
    super.new(name, parent);
    dvr = uart_driver::type_id::create("dvr", this);
    mon = uart_monitor::type_id::create("mon", this);
  endfunction

endclass

`endif
