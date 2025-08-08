# GHDL options
GHDL = ghdl
GHDL_OPTS = --std=08 --workdir=$(WORK_DIR)

# Library options
WORK_DIR = ./work

# Source files
VHDL_SOURCES = \
	gps_ca_code.vhd \
	tb_gps_ca_code.vhd

# Top Level entity
TOP_ENTITY = tb_gps_ca_code

# Simulation options
TIME_STOP = 1ms
GTK_OPTS = --rcvar 'fontname_signals Monospace 20' --rcvar 'fontname_waves Monospace 20'

# Default target
.PHONY: all
all: analyze elaborate simulate

.PHONY: analyze
analyze: $(VHDL_SOURCES)
	@mkdir -p $(WORK_DIR)
	@$(GHDL) -i $(GHDL_OPTS) $^

.PHONY: elaborate
elaborate: analyze
	@$(GHDL) -m $(GHDL_OPTS) -o ./work/$(TOP_ENTITY) $(TOP_ENTITY)

.PHONY: simulate
simulate: elaborate
	cd $(WORK_DIR); $(GHDL) -r $(TOP_ENTITY) --vcd=$(TOP_ENTITY).vcd --stop-time=$(TIME_STOP)

.PHONY: view
view:
	gtkwave $(WORK_DIR)/$(TOP_ENTITY).vcd $(TOP_ENTITY).gtkw $(GTK_OPTS) &

# Target for cleaning up
.PHONY: clean
clean:
	rm -rf $(WORK_DIR)
	rm -f *.vcd

