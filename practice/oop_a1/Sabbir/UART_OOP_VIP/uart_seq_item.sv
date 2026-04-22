// UART Sequence Item - Transaction class for UART VIP
// This class defines the transaction that will be sent/received on UART

`ifndef __GUARD_UART_SEQ_ITEM_SV__
`define __GUARD_UART_SEQ_ITEM_SV__ 0

class uart_seq_item;
  
  // UART transaction fields
  rand bit [7:0] data;           // Data byte to transmit/receive
  rand bit [1:0] baud_rate;      // Baud rate selection: 0=9600, 1=19200, 2=38400, 3=57600
  rand bit [2:0] data_bits;      // Number of data bits: 3'b000=5, 3'b001=6, 3'b010=7, 3'b011=8
  rand bit [1:0] stop_bits;      // Number of stop bits: 2'b00=1, 2'b01=1.5, 2'b10=2
  rand bit parity_en;            // Parity enable
  rand bit parity_type;          // Parity type: 0=even, 1=odd
  rand bit is_transmit;          // 0=receive, 1=transmit
  
  // Constraints for valid UART configurations
  constraint uart_config_c {
    data inside {[0:255]};
    baud_rate inside {[0:3]};
    data_bits inside {[3'b000:3'b011]};
    stop_bits inside {[2'b00:2'b10]};
    parity_en inside {0, 1};
    parity_type inside {0, 1};
    is_transmit inside {0, 1};
  }

  // Copy function
  virtual function void copy(uart_seq_item rhs);
    this.data = rhs.data;
    this.baud_rate = rhs.baud_rate;
    this.data_bits = rhs.data_bits;
    this.stop_bits = rhs.stop_bits;
    this.parity_en = rhs.parity_en;
    this.parity_type = rhs.parity_type;
    this.is_transmit = rhs.is_transmit;
  endfunction

  // Convert to string for display
  virtual function string to_string();
    string baud_str, databits_str, stopbits_str, parity_str;
    
    case(baud_rate)
      2'b00: baud_str = "9600";
      2'b01: baud_str = "19200";
      2'b10: baud_str = "38400";
      2'b11: baud_str = "57600";
      default: baud_str = "unknown";
    endcase
    
    case(data_bits)
      3'b000: databits_str = "5";
      3'b001: databits_str = "6";
      3'b010: databits_str = "7";
      3'b011: databits_str = "8";
      default: databits_str = "unknown";
    endcase
    
    case(stop_bits)
      2'b00: stopbits_str = "1";
      2'b01: stopbits_str = "1.5";
      2'b10: stopbits_str = "2";
      default: stopbits_str = "unknown";
    endcase
    
    parity_str = parity_en ? (parity_type ? "Odd" : "Even") : "None";
    
    return $sformatf("UART_SEQ_ITEM: Dir=%s, Data=0x%02h, Baud=%s, DataBits=%s, StopBits=%s, Parity=%s",
                     is_transmit ? "TX" : "RX", data, baud_str, databits_str, stopbits_str, parity_str);
  endfunction

  // Print function
  virtual function void print();
    $display("%s", this.to_string());
  endfunction

endclass

`endif
