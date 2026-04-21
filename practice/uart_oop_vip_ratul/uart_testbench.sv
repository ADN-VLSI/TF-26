`include "uart_seq_item.sv"
`include "uart_rsp_item.sv"
`include "uart_driver.sv"
`include "uart_monitor.sv"
`include "uart_cfg.sv"

module uart_testbench;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNAL DECLARATIONS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // INTERFACE INSTANCES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  ctrl_if ctrl_intf ();

  uart_if uart_intf (
      .clk(ctrl_intf.clk_i),
      .rst_n(ctrl_intf.arst_ni)
  );

  // Loopback for testing
  assign uart_intf.rx = uart_intf.tx;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // CLASS INSTANCES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  mailbox #(uart_seq_item) uart_dvr_mbx;
  mailbox #(uart_rsp_item) uart_mon_mbx;
  uart_driver dvr;
  uart_monitor mon;
  uart_cfg cfg;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURAL BLOCKS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin

    $dumpfile("uart_testbench.vcd");
    $dumpvars(0, uart_testbench);
    $timeformat(-3, 2, "ms");

    cfg = new();
    cfg.print();

    uart_dvr_mbx = new(1);
    dvr = new(uart_intf, uart_dvr_mbx);

    uart_mon_mbx = new();
    mon = new(uart_intf, uart_mon_mbx);

    ctrl_intf.apply_reset();
    dvr.reset();

    ctrl_intf.enable_clock();
    dvr.run();
    mon.run();

    begin
      automatic uart_seq_item seq_item;

      seq_item = new();
      seq_item.randomize();
      seq_item.is_tx = 1'b1;
      seq_item.delay = 100;
      uart_dvr_mbx.put(seq_item);
      
      seq_item = new();
      seq_item.is_tx = 1'b0;
      seq_item.delay = 100;
      uart_dvr_mbx.put(seq_item);
    end

    mon.wait_till_idle();

    while (uart_mon_mbx.num()) begin
      uart_rsp_item item;
      uart_mon_mbx.get(item);
      item.print();
    end

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
