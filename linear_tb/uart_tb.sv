module uart_tb;


  // | Register      | Access | Address | Reset Value | Description                                                 |
  // | ------------- | ------ | ------- | ----------- | ----------------------------------------------------------- |
  // | CTRL          | RW     | 0x00    | 0x0         | Control register for clock enable and FIFO flush operations |
  // | CLK_DIV       | RW     | 0x04    | 0x28B0      | Clock divider register for baud rate generation             |
  // | CFG           | RW     | 0x08    | 0x0         | UART configuration register for parity and stop bits        |
  // | TX_FIFO_COUNT | RO     | 0x0C    | 0x0         | Transmit FIFO data count (read-only)                        |
  // | RX_FIFO_COUNT | RO     | 0x10    | 0x0         | Receive FIFO data count (read-only)                         |
  // | TX_DATA       | WO     | 0x14    | 0x0         | Transmit data register (write-only)                         |
  // | RX_DATA       | RO     | 0x18    | 0x0         | Receive data register (read-only)                           |
  // | INTR_CTRL     | RW     | 0x1C    | 0x0         | Interrupt control register                                  |

  localparam int CTRL_ADDR = 'h00;
  localparam int CLK_DIV_ADDR = 'h04;
  localparam int CFG_ADDR = 'h08;
  localparam int TX_FIFO_COUNT_ADDR = 'h0C;
  localparam int RX_FIFO_COUNT_ADDR = 'h10;
  localparam int TX_DATA_ADDR = 'h14;
  localparam int RX_DATA_ADDR = 'h18;
  localparam int INTR_CTRL_ADDR = 'h1C;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNAL DECLARATIONS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic irq_tx_almost_full;
  logic irq_rx_almost_full;
  logic irq_rx_parity_error;
  logic irq_rx_valid;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // INTERFACE DECLARATIONS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  ctrl_if ctrl_intf ();

  apb_if apb_intf (
      .arst_ni(ctrl_intf.arst_ni),
      .clk_i  (ctrl_intf.clk_i)
  );

  uart_if uart_intf ();

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // DUT DECLARATIONS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  uart_top dut (
      .arst_ni(ctrl_intf.arst_ni),
      .clk_i(ctrl_intf.clk_i),
      .psel_i(apb_intf.psel),
      .penable_i(apb_intf.penable),
      .paddr_i(apb_intf.paddr),
      .pwrite_i(apb_intf.pwrite),
      .pwdata_i(apb_intf.pwdata),
      .pstrb_i(apb_intf.pstrb),
      .pready_o(apb_intf.pready),
      .prdata_o(apb_intf.prdata),
      .pslverr_o(apb_intf.pslverr),
      .rx_i(uart_intf.tx),
      .tx_o(uart_intf.rx),
      .irq_tx_almost_full(irq_tx_almost_full),
      .irq_rx_almost_full(irq_rx_almost_full),
      .irq_rx_parity_error(irq_rx_parity_error),
      .irq_rx_valid(irq_rx_valid)
  );

  task automatic write_read_check(input int addr, input int bit_count);
    logic [31:0] rdata;
    bit OK;
    OK = 1;

    apb_intf.write(addr, '0);
    apb_intf.read(addr, rdata);
    if (rdata !== '0) begin
      OK = 0;
      $display("ERROR: Expected reset value 0x0, got 0x%h", rdata);
    end else begin
      apb_intf.write(addr, '1);
      apb_intf.read(addr, rdata);
      for (int i = 0; i < 32; i++) begin
        if (rdata[i] !== (i < bit_count)) begin
          OK = 0;
          $display("ERROR: Bit %0d did not set correctly, got 0b%b", i, rdata[i]);
          break;
        end
      end
    end

    if (!OK) begin
      $display("FAILURE: Address 0x%h failed write-read check", addr);
      $fatal(1, "\033[1;31mTEST FAILED\033[0m");
    end
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURAL BLOCKS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin
    string test;

    if (!$value$plusargs("TEST=%s", test)) begin
      $fatal(1, "\033[1;31mERROR: No test specified. Use +test=<TEST_NAME> to specify a test.\033[0m");
    end

    $timeformat(-6, 0, "us");
    $dumpfile("uart_tb.vcd");
    $dumpvars(0, uart_tb);

    ctrl_intf.apply_reset();
    ctrl_intf.enable_clock();

    case (test)

      "RWA": begin
        write_read_check(CTRL_ADDR, 3);
        write_read_check(CLK_DIV_ADDR, 32);
        write_read_check(CFG_ADDR, 3);
        write_read_check(INTR_CTRL_ADDR, 4);
      end

      default: begin
        $fatal(1, "\033[1;31mERROR: Unknown test '%s'\033[0m", test);
      end

    endcase


    $display("\033[1;32mTEST PASSED\033[0m");

    $finish;
  end

endmodule
