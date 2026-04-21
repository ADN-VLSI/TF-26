`include "uart_rsp_item.sv"

`ifndef __GUARD_UART_MONITOR_SV__
`define __GUARD_UART_MONITOR_SV__ 0

class uart_monitor;

  virtual uart_if intf;
  mailbox #(uart_rsp_item) mbx;

  function new(virtual uart_if intf, mailbox #(uart_rsp_item) mbx);
    this.intf = intf;
    this.mbx = mbx;
  endfunction

  task automatic run();
    uart_rsp_item item;

    fork

      forever begin
        logic [7:0] rx_data;
        logic data_valid;
        logic parity_error;
        logic framing_error;
        
        // Monitor UART transaction
        intf.monitor_transaction(rx_data, data_valid, parity_error, framing_error);
        
        item = new();
        item.data = rx_data;
        item.data_valid = data_valid;
        item.parity_error = parity_error;
        item.framing_error = framing_error;
        
        mbx.put(item);
      end

    join_none

  endtask

  task automatic wait_till_idle(input int timeout = 1000);
    intf.wait_till_idle(timeout);
  endtask

endclass

`endif
