`include "apb_rsp_item.sv"

`ifndef __GUARD_APB_MONITOR_SV__
`define __GUARD_APB_MONITOR_SV__ 0

class apb_monitor;

  virtual apb_if intf;

  mailbox #(apb_rsp_item) mbx;

  function new(virtual apb_if intf, mailbox #(apb_rsp_item) mbx);
    this.intf = intf;
    this.mbx = mbx;
  endfunction

endclass

`endif
