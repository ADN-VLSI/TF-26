`ifndef __GUARD_BASIC_TEST_SV__
`define __GUARD_BASIC_TEST_SV__ 0

`include "test/base_test.sv"
`include "seq/basic_uart_tx_seq.sv"
`include "seq/basic_uart_rx_seq.sv"
`include "seq/uart_disable_seq.sv"

class basic_test extends base_test;

  `uvm_component_utils(basic_test)

  function new(string name = "basic_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  task main_phase(uvm_phase phase);
    basic_uart_tx_seq tx_seq;
    basic_uart_rx_seq rx_seq;
    uart_disable_seq  disable_seq;
    phase.raise_objection(this);
    super.main_phase(phase);
    
    // Transmit data
    tx_seq = basic_uart_tx_seq::type_id::create("tx_seq");
    tx_seq.start(env.apb.sqr);
    
    // Receive data
    rx_seq = basic_uart_rx_seq::type_id::create("rx_seq");
    rx_seq.start(env.apb.sqr);
    
    // Disable UART
    disable_seq = uart_disable_seq::type_id::create("disable_seq");
    disable_seq.start(env.apb.sqr);
    
    phase.drop_objection(this);
  endtask

endclass

`endif
