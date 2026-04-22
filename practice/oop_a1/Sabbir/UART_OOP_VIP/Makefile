# UART OOP VIP Makefile

TOPLEVEL = uart_tb
SRCDIR = .
SIMDIR = sim

# Source files
SOURCES = \
	$(SRCDIR)/uart_if.sv \
	$(SRCDIR)/uart_seq_item.sv \
	$(SRCDIR)/uart_rsp_item.sv \
	$(SRCDIR)/uart_driver.sv \
	$(SRCDIR)/uart_monitor.sv \
	$(SRCDIR)/uart_sequencer.sv \
	$(SRCDIR)/uart_agent.sv \
	$(SRCDIR)/uart_tb.sv

# Simulation tool (Modelsim/Questasim)
VSIM = vsim
VLOG = vlog
VLIB = vlib

# Compile flags
VLOG_FLAGS = -sv

# Simulation flags
VSIM_FLAGS = -batch -do "run -all; quit"

.PHONY: all compile simulate clean gui

all: compile simulate

$(SIMDIR):
	@mkdir -p $(SIMDIR)

work: | $(SIMDIR)
	@$(VLIB) work

compile: work $(SOURCES)
	@echo "Compiling UART OOP VIP..."
	@$(VLOG) $(VLOG_FLAGS) $(SOURCES) -work work

simulate: compile
	@echo "Running simulation..."
	@cd $(SIMDIR) && $(VSIM) -work ../work $(TOPLEVEL) $(VSIM_FLAGS) -l simulation.log
	@echo "Simulation complete. Check simulation.log for details."

gui: compile
	@echo "Opening GUI..."
	@$(VSIM) -work work $(TOPLEVEL) -gui

clean:
	@echo "Cleaning up..."
	@rm -rf work transcript *.log *.vcd $(SIMDIR)
	@echo "Cleanup complete."

help:
	@echo "Available targets:"
	@echo "  make all       - Compile and run simulation"
	@echo "  make compile   - Compile the design"
	@echo "  make simulate  - Run simulation"
	@echo "  make gui       - Open in GUI mode"
	@echo "  make clean     - Remove generated files"
	@echo "  make help      - Show this help message"
