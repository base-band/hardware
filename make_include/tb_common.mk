
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

# if we change how this project is verilated, this will change
# Q_ENGINE_VERILATOR_TOP=q_engine

BOARD_TB_TOP=tb_higgs_top
VER_BINARY = V$(BOARD_TB_TOP)

VERILATOR_TEST_DIR?=.

include $(HW_ROOT)/make_include/sim_verilator.mk



VER_CPP_INCLUDE_PATH=$(HW_ROOT)/csrc


# path should be relative to where this makefile is (repo root)
# VER_CPP_INCLUDE_PATH=../inc

VER_HDL_PATH=../inc

VER_INCLUDE_DIRS=\
-I../../hdl  \
-I. \
-I$(VER_CPP_INCLUDE_PATH) \
$(BOARD_INCLUDE_PATHS)

VER_TOP=--top-module $(BOARD_TB_TOP) +define+VERILATE +define+VERILATE_DEF +define+LOAD_VMEM

# -I$(HIGGS_ROOT)/fpgas/packages \
# -I$(HIGGS_ROOT)/fpgas/common/modules/eb2a \
# -I$(IP_LIBRARY_REPO)/lattice_support/gbit_mac/packages

VER_TOP=--top-module $(BOARD_TB_TOP) +define+VERILATE +define+VERILATE_DEF +define+LOAD_VMEM


VER_SOURCES= $(HIGGS_TB_ALL_VERILOG) $(Q_ENGINE_ALL_VERILOG) $(D_ENGINE_ALL_VERILOG)

EXTRA_CPP_FILES?=""
# EXTRA_CPP_FILES+=$(RISCV_BASEBAND_REPO)/c/inc/feedback_bus.c
EXTRA_CPP_FILES+=$(RVS_ROOT)/inc/feedback_bus.c
EXTRA_CPP_FILES+=$(RVS_ROOT)/inc/random.c
# EXTRA_CPP_FILES+=$(RISCV_BASEBAND_REPO)/c/inc/schedule.c
EXTRA_CPP_FILES+=$(HW_ROOT)/csrc/FileUtils.cpp
EXTRA_CPP_FILES+=$(HW_ROOT)/csrc/convert.cpp
EXTRA_CPP_FILES+=$(HW_ROOT)/csrc/CmdRunner.cpp
# EXTRA_CPP_FILES+=$(SMODEM_REPO)/soapy/src/common/CmdRunner.cpp
# EXTRA_CPP_FILES+=$(SMODEM_REPO)/soapy/src/common/convert.cpp
# EXTRA_CPP_FILES+=$(SMODEM_REPO)/soapy/src/common/GenericOperator.cpp



EXTRA_VERILATOR_ARGS?=""


THIS_FILE=Makefile
CPP_TB_FILES= tb.cpp
CPP_TB_FILES+= $(EXTRA_CPP_FILES)



