`include "uart_seq_item.sv"

`ifndef __GUARD_UART_RSP_ITEM_SV__
`define __GUARD_UART_RSP_ITEM_SV__ 0

class uart_rsp_item extends uart_seq_item;

  // rand logic [7:0] data;
  // rand int         baud_rate       = 115200;
  // rand bit         parity_enable   = 0;
  // rand bit         parity_type     = 1;  // 0=even, 1=odd
  // rand bit         second_stop_bit = 0;
  // rand int         data_bits       = 8;
  logic parity;
  bit   intf_tx;

  virtual function string to_string();
    string txt_out;
    txt_out = super.to_string();
    $sformat(txt_out, "%s, parity=%b, intf_tx=%b", txt_out, parity, intf_tx);
    txt_out = txt_out.substr(8, txt_out.len()-1);
    txt_out = {"UART RSP", txt_out};
    return txt_out;
  endfunction

endclass

`endif
