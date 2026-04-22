// UART OOP Testbench - Main testbench using VIP approach
// This testbench demonstrates the usage of UART OOP VIP components

`include "uart_if.sv"
`include "uart_agent.sv"

`ifndef __GUARD_UART_TB_SV__
`define __GUARD_UART_TB_SV__ 0

module uart_tb;

  // Clock and reset
  bit clk;
  bit rst;

  // Instantiate interface
  uart_if uart_intf(clk, rst);

  // Instantiate UART agent
  uart_agent agent;

  // Test sequence
  initial begin
    $display("\n========================================");
    $display("    UART OOP VIP Testbench Started");
    $display("========================================\n");

    // Create agent
    agent = new(uart_intf);

    // Reset sequence
    agent.reset();
    
    // Run driver and monitor
    agent.run();

    // Test Case 1 (Simple transmit test)
    $display("\n--- Test Case 1: Simple Transmit ---");
    test_simple_transmit();

    // Test Case 2 (Random transactions)
    $display("\n--- Test Case 2: Random Transactions ---");
    test_random_transactions();

    // Test Case 3 (Transmit sequence)
    $display("\n--- Test Case 3: Transmit Sequence ---");
    test_transmit_sequence();

    // Test Case 4 (Receive sequence)
    $display("\n--- Test Case 4: Receive Sequence ---");
    test_receive_sequence();

    // Test Case 5 (Pattern test)
    $display("\n--- Test Case 5: Pattern Test ---");
    test_pattern();

    // Final checks
    $display("\n========================================");
    if (agent.has_errors()) begin
      $display("    TEST FAILED - Errors detected");
    end else begin
      $display("    TEST PASSED - No errors");
    end
    $display("========================================\n");

    $finish;
  end

  // Test Case 1 (Simple transmit)
  task test_simple_transmit();
    uart_seq_item item;
    item = new();
    item.is_transmit = 1;
    item.data = 8'hAA;
    item.baud_rate = 2'b00;
    item.randomize();
    
    agent.sequencer.send_transaction(item);
    agent.wait_for_idle(10);
  endtask

  // Test Case 2 (Random transactions)
  task test_random_transactions();
    agent.sequencer.generate_random_transactions(5);
    agent.wait_for_idle(20);
  endtask

  // Test Case 3 (Transmit sequence)
  task test_transmit_sequence();
    agent.sequencer.generate_transmit_sequence(3);
    agent.wait_for_idle(30);
  endtask

  // Test Case 4(Receive sequence)
  task test_receive_sequence();
    agent.sequencer.generate_receive_sequence(3);
    agent.wait_for_idle(30);
  endtask

  // Test Case 5 (Pattern test)
  task test_pattern();
    bit [7:0] pattern[4] = {8'hAA, 8'h55, 8'hFF, 8'h00};
    agent.sequencer.generate_pattern_sequence(pattern, 1);
    agent.wait_for_idle(20);
  endtask

  // Clock generation
  always begin
    #10ns clk = ~clk;
  end

  // Reset generation
  initial begin
    rst = 1;
    #50ns;
    rst = 0;
  end

endmodule

`endif
