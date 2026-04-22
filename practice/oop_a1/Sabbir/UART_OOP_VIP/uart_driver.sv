// UART Driver - Drives transactions to the UART interface
// This class handles transmission of UART transactions to the DUT

`include "uart_seq_item.sv"

`ifndef __GUARD_UART_DRIVER_SV__
`define __GUARD_UART_DRIVER_SV__ 0

class uart_driver;

  // Virtual interface handle
  virtual uart_if intf;
  
  // Mailbox to receive transactions from sequencer
  mailbox #(uart_seq_item) mbx;

  // Constructor
  function new(virtual uart_if intf, mailbox #(uart_seq_item) mbx);
    this.intf = intf;
    this.mbx = mbx;
  endfunction

  // Reset task
  task automatic reset();
    $display("[DRIVER] Resetting UART interface...");
    intf.reset();
  endtask

  // Main driver loop
  task automatic run();
    uart_seq_item item;
    
    fork
      forever begin
        // Wait for transaction from sequencer
        mbx.get(item);
        
        $display("[DRIVER] Received transaction: %s", item.to_string());
        
        // Configure UART based on sequence item
        configure_uart(item);
        
        // Execute transaction
        if (item.is_transmit) begin
          transmit_byte(item.data);
        end else begin
          receive_byte(item);
        end
      end
    join_none
  endtask

  // Configure UART settings
  task automatic configure_uart(uart_seq_item item);
    $display("[DRIVER] Configuring: Baud=%0d, DataBits=%0d, StopBits=%0d, Parity=%0d",
             item.baud_rate, item.data_bits, item.stop_bits, item.parity_en);
    
    // Call interface method to configure UART
    intf.configure(item.baud_rate, item.data_bits, item.stop_bits, 
                   item.parity_en, item.parity_type);
  endtask

  // Transmit byte
  task automatic transmit_byte(bit [7:0] data);
    $display("[DRIVER] Transmitting byte: 0x%02h", data);
    intf.transmit(data);
  endtask

  // Receive byte
  task automatic receive_byte(uart_seq_item item);
    bit [7:0] data;
    $display("[DRIVER] Waiting to receive byte...");
    intf.receive(data);
    $display("[DRIVER] Received byte: 0x%02h", data);
    item.data = data;
  endtask

endclass

`endif
