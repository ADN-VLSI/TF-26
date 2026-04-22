// UART Agent - Combines driver, monitor, and sequencer
// This class acts as the main VIP agent that orchestrates the test

`include "uart_driver.sv"
`include "uart_monitor.sv"
`include "uart_sequencer.sv"

`ifndef __GUARD_UART_AGENT_SV__
`define __GUARD_UART_AGENT_SV__ 0

class uart_agent;

  // VIP components
  uart_driver driver;
  uart_monitor monitor;
  uart_sequencer sequencer;
  
  // Virtual interface
  virtual uart_if intf;
  
  // Mailboxes for communication
  mailbox #(uart_seq_item) driver_mbx;
  mailbox #(uart_rsp_item) monitor_mbx;

  // Constructor
  function new(virtual uart_if intf);
    this.intf = intf;
    this.driver_mbx = new();
    this.monitor_mbx = new();
    
    // Create components
    this.driver = new(intf, driver_mbx);
    this.monitor = new(intf, monitor_mbx);
    this.sequencer = new(driver_mbx);
    
    $display("[AGENT] UART Agent created successfully");
  endfunction

  // Reset the interface
  task automatic reset();
    $display("[AGENT] Resetting UART agent...");
    driver.reset();
  endtask

  // Run all components
  task automatic run();
    $display("[AGENT] Starting UART agent...");
    
    fork
      driver.run();
      monitor.run();
    join_none
    
    $display("[AGENT] Driver and Monitor started");
  endtask

  // Stop all components
  task automatic stop();
    $display("[AGENT] Stopping UART agent...");
    // Add stop logic if needed
  endtask

  // Get transaction from monitor
  function uart_rsp_item get_response();
    uart_rsp_item item;
    if (monitor_mbx.try_get(item)) begin
      return item;
    end
    return null;
  endfunction

  // Wait for idle
  task automatic wait_for_idle(int cycles = 5);
    monitor.wait_till_idle(cycles);
  endtask

  // Check monitor for errors
  function bit has_errors();
    uart_rsp_item item;
    bit error_found = 0;
    
    while (monitor_mbx.try_get(item)) begin
      if (monitor.has_errors(item)) begin
        error_found = 1;
        $display("[AGENT] Error detected in response: %s", item.to_string());
      end
      monitor_mbx.put(item);  // Put back for test use
    end
    
    return error_found;
  endfunction

endclass

`endif
