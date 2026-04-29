`ifndef __GUARD_UART_TOP_ENV_SV__
`define __GUARD_UART_TOP_ENV_SV__ 0

`include "cmp/apb_agent.sv"
`include "cmp/uart_agent.sv"

class uart_top_env extends uvm_env;

  // UVM component utilities for factory registration
  `uvm_component_utils(uart_top_env)

  apb_agent  apb;
  uart_agent uart;

  // Constructor for the environment
  function new(string name = "uart_top_env", uvm_component parent = null);
    super.new(name, parent);
    apb  = apb_agent::type_id::create("apb", this);
    uart = uart_agent::type_id::create("uart", this);
  endfunction : new

endclass

`endif
