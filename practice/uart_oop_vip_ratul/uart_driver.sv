`include "uart_seq_item.sv"

`ifndef __GUARD_UART_DRIVER_SV__
`define __GUARD_UART_DRIVER_SV__ 0

class uart_driver;

  virtual uart_if intf;
  mailbox #(uart_seq_item) mbx;

  function new(virtual uart_if intf, mailbox #(uart_seq_item) mbx);
    this.intf = intf;
    this.mbx = mbx;
  endfunction

  task automatic reset();
    intf.reset();
  endtask

  task automatic run();
    uart_seq_item item;

    fork

      forever begin
        mbx.peek(item);
        
        intf.set_baud_rate(item.baud_div);
        
        if (item.parity_en) begin
          intf.set_parity(item.parity_en, item.parity_type);
        end
        
        if (item.is_tx) begin
          intf.transmit(item.data);
        end else begin
          logic [7:0] rx_data;
          intf.receive(rx_data);
        end
        
        mbx.get(item);
        
        if (item.delay > 0) begin
          repeat (item.delay) @(posedge intf.clk);
        end
      end

    join_none

  endtask

endclass

`endif
