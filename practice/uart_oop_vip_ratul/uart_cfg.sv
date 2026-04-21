`ifndef __GUARD_UART_CFG_SV__
`define __GUARD_UART_CFG_SV__ 0

class uart_cfg;

  bit [15:0] default_baud_div = 16'd868;
  bit default_parity_en = 1'b0;
  bit default_parity_type = 1'b0;
  bit default_stop_bits = 1'b0;
  bit [2:0] default_data_bits = 3'd8;

  function new();
  endfunction

  virtual function void set_baud_rate(bit [15:0] baud_div);
    this.default_baud_div = baud_div;
  endfunction

  virtual function bit [15:0] get_baud_rate();
    return this.default_baud_div;
  endfunction

  virtual function void set_parity(bit enable, bit parity_type);
    this.default_parity_en = enable;
    this.default_parity_type = parity_type;
  endfunction

  virtual function void get_parity(output bit enable, output bit parity_type);
    enable = this.default_parity_en;
    parity_type = this.default_parity_type;
  endfunction

  virtual function void set_data_bits(bit [2:0] bits);
    if (bits >= 3'd5 && bits <= 3'd9) begin
      this.default_data_bits = bits;
    end else begin
      $warning("Invalid data bits: %0d. Using default 8 bits.", bits);
    end
  endfunction

  virtual function bit [2:0] get_data_bits();
    return this.default_data_bits;
  endfunction

  virtual function void print();
    $display("UART Configuration:");
    $display("  Baud Divisor: %0d", this.default_baud_div);
    $display("  Parity Enabled: %b", this.default_parity_en);
    $display("  Parity Type (0=even, 1=odd): %b", this.default_parity_type);
    $display("  Stop Bits (0=1, 1=2): %b", this.default_stop_bits);
    $display("  Data Bits: %0d", this.default_data_bits);
  endfunction

endclass

`endif
