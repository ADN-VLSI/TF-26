// UART Sequencer - Generates and sends transactions to driver
// This class generates test sequences and feeds them to the driver

`include "uart_seq_item.sv"

`ifndef __GUARD_UART_SEQUENCER_SV__
`define __GUARD_UART_SEQUENCER_SV__ 0

class uart_sequencer;

  // Mailbox to send transactions to driver
  mailbox #(uart_seq_item) mbx;

  // Constructor
  function new(mailbox #(uart_seq_item) mbx);
    this.mbx = mbx;
  endfunction

  // Send single transaction
  task automatic send_transaction(uart_seq_item item);
    $display("[SEQUENCER] Sending: %s", item.to_string());
    mbx.put(item);
  endtask

  // Generate N random transactions
  task automatic generate_random_transactions(int count);
    uart_seq_item item;
    
    $display("[SEQUENCER] Generating %0d random transactions...", count);
    
    for (int i = 0; i < count; i++) begin
      item = new();
      if (!item.randomize()) begin
        $error("[SEQUENCER] Randomization failed for transaction %0d", i);
      end else begin
        send_transaction(item);
      end
    end
  endtask

  // Generate transmit sequence
  task automatic generate_transmit_sequence(int count);
    uart_seq_item item;
    
    $display("[SEQUENCER] Generating transmit sequence with %0d transactions...", count);
    
    for (int i = 0; i < count; i++) begin
      item = new();
      item.is_transmit = 1;
      if (!item.randomize()) begin
        $error("[SEQUENCER] Randomization failed for TX transaction %0d", i);
      end else begin
        send_transaction(item);
      end
    end
  endtask

  // Generate receive sequence
  task automatic generate_receive_sequence(int count);
    uart_seq_item item;
    
    $display("[SEQUENCER] Generating receive sequence with %0d transactions...", count);
    
    for (int i = 0; i < count; i++) begin
      item = new();
      item.is_transmit = 0;
      if (!item.randomize()) begin
        $error("[SEQUENCER] Randomization failed for RX transaction %0d", i);
      end else begin
        send_transaction(item);
      end
    end
  endtask

  // Generate specific data pattern sequence
  task automatic generate_pattern_sequence(bit [7:0] pattern[], int repeat = 1);
    uart_seq_item item;
    
    $display("[SEQUENCER] Generating pattern sequence with %0d pattern(s)...", repeat);
    
    for (int r = 0; r < repeat; r++) begin
      foreach (pattern[i]) begin
        item = new();
        item.data = pattern[i];
        if (!item.randomize()) begin
          $error("[SEQUENCER] Randomization failed for pattern transaction");
        end else begin
          send_transaction(item);
        end
      end
    end
  endtask

endclass

`endif
