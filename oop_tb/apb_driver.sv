`include "apb_seq_item.sv"

`ifndef __GUARD_APB_DRIVER_SV__
`define __GUARD_APB_DRIVER_SV__ 0

class apb_driver;

  virtual apb_if intf;

  mailbox #(apb_seq_item) mbx;

  function new(virtual apb_if intf, mailbox #(apb_seq_item) mbx);
    this.intf = intf;
    this.mbx = mbx;
  endfunction

  task automatic reset();
    intf.reset();
  endtask

  task automatic run();
    apb_seq_item item;

    fork

      forever begin
        mbx.peek(item);
        if (item.write) begin
          intf.write(item.addr, item.data);
        end else begin
          logic [31:0] read_data;
          intf.read(item.addr, read_data);
        end
        mbx.get(item);
      end

    join_none

  endtask

endclass

`endif
