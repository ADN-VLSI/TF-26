// Include guard to prevent multiple inclusions of this file
`ifndef __GUARD_UART_TOP_SCBD_SV__
`define __GUARD_UART_TOP_SCBD_SV__ 0

// Include response item classes
`include "addr_def.sv"
`include "obj/apb_rsp_item.sv"
`include "obj/uart_rsp_item.sv"

// `include "coverage/test_status_cg.sv"
// `include "coverage/uart_transactions_cg.sv"
// `include "coverage/apb_transactions_cg.sv"
// `include "coverage/apb_uart_reg_access_cg.sv"

// Declare analysis implementation ports for APB and UART
`uvm_analysis_imp_decl(_apb)
`uvm_analysis_imp_decl(_uart)

// APB UART Scoreboard
// This UVM scoreboard compares APB transactions with UART transactions
// to verify data integrity and configuration settings.
class uart_top_scbd extends uvm_scoreboard;

  // UVM component utilities for factory registration
  `uvm_component_utils(uart_top_scbd)

  virtual uart_if uart_intf;

  int pass_count;
  int fail_count;

  // Analysis implementation ports for receiving items from monitors
  uvm_analysis_imp_apb #(apb_rsp_item, uart_top_scbd) m_analysis_imp_apb;
  uvm_analysis_imp_uart #(uart_rsp_item, uart_top_scbd) m_analysis_imp_uart;

  // Queues to store received items
  protected apb_rsp_item apb_q[$];
  protected byte uart_tx_q[$];
  protected byte uart_rx_q[$];

  // test_status_cg         status_cg;
  // uart_transactions_cg   uart_cg;
  // apb_transactions_cg    apb_cg;
  // apb_uart_reg_access_cg reg_cg;

  // Constructor for the APB UART scoreboard
  function new(string name = "uart_top_scbd", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // Build phase: create analysis implementation ports
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create an instance of each analysis implementation
    m_analysis_imp_apb  = new($sformatf("m_analysis_imp_apb"), this);
    m_analysis_imp_uart = new($sformatf("m_analysis_imp_uart"), this);
    // // Instantiate the coverage group
    // status_cg = new();
    // uart_cg   = new();
    // apb_cg    = new();
    // reg_cg    = new();
  endfunction

  // Connect phase: retrieve virtual interfaces from configuration
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (!uvm_config_db#(virtual uart_if)::get(
            uvm_root::get(), "uart", "uart_intf", uart_intf
        )) begin
      `uvm_fatal("NOVIF", "Virtual interface 'uart_intf' not found in config DB")
    end

  endfunction

  // Write function for APB analysis port: store APB items
  function void write_apb(apb_rsp_item item);
    `uvm_info(get_type_name(), $sformatf("Received APB item: %s", item.sprint()), UVM_HIGH)

    // apb_cg.sample(
    //   item.pwrite,
    //   item.pstrb,
    //   item.pslverr
    // );

    // reg_cg.sample(
    //   item.paddr[4:0],
    //   item.pwrite
    // );

    apb_q.push_back(item);
  endfunction

  // Write function for UART analysis port: store UART items based on intf_tx
  function void write_uart(uart_rsp_item item);
    `uvm_info(get_type_name(), $sformatf("Received UART item: %s", item.sprint()), UVM_HIGH)

    // uart_cg.sample(
    //   item.intf_tx,
    //   item.data,
    //   item.baud_rate,
    //   item.parity_enable,
    //   item.parity_type,
    //   item.second_stop_bit
    // );

    if (item.intf_tx === '0) begin
      uart_tx_q.push_back(item.data);
    end
    if (item.intf_tx === '1) begin
      uart_rx_q.push_back(item.data);
    end
  endfunction

  // Run phase: process APB items and perform comparisons
  task run_phase(uvm_phase phase);
    forever begin
      apb_rsp_item apb_item;
      // Wait for APB items in the queue
      wait (apb_q.size());
      apb_item = apb_q.pop_front();
      // Handle different APB addresses and operations
      if (apb_item.slverr == 0 && apb_item.write == 1 && apb_item.addr == `CLK_DIV_ADDR) begin
        // Set baud rate configuration
        uart_intf.BAUD_RATE = (100_000_000 / apb_item.data);
      end else if (apb_item.slverr == 0 && apb_item.write == 1 && apb_item.addr == `CFG_ADDR) begin
        // Set parity configuration
        uart_intf.PARITY_ENABLE   = apb_item.data[0];
        uart_intf.PARITY_TYPE     = apb_item.data[1];
        uart_intf.SECOND_STOP_BIT = apb_item.data[2];
      end else if (apb_item.slverr == 0 && apb_item.write == 1 && apb_item.addr == `TX_DATA_ADDR) begin
        // Compare TX data
        byte data;
        wait (uart_tx_q.size());
        data = uart_tx_q.pop_front();
        if (data == apb_item.data[7:0]) begin
          // status_cg.sample(1);
          pass_count++;
          `uvm_info(get_type_name(), $sformatf("TX Data Match: 0x%0h", data), UVM_HIGH)
        end else begin
          // status_cg.sample(0);
          fail_count++;
          `uvm_error(get_type_name(), $sformatf(
                     "TX Data Mismatch: APB 0x%0h, UART 0x%0h", apb_item.data[7:0], data))
        end
      end else if (apb_item.slverr == 0 && apb_item.write == 0 && apb_item.addr == `RX_DATA_ADDR) begin
        // Compare RX data
        byte data;
        wait (uart_rx_q.size());
        data = uart_rx_q.pop_front();
        if (data == apb_item.data[7:0]) begin
          // status_cg.sample(1);
          pass_count++;
          `uvm_info(get_type_name(), $sformatf("RX Data Match: 0x%0h", data), UVM_HIGH)
        end else begin
          // status_cg.sample(0);
          fail_count++;
          `uvm_error(get_type_name(), $sformatf(
                     "RX Data Mismatch: UART 0x%0h, APB 0x%0h", data, apb_item.data[7:0]))
        end
      end
    end

  endtask

  // Report phase: display test results
  function void report_phase(uvm_phase phase);
  //   `uvm_info(get_type_name(), $sformatf("---- Coverage Summary ----"), UVM_NONE)
  //   `uvm_info(get_type_name(), $sformatf("apb     : %0.2f%%", apb_cg.get_coverage()), UVM_NONE)
  //   `uvm_info(get_type_name(), $sformatf("uart    : %0.2f%%", uart_cg.get_coverage()), UVM_NONE)
  //   `uvm_info(get_type_name(), $sformatf("reg     : %0.2f%%", reg_cg.get_coverage()), UVM_NONE)
  //   `uvm_info(get_type_name(), $sformatf("OVERALL : %0.2f%%", ((apb_cg.get_coverage() + uart_cg.get_coverage() + reg_cg.get_coverage())/3.0)), UVM_NONE)
  //   `uvm_info(get_type_name(), "--------------------------", UVM_NONE)

  //   if (status_cg.status.fail.get_coverage() > 0) begin
  //     `uvm_error(get_type_name(), "Test FAILED")
  //   end else begin
  //     `uvm_info(get_type_name(), "Test PASSED", UVM_NONE)
  //   end

  `uvm_info(get_type_name(), $sformatf("Total Pass: %0d, Total Fail: %0d", pass_count, fail_count), UVM_NONE)

  if (fail_count) `uvm_error(get_type_name(), "\033[1;31mTest FAILED\033[0m]")
  else `uvm_info(get_type_name(), "\033[1;32mTest PASSED\033[0m]", UVM_NONE)
  endfunction

endclass

`endif
