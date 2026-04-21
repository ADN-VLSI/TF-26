`ifndef __GUARD_UART_RSP_ITEM_SV__
`define __GUARD_UART_RSP_ITEM_SV__ 0

class uart_rsp_item extends uart_seq_item;

  bit data_valid;
  bit parity_error;
  bit framing_error;

  virtual function string to_string();
    return $sformatf("UART RSP ITEM: data=0x%0h, is_tx=%b, baud_div=%0d, parity_en=%b, parity_type=%b, data_valid=%b, parity_error=%b, framing_error=%b", 
                     data, is_tx, baud_div, parity_en, parity_type, data_valid, parity_error, framing_error);
  endfunction

endclass

`endif
