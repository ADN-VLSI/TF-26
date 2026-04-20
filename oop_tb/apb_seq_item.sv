`include "addr_def.sv"

`ifndef __GUARD_APB_SEQ_ITEM_SV__
`define __GUARD_APB_SEQ_ITEM_SV__ 0

class apb_seq_item;

  rand bit [31:0] addr;
  rand bit        write;
  rand bit [31:0] data;

  constraint addr_write_c {
    if (write) addr inside{
      `CTRL_ADDR,
      `CLK_DIV_ADDR,
      `CFG_ADDR,
      `TX_DATA_ADDR,
      `INTR_CTRL_ADDR
    };
    else addr inside{
      `CTRL_ADDR,
      `CLK_DIV_ADDR,
      `CFG_ADDR,
      `TX_FIFO_COUNT_ADDR,
      `RX_FIFO_COUNT_ADDR,
      `RX_DATA_ADDR,
      `INTR_CTRL_ADDR
    };
  }

  virtual function string to_string();
    return $sformatf("APB SEQ ITEM: addr=0x%0h, write=%b, data=0x%0h", addr, write, data);
  endfunction

  virtual function void print();
    $display("%s", this.to_string());
  endfunction

endclass

`endif
