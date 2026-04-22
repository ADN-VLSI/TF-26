// UART Response Item - Extends sequence item with response fields
// This class adds response-specific fields to track completion and errors

`include "uart_seq_item.sv"

`ifndef __GUARD_UART_RSP_ITEM_SV__
`define __GUARD_UART_RSP_ITEM_SV__ 0

class uart_rsp_item extends uart_seq_item;

  // Response fields
  bit [7:0] rx_data;            // Received data
  bit rx_done;                  // Reception complete flag
  bit parity_error;             // Parity error flag
  bit framing_error;            // Framing error flag
  bit overflow_error;           // Overflow error flag

  // Copy function
  virtual function void copy(uart_rsp_item rhs);
    super.copy(rhs);
    this.rx_data = rhs.rx_data;
    this.rx_done = rhs.rx_done;
    this.parity_error = rhs.parity_error;
    this.framing_error = rhs.framing_error;
    this.overflow_error = rhs.overflow_error;
  endfunction

  // Convert to string for display
  virtual function string to_string();
    string status_str = "";
    
    if (rx_done)
      status_str = "SUCCESS";
    else if (parity_error)
      status_str = "PARITY_ERROR";
    else if (framing_error)
      status_str = "FRAMING_ERROR";
    else if (overflow_error)
      status_str = "OVERFLOW_ERROR";
    else
      status_str = "PENDING";
    
    return $sformatf("UART_RSP_ITEM: %s, RxData=0x%02h, Status=%s",
                     super.to_string().substr(15, super.to_string().len()-1),
                     rx_data, status_str);
  endfunction

endclass

`endif
