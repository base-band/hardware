# make sure all paths start with a variable that is not found in this file



ifndef IP_LIBRARY_ROOT
$(error Please define IP_LIBRARY_ROOT before including make_include/verilog_paths.mk)
endif
ifndef DATAPATH_ROOT
$(error Please define DATAPATH_ROOT before including make_include/verilog_paths.mk)
endif
ifndef Q_ENGINE_ROOT
$(error Please define Q_ENGINE_ROOT before including make_include/verilog_paths.mk)
endif
ifndef RISCV_ROOT
$(error Please define RISCV_ROOT before including make_include/verilog_paths.mk)
endif


Q_ENGINE_ALL_VERILOG= \
$(RISCV_ROOT)/hdl/generated/XbbRiscv.v \
$(Q_ENGINE_ROOT)/piston/hdl/k15_op.v \
$(Q_ENGINE_ROOT)/piston/hdl/round_sat_dat_1_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/bs_dat_2_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/cfg_ctrl.v \
$(Q_ENGINE_ROOT)/piston/hdl/cfg_dat.v \
$(Q_ENGINE_ROOT)/piston/hdl/defunnel_ctrl_3_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/defunnel_dat_3_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/eb15_ctrl.v \
$(Q_ENGINE_ROOT)/piston/hdl/eb17_ctrl.v \
$(Q_ENGINE_ROOT)/piston/hdl/eb_fifo_ctrl.v \
$(Q_ENGINE_ROOT)/piston/hdl/funnel_ctrl_2_2.v \
$(Q_ENGINE_ROOT)/piston/hdl/funnel_dat_2_2.v \
$(Q_ENGINE_ROOT)/piston/hdl/p_decode_dat_1_2.v \
$(Q_ENGINE_ROOT)/piston/hdl/p_decode_ctrl_1_2.v \
$(Q_ENGINE_ROOT)/piston/hdl/ka_decode_dat_1_3.v \
$(Q_ENGINE_ROOT)/piston/hdl/ka_decode_ctrl_1_3.v \
$(Q_ENGINE_ROOT)/piston/hdl/perm_full_addr_dat_1_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/perm_full_data_dat_2_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/perm_addr_dat_1_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/perm_addr_slice.v \
$(Q_ENGINE_ROOT)/piston/hdl/perm_data_dat_2_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/perm_data_slice.v \
$(Q_ENGINE_ROOT)/piston/hdl/inmux_ctrl_4_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/inmux_dat_4_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/iperm_ctrl_2_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/iperm_dat_2_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/kap_ctrl_ctrl_1_5.v \
$(Q_ENGINE_ROOT)/piston/hdl/kap_ctrl_dat_1_5.v \
$(Q_ENGINE_ROOT)/piston/hdl/memory_slice.v \
$(Q_ENGINE_ROOT)/piston/hdl/operm_ctrl_2_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/operm_dat_2_1.v \
$(Q_ENGINE_ROOT)/piston/hdl/oumux_ctrl_2_5.v \
$(Q_ENGINE_ROOT)/piston/hdl/oumux_dat_2_5.v \
$(Q_ENGINE_ROOT)/piston/hdl/permutator_slice.v \
$(Q_ENGINE_ROOT)/piston/hdl/piston.v \
$(Q_ENGINE_ROOT)/piston/hdl/vector_ctrl_17_2.v \
$(Q_ENGINE_ROOT)/piston/hdl/vector_dat_17_2.v \
$(Q_ENGINE_ROOT)/piston/hdl/vector_slice.v \
$(Q_ENGINE_ROOT)/piston/hdl/vmem_ctrl_6_5.v \
$(Q_ENGINE_ROOT)/piston/hdl/vmem_dat_6_5.v \
$(Q_ENGINE_ROOT)/hdl/scalar_memory.v \
$(Q_ENGINE_ROOT)/hdl/slicer.v \
$(Q_ENGINE_ROOT)/hdl/dma/dma_in.v \
$(Q_ENGINE_ROOT)/hdl/dma/dma_out.v \
$(Q_ENGINE_ROOT)/hdl/dma/dma_in_dummy.v \
$(Q_ENGINE_ROOT)/hdl/nco/nco_gen.v \
$(Q_ENGINE_ROOT)/hdl/nco/nco.v \
$(Q_ENGINE_ROOT)/hdl/q_engine.v \
$(Q_ENGINE_ROOT)/hdl/ring_bus/ring_bus.v \
$(IP_LIBRARY_ROOT)/fwft_fifos/sc_fifo/hdl/fwft_sc_fifo.v \
$(IP_LIBRARY_ROOT)/fwft_fifos/sc_fifo/hdl/generic_dpram.v \
$(IP_LIBRARY_ROOT)/fwft_fifos/sc_fifo/hdl/generic_fifo_sc_a.v \
$(DATAPATH_ROOT)/hdl/muladdsub.v 


# if we change how this project is verilated, this will change
Q_ENGINE_VERILATOR_TOP=q_engine




RISCV_C_INC_PATH=$(RVS_ROOT)/inc
LD_STANDARD_PATH=$(RVS_ROOT)/ld/ld_standard
CRT_STANDARD_PATH=$(RVS_ROOT)/src/asm_init/crt_standard.S
