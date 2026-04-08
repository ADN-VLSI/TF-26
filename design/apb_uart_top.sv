module apb_uart_top (
    input  logic        clk,
    input  logic        rst_n,

    // APB Slave Interface
    input  logic        psel,
    input  logic        penable,
    input  logic [7:0]  paddr,
    input  logic        pwrite,
    input  logic [31:0] pwdata,
    input  logic [3:0]  pstrb,
    output logic        pready,
    output logic [31:0] prdata,
    output logic        pslverr,

    // UART serial pins
    input  logic        rx,
    output logic        tx
);

logic        uart_en;
logic        tx_start;
logic [7:0]  tx_data;
logic [7:0]  rx_data;
logic        rx_valid;
logic        tx_ready;
logic [15:0] baud_div;
logic        tx_busy;
logic        start_request;

assign start_request = uart_en & tx_start;
assign tx_ready = ~tx_busy;

apb_uart_regif regif (
    .pclk(clk),
    .presetn(rst_n),
    .psel(psel),
    .penable(penable),
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .pstrb(pstrb),
    .pready(pready),
    .prdata(prdata),
    .pslverr(pslverr),
    .uart_en(uart_en),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .rx_data(rx_data),
    .rx_valid(rx_valid),
    .tx_ready(tx_ready),
    .baud_div(baud_div)
);

uart_transmitter #(
    .CLK_FREQ(16000000),
    .DATA_BITS(8)
) uart_tx (
    .clk(clk),
    .rst_n(rst_n),
    .baud_div(baud_div),
    .start(start_request),
    .data_in(tx_data),
    .tx(tx),
    .busy(tx_busy)
);

uart_receiver #(
    .CLK_FREQ(16000000),
    .DATA_BITS(8),
    .OVERSAMPLE(16)
) uart_rx (
    .clk(clk),
    .rst_n(rst_n),
    .baud_div(baud_div),
    .rx(rx),
    .data_out(rx_data),
    .data_valid(rx_valid)
);

endmodule
