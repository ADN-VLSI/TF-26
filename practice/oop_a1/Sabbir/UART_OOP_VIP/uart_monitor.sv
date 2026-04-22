// UART Monitor - Observes transactions on the UART interface
// This class monitors UART transactions and collects response information

`include "uart_rsp_item.sv"

`ifndef __GUARD_UART_MONITOR_SV__
`define __GUARD_UART_MONITOR_SV__ 0

class uart_monitor;

  // Virtual interface handle
  virtual uart_if intf;
  
  // Mailbox to send collected transactions
  mailbox #(uart_rsp_item) mbx;

  // Constructor
  function new(virtual uart_if intf, mailbox #(uart_rsp_item) mbx);
    this.intf = intf;
    this.mbx = mbx;
  endfunction

  // Main monitor loop
  task automatic run();
    uart_rsp_item item;
    
    fork
      forever begin
        // Collect transaction from interface
        item = new();
        
        // Monitor for data transmission/reception
        monitor_transaction(item);
        
        // Put collected item in mailbox
        mbx.put(item);
        $display("[MONITOR] Collected: %s", item.to_string());
      end
    join_none
  endtask

  // Monitor transaction on interface
  task automatic monitor_transaction(uart_rsp_item item);
    bit [7:0] data;
    bit done;
    bit parity_err, framing_err, overflow_err;
    
    // Get transaction details from interface
    intf.get_transaction(data, done, parity_err, framing_err, overflow_err);
    
    // Fill in response item
    item.rx_data = data;
    item.rx_done = done;
    item.parity_error = parity_err;
    item.framing_error = framing_err;
    item.overflow_error = overflow_err;
  endtask

  // Wait for idle condition
  task automatic wait_till_idle(input int cycles = 5);
    $display("[MONITOR] Waiting for UART to be idle...");
    intf.wait_till_idle(cycles);
    $display("[MONITOR] UART idle detected");
  endtask

  // Check for errors
  function bit has_errors(uart_rsp_item item);
    return (item.parity_error || item.framing_error || item.overflow_error);
  endfunction

endclass

`endif
