VHDL_FILES = sqrt_3.vhd
VHDL_FILES_TB = sqrt_3_tb.vhd
ENTITY_NAME = sqrt_3_tb
VCD_FILE = waveform.ghw
SIMULATOR = ghdl
STOP_TIME = 10us

all: simulate

compile:
	$(SIMULATOR) -a $(VHDL_FILES)
	$(SIMULATOR) -a $(VHDL_FILES_TB)
elaborate:
	$(SIMULATOR) -e $(ENTITY_NAME)

simulate: compile elaborate
	$(SIMULATOR) -r $(ENTITY_NAME) --wave=$(VCD_FILE) --stop-time=$(STOP_TIME)

clean:
	rm -f $(VCD_FILE) *.o *.cf

show_waves:
	gtkwave $(VCD_FILE)

.PHONY: all compile elaborate simulate clean
