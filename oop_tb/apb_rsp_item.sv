`ifndef __GUARD_APB_RSP_ITEM_SV__
`define __GUARD_APB_RSP_ITEM_SV__ 0

class apb_rsp_item extends apb_seq_item;

  // rand bit [31:0] addr;
  // rand bit        write;
  // rand bit [31:0] data;
  bit slverr;

  virtual function string to_string();
    string txt_out;
    txt_out = super.to_string();
    $sformat(txt_out, "%s, slverr=%b", txt_out, slverr);
    txt_out = txt_out.substr(7, txt_out.len()-1);
    txt_out = {"APB RSP", txt_out};
    return txt_out;
  endfunction

endclass

`endif
