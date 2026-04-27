`include "addr_def.sv"

`include "uart_seq_item.sv"
`include "uart_rsp_item.sv"
`include "uart_driver.sv"
`include "uart_monitor.sv"

module uart_vip_tb;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // LCOAL PARAMETER DECLARATIONS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  localparam int debug = 1;
  int status;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // INTERFACE INSTANCES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  uart_if uart_intf ();

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // CLASS INSTANCES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  mailbox #(uart_seq_item) uart_dvr_mbx;
  mailbox #(uart_rsp_item) uart_mon_mbx;
  uart_driver uart_dvr;
  uart_monitor uart_mon;

  assign uart_intf.rx = uart_intf.tx;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURAL BLOCKS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin

    automatic int pass;
    automatic int fail;
    automatic int num_rx;

    status = 0;

    $dumpfile("uart_vip_tb.vcd");
    $dumpvars(0, uart_vip_tb);
    $timeformat(-3, 2, "ms");

    uart_dvr_mbx = new(1);
    uart_dvr = new(uart_intf, uart_dvr_mbx);

    uart_mon_mbx = new();
    uart_mon = new(uart_intf, uart_mon_mbx);

    uart_dvr.run();
    uart_mon.run();

    uart_intf.DATA_BITS = 'd8;
    #100us;
    status = 1;


    begin
      automatic string dut_rx_string = "H123";
      for (int i = 0; i < dut_rx_string.len(); i++) begin
        uart_seq_item item;
        item = new();
        item.data = dut_rx_string[i];  // only the least significant byte will be considered
        item.baud_rate = uart_intf.BAUD_RATE;
        item.parity_enable = uart_intf.PARITY_ENABLE;
        item.parity_type = uart_intf.PARITY_TYPE;
        item.second_stop_bit = uart_intf.SECOND_STOP_BIT;
        item.data_bits = uart_intf.DATA_BITS;
        uart_dvr_mbx.put(item);
      end
    end

    status = 2;
    uart_mon.wait_till_idle();
    status = 3;

    while (uart_mon_mbx.num() > 0) begin
      uart_rsp_item item;
      uart_mon_mbx.get(item);
      item.print();
    end

    #100us;
    status = 4;

    $finish;
  end

  initial begin
    fork
      forever begin
        #10us;
        $display("  %0t       \033[1A\033[0G", $realtime);
      end
    join_none
    #10ms;
    $fatal(1, "\033[1;31mTEST TIMED OUT\033[0m");
  end

endmodule
