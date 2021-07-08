
# this should allow me to define all of the required repo paths based on a single include
# this will allows us to start from hw or sw
ifdef HW_ROOT
# Software root
RVS_ROOT = $(HW_ROOT)/../rv-software
endif

Q_ENGINE_ROOT=$(HW_ROOT)/hdl/q-engine
IP_LIBRARY_ROOT=$(HW_ROOT)/hdl/ip-library
DATAPATH_ROOT=$(HW_ROOT)/hdl/datapath
RISCV_ROOT=$(HW_ROOT)/hdl/riscv


include $(HW_ROOT)/make_include/verilog_paths.mk



all:
	@echo $(RVS_ROOT)
	@echo ""
	@ls $(RVS_ROOT)
	@ls $(RVS_ROOT)/inc

all2:
	@ls $(RISCV_C_INC_PATH)
# 	@cat $(CRT_STANDARD_PATH)
# 	@cat $(LD_STANDARD_PATH)
# LD_STANDARD_PATH
