
.PHONY: genriscv all

all:
	@echo ""
	@echo "This is the Makefile for the hardware repo"
	@echo ""
	@echo "Targets:"
	@echo "  genriscv"
	@echo ""

genriscv:
	make -C hdl/riscv/ genriscv
