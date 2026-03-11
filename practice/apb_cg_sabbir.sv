covergroup cg_apb with function sample(
    bit PSEL, bit PENABLE, bit PWRITE,
    bit [7:0] PADDR, bit [31:0] PWDATA, bit [31:0] PRDATA,
    bit PREADY, bit PSLVERR
);

  //Operation coverage (read/write)
  coverpoint PWRITE {
    bins READ  = {0};
    bins WRITE = {1};
  }

  //Address coverage
  coverpoint PADDR {
    bins ADDR_LOW   = {[0:63]};
    bins ADDR_MID   = {[64:127]};
    bins ADDR_HIGH  = {[128:255]};
  }

  // Write data coverage
  coverpoint PWDATA {
    bins ZERO      = {0};
    bins SMALL     = {[1:100]};
    bins MEDIUM    = {[101:1000]};
    bins LARGE     = {[1001:32'hFFFF_FFFF]};
  }

  //Read data coverage
  coverpoint PRDATA {
    bins ZERO      = {0};
    bins NONZERO   = {[1:32'hFFFF_FFFF]};
  }

  //Ready / wait state coverage
  coverpoint PREADY {
    bins READY = {1};
    bins WAIT  = {0};
  }

  //Error response coverage
  coverpoint PSLVERR {
    bins NO_ERROR = {0};
    bins ERROR    = {1};
  }

  //Cross coverage
  cross x_op_addr : cross PWRITE, PADDR;       // read/write × address
  cross x_op_err  : cross PWRITE, PSLVERR;    // read/write × error
  cross x_op_ready: cross PWRITE, PREADY;     // read/write × wait state

endgroup