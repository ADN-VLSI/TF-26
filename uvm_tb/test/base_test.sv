`ifndef __GUARD_BASE_TEST_SV__
`define __GUARD_BASE_TEST_SV__ 0

`include "cmp/uart_top_env.sv"

class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  virtual ctrl_if ctrl_intf;
  uart_top_env    env;

  // Constructor for the base test
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // Build phase: create the test environment
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = uart_top_env::type_id::create("env", this);
  endfunction

  // Connect phase: retrieve virtual interfaces from configuration
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (!uvm_config_db#(virtual ctrl_if)::get(
            uvm_root::get(), "ctrl", "ctrl_intf", ctrl_intf
        )) begin
      `uvm_fatal("NOVIF", "Virtual interface 'ctrl_intf' not found in config DB")
    end
  endfunction

  // Run phase: main test execution
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    uvm_top.print_topology();
    $display("");
    uvm_config_db::dump();
    $display("");
    phase.drop_objection(this);
  endtask

endclass

`endif
