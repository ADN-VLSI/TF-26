`ifndef __GUARD_BASE_TEST_SV__
`define __GUARD_BASE_TEST_SV__ 0

`include "cmp/uart_top_env.sv"
`include "seq/uart_enable_seq.sv"

class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  virtual ctrl_if ctrl_intf;
  virtual apb_if  apb_intf;
  virtual uart_if uart_intf;
  uart_top_env    env;

  // Constructor for the base test
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  task wait_apb_idle();
    apb_intf.wait_till_idle();
  endtask

  task wait_uart_idle();
    uart_intf.wait_till_idle();
  endtask

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

    if (!uvm_config_db#(virtual apb_if)::get(
            uvm_root::get(), "apb", "apb_intf", apb_intf
        )) begin
      `uvm_fatal("NOVIF", "Virtual interface 'apb_intf' not found in config DB")
    end

    if (!uvm_config_db#(virtual uart_if)::get(
            uvm_root::get(), "uart", "uart_intf", uart_intf
        )) begin
      `uvm_fatal("NOVIF", "Virtual interface 'uart_intf' not found in config DB")
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

  virtual task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    super.reset_phase(phase);
    fork
      ctrl_intf.apply_reset(100ns);
      apb_intf.reset();
    join
    ctrl_intf.enable_clock();
    phase.drop_objection(this);
  endtask

  virtual task configure_phase(uvm_phase phase);
    uart_enable_seq enable_seq;
    phase.raise_objection(this);
    super.configure_phase(phase);
    enable_seq = uart_enable_seq::type_id::create("enable_seq");
    enable_seq.start(env.apb.sqr);
    phase.drop_objection(this);
  endtask

  virtual task shutdown_phase(uvm_phase phase);
    phase.raise_objection(this);
    super.shutdown_phase(phase);
    fork
      wait_apb_idle();
      wait_uart_idle();
    join
    phase.drop_objection(this);
  endtask

endclass

`endif
