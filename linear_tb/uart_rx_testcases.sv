/////////////////////////////////////////////////////
// UART RX TEST CASES 
/////////////////////////////////////////////////////


// --------------------------------------------------
// TEST 1 : Basic receive (0xA5)
// --------------------------------------------------
task test_1_basic();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST1] Basic RX 0xA5");

  uart_if.send_tx(8'hA5);
  uart_if.recv_rx(data, parity);

  if (data === 8'hA5)
    $display("PASS TEST1");
  else
    $display("FAIL TEST1");
endtask


// --------------------------------------------------
// TEST 2 : Zero data (0x00)
// --------------------------------------------------
task test_2_zero();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST2] RX 0x00");

  uart_if.send_tx(8'h00);
  uart_if.recv_rx(data, parity);

  if (data === 8'h00)
    $display("PASS TEST2");
  else
    $display("FAIL TEST2");
endtask


// --------------------------------------------------
// TEST 3 : All ones (0xFF)
// --------------------------------------------------
task test_3_ff();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST3] RX 0xFF");

  uart_if.send_tx(8'hFF);
  uart_if.recv_rx(data, parity);

  if (data === 8'hFF)
    $display("PASS TEST3");
  else
    $display("FAIL TEST3");
endtask


// --------------------------------------------------
// TEST 4 : Even parity correct
// --------------------------------------------------
task test_4_even_parity();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST4] Even parity test");

  uart_if.send_tx(8'h55, .parity_enable(1), .parity_type(0));
  uart_if.recv_rx(data, parity);

  $display("DATA=%0h PARITY=%0b", data, parity);
endtask


// --------------------------------------------------
// TEST 5 : Odd parity correct
// --------------------------------------------------
task test_5_odd_parity();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST5] Odd parity test");

  uart_if.send_tx(8'h55, .parity_enable(1), .parity_type(1));
  uart_if.recv_rx(data, parity);

  $display("DATA=%0h PARITY=%0b", data, parity);
endtask


// --------------------------------------------------
// TEST 6 : Parity error injection
// --------------------------------------------------
task test_6_parity_error();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST6] Parity ERROR injection");

  uart_if.send_tx(8'h55, .parity_enable(1), .parity_type(0), .flip_parity(1));
  uart_if.recv_rx(data, parity);

  $display("PARITY ERROR TEST DONE");
endtask


// --------------------------------------------------
// TEST 7 : Bad stop bit (framing error)
// --------------------------------------------------
task test_7_bad_stop();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST7] Bad stop bit");

  uart_if.send_tx(8'h5A, .bad_stop(1));
  uart_if.recv_rx(data, parity);

  $display("FRAMING ERROR TEST DONE");
endtask


// --------------------------------------------------
// TEST 8 : Back-to-back frames
// --------------------------------------------------
task test_8_back_to_back();
  logic [7:0] data;
  logic parity;

  $display("\n[TEST8] Back-to-back RX");

  uart_if.send_tx(8'h12);
  uart_if.recv_rx(data, parity);

  uart_if.send_tx(8'h34);
  uart_if.recv_rx(data, parity);

  $display("BACK-TO-BACK DONE");
endtask