# this path is relative to where this makefile is because it gets expanded here and
# passed to verilator
CPP_TB_FILES+= $(wildcard $(VER_CPP_INCLUDE_PATH)/*.cpp)

C_SRC = ./c/src



# try:
#   --trace-fst
VER_FLAGS = -Wno-PINMISSING --trace 
# VER_FLAGS = --trace  -Wall 


VER_FLAGS += -DVERILATE_DEF


ADDCFLAGS += -CFLAGS -DCS21_IS_DENGINE
ADDCFLAGS += -CFLAGS -pthread
ADDCFLAGS += -CFLAGS -g
ADDCFLAGS += -CFLAGS -fPIC
ADDCFLAGS += -CFLAGS -MMD
ADDCFLAGS += -CFLAGS -MP
ADDCFLAGS += -CFLAGS -std=c++11
ADDCFLAGS += -CFLAGS -Werror=return-type
ADDCFLAGS += -CFLAGS -Werror=overflow
ADDCFLAGS += -CFLAGS -Werror=array-bounds
# ADDCFLAGS += -CFLAGS -Wpedantic
# ADDCFLAGS += -CFLAGS -Wshadow
ADDCFLAGS += -CFLAGS -Werror=shift-count-overflow
ADDCFLAGS += -CFLAGS -Wpointer-arith
ADDCFLAGS += -CFLAGS -Wcast-qual
ADDCFLAGS += -CFLAGS -DVERILATE_TESTBENCH
ADDCFLAGS += -LDFLAGS -pthread

# path is relative to obj_dir (So some variables will have a ../ prepended)
ADDCFLAGS += -CFLAGS -I../$(VER_CPP_INCLUDE_PATH)
# ADDCFLAGS += -CFLAGS -I../$(RISCV_BASEBAND_REPO)/verilator/inc
# it may seem weird but we can include the same file from both the TB and from the Riscv itself (this include path is for the TB's sake)
ADDCFLAGS += -CFLAGS -I../$(RVS_ROOT)/inc
# ADDCFLAGS += -CFLAGS -I../$(SMODEM_REPO)/soapy/src
# ADDCFLAGS += -CFLAGS -I../$(SMODEM_REPO)/soapy/src/common
# ADDCFLAGS += -CFLAGS -I../$(SMODEM_REPO)/soapy/src/driver
# ADDCFLAGS += -CFLAGS -I../$(SMODEM_REPO)/soapy/src/3rd/schifra
ADDCFLAGS += -CFLAGS -I/usr/local/share/verilator/include


ifdef IS_VERILATOR_DEF
ADDCFLAGS += -CFLAGS -DIS_VERILATOR_DEF
endif



# Extra ld flags, however they need to be in verilator format
EXTRA_LD_FLAGS=-LDFLAGS -lzmq

ifdef EXTRA_LD_FLAGS
ADDCFLAGS += $(EXTRA_LD_FLAGS)
endif



.PHONY: all test compilehex run_only run verilate compile cleanall trun runt vall
.PHONY: test_dependencies no_clean_test no_clean_test_dependencies pre_work 
.PHONY: test_post_check gensigs vall_subtree


all: cleanall compilehex verilate verilator_parse_syms compile trun

# no clean prework, that compiles as much as we can without running test
pre_work: compilehex verilate verilator_parse_syms compile

no_clean_test_dependencies: compilehex verilate verilator_parse_syms compile run

no_clean_test: no_clean_test_dependencies

# define dependencies of the test target,
# this means that a makefile that wants to override this can still respect
# what this tb_common.mk file wants to do
test_dependencies: cleanall compilehex verilate verilator_parse_syms compile run

test: test_dependencies

test_post_check:
	@echo "This test does not have post-run check"

vall: compilehex

vall_subtree:
	$(call invoke_c_override_submake)

vclean:
	$(call invoke_c_override_clean)

# please note that this will build all default .hex files as well as
# particular overrided ones.  The default compiles are wasted and the output is not used
# if they are overridden
# cd $(HIGGS_ROOT) && make -j22 vallfpga
compilehex:
# 	make -C $(HIGGS_ROOT) vallfpga
	$(call invoke_c_override_submake)
	@echo ""
	@echo $(VERILATOR_C_OVERRIDE_DEFINES)
	@echo ""
	@echo $(VERILATOR_C_SUBMAKE_PATHS)

# gensigs:
# 	@node ../../gensigs.js $(VER_FLAGS) $(VER_INCLUDE_DIRS) $(VERILATOR_TB_INCLUDE_DEFINES) $(EXTRA_VERILATOR_ARGS) $(VERILATOR_C_OVERRIDE_DEFINES) -PREFIX=../../

run_only:
	./obj_dir/$(VER_BINARY)

runt: trun

run: compile
	./obj_dir/$(VER_BINARY)

trun: compile
	./obj_dir/$(VER_BINARY) +trace

verilate:
	verilator $(VER_TOP) \
	$(VER_FLAGS) \
	$(VER_INCLUDE_DIRS) \
	-cc \
	$(VER_SOURCES) \
	-O3 \
	${ADDCFLAGS} \
	--gdbbt \
	${VERILATOR_ARGS} \
	-Wno-UNOPTFLAT -Wno-WIDTH \
	--x-assign unique \
	--exe \
	$(CPP_TB_FILES) \
	$(VERILATOR_C_OVERRIDE_DEFINES) \
	$(VERILATOR_TB_INCLUDE_DEFINES) \
	$(EXTRA_VERILATOR_ARGS)


compile:
	make  -j  -C obj_dir/ -f Vtb_higgs_top.mk Vtb_higgs_top

.PHONY: clean show show1 quick quickt check

cleanwave:
	rm -f wave_dump.vcd wave_dump.vcd.idx wave_dump1.vcd wave_dump1.vcd.idx

cleanall: clean_verilator_parse_syms
	rm -rf obj_dir
	rm -f wave_dump.vcd wave_dump.vcd.idx
	$(call invoke_c_override_clean)

clean: cleanall

cleanhex:
	rm -f cs00_out.hex \
	cs01_out.hex \
	cs10_out.hex \
	cs11_out.hex \
	cs20_in.hex \
	cs20_out.hex \
	cs21_out.hex \
	cs30_out.hex \
	cs31_out.hex \
	mapmov_in.hex \
	ringbus_out.hex \
	cs20.out \
	cs10.out \
	cs00.out \
	cs01.out \
	cs11.out \
	cs21.out \
	cs31.out \
	cs30.out \
	cs20_vmem.out \
	cs10_vmem.out \
	cs00_vmem.out \
	cs01_vmem.out \
	cs11_vmem.out \
	cs21_vmem.out \
	cs31_vmem.out \
	cs30_vmem.out

# it's possible that --giga is redundant with --fastload
# without realpath, multiple gtkwave windows will all show 'wave_dump.vcd'
# in the title, making it impossible to distinguish which window is from which folder
show: wave_dump.vcd
	gtkwave $(realpath wave_dump.vcd) --fastload dma_out.gtkw --giga &

show1: wave_dump1.vcd
	gtkwave $(realpath wave_dump1.vcd) --fastload dma_out.gtkw --giga &

quick: compilehex verilator_parse_syms compile run
quickt: compilehex verilator_parse_syms compile trun

# these allow for parsing of the vmem names
PARSE_VERILATOR_OBJ_DIR=obj_dir
include $(HW_ROOT)/make_include/verilator_vmem.mk

# # these allow bootloading from this folder
# BOOTLOAD_ROOT=override
# include $(HIGGS_ROOT)/scripts/make_include/bootloader.mk

# # these allow bootloading from this folder
# BOOTLOAD_ROOT=override
# include $(HIGGS_ROOT)/scripts/make_include/status.mk



# all:
# 	@echo $(RVS_ROOT)
# 	@echo ""
# 	@ls $(RVS_ROOT)
# 	@ls $(RVS_ROOT)/inc

# all2:
# 	@ls $(RISCV_C_INC_PATH)
# # 	@cat $(CRT_STANDARD_PATH)
# # 	@cat $(LD_STANDARD_PATH)
# # LD_STANDARD_PATH

# all3:
# 	@echo $(BOARD_TB_TOP)
# 	@echo $(VER_BINARY)


# all4:
# # 	@echo $(EXTRA_CPP_FILES)
# 	@echo $(CPP_TB_FILES)

# foo:
# 	@echo $(HIGGS_TEST_DIR)


debug_ver_sources:
	@echo $(VER_SOURCES) | tr " " "\n"
