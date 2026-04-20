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

  task automatic run();
    apb_rsp_item item;

    fork

      forever begin
        int write, address, write_data, write_strobe, read_data, slverr;
        intf.get_transaction(write, address, write_data, write_strobe, read_data, slverr);
        item = new();
        item.write = write;
        item.addr = address;
        item.data = write ? write_data : read_data;
        item.slverr = slverr;
        mbx.put(item);
      end

    join_none

  endtask

  task automatic wait_till_idle(input int tx_len = 3);
    intf.wait_till_idle(tx_len);
  endtask

endclass

`endif
