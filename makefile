all:
	@ghdl -a mux.vhd d_latch.vhd bsc.vhd bsr.vhd
	@ghdl -e bsr
	@./bsr
	@rm -f *.o *.cf
	@rm -f mux d_latch bsc bsr
	@echo "Compilation successful!"
