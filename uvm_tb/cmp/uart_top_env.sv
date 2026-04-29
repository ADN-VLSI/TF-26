`ifndef __GUARD_UART_TOP_ENV_SV__
`define __GUARD_UART_TOP_ENV_SV__ 0

class uart_top_env extends uvm_env;

  // UVM component utilities for factory registration
  `uvm_component_utils(uart_top_env)

  // Constructor for the environment
  function new(string name = "uart_top_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass

`endif
