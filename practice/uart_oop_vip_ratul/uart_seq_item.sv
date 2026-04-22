`ifndef __GUARD_UART_SEQ_ITEM_SV__
`define __GUARD_UART_SEQ_ITEM_SV__ 0

class uart_seq_item;

  rand bit [7:0]  data;
  rand bit        is_tx;
  rand bit [15:0] baud_div;
  rand bit        parity_en;
  rand bit        parity_type;
  
  int delay;
  
  constraint data_c {
    data inside {[8'h00:8'hFF]};
  }
  
  constraint baud_c {
    baud_div inside {[16'd1:16'd1000]};
  }

  virtual function string to_string();
    return $sformatf("UART SEQ ITEM: data=0x%0h, is_tx=%b, baud_div=%0d, parity_en=%b, parity_type=%b", 
                     data, is_tx, baud_div, parity_en, parity_type);
  endfunction

  virtual function void print();
    $display("%s", this.to_string());
  endfunction

endclass

`endif
