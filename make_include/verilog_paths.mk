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



BOARD_TB_TOP_ONLY=\
$(HW_ROOT)/hdl/top/sim/tb_blade_top.sv

# use this when you want to include your own top when using higgs
BOARD_TB_NO_TOP_VERILOG=\
$(IP_LIBRARY_ROOT)/interfaces/cmd_interface/hdl/intf_cmd.sv \
$(IP_LIBRARY_ROOT)/interfaces/cmd_interface/hdl/cmd_master_example.sv \
$(IP_LIBRARY_ROOT)/interfaces/cmd_interface/hdl/cmd_slave_example.sv \
$(HW_ROOT)/hdl/top/blade/hdl/blade_top.sv \
$(IP_LIBRARY_ROOT)/common/core_top.sv \
$(IP_LIBRARY_ROOT)/common/vex_machine_top.v \
$(IP_LIBRARY_ROOT)/common/vex_machine_top_gutted.v \
$(IP_LIBRARY_ROOT)/common/vex_machine_top_d_engine.v \
$(IP_LIBRARY_ROOT)/common/core_reset.sv \
$(IP_LIBRARY_ROOT)/common/cmd_cdc.sv \
$(IP_LIBRARY_ROOT)/eb2a/eb2a_ctrl.v \
$(IP_LIBRARY_ROOT)/eb2a/eb2a_data.v \
$(IP_LIBRARY_ROOT)/eb2a/eb2a.v \
$(IP_LIBRARY_ROOT)/demapper/demapper.sv \
# $(HW_ROOT)/hdl/top/cfg/hdl/cfg_top.sv \
# $(IP_LIBRARY_ROOT)/width_convert/width_32_8.sv \
# $(IP_LIBRARY_ROOT)/width_convert/width_8_32.sv \
# $(IP_LIBRARY_ROOT)/common/q_engine_gutted.v \
# $(HW_ROOT)/hdl/top/cs22/hdl/cs22_top.sv \
# $(HW_ROOT)/hdl/top/eth/hdl/eth_top.sv \
# $(IP_LIBRARY_ROOT)/off_board/half_cdc.sv \
# $(HIGGS_ROOT)/fpgas/grav/eth/hdl/eth_mega_wrapper.sv \
# $(HIGGS_ROOT)/fpgas/grav/eth/hdl/fifo_cdc.sv \
# $(HIGGS_ROOT)/fpgas/grav/eth/hdl/mac_cfg.sv \
# $(HIGGS_ROOT)/fpgas/grav/eth/hdl/eth_rx_wrapper.sv \
# $(IP_LIBRARY_ROOT)/lattice_support/gbit_mac/modules/arp_reply/hdl/arp_reply.sv \
# $(IP_LIBRARY_ROOT)/lattice_support/gbit_mac/modules/eth_frame_router/hdl/eth_frame_router.sv \
# $(IP_LIBRARY_ROOT)/lattice_support/gbit_mac/modules/ipv4_pkt_router/hdl/ipv4_pkt_router.sv \
# $(IP_LIBRARY_ROOT)/lattice_support/gbit_mac/modules/udp_pkt_router/hdl/udp_pkt_router.sv \
# $(IP_LIBRARY_ROOT)/lattice_support/gbit_mac/modules/mac_tx_arbiter/hdl/mac_tx_arbiter.sv \
# $(IP_LIBRARY_ROOT)/lattice_support/gbit_mac/modules/udp_rx_stream_buffer/hdl/udp_rx_stream_buffer.sv \
# $(IP_LIBRARY_ROOT)/lattice_support/gbit_mac/modules/udp_packetizer/hdl/udp_packetizer.sv \
# $(IP_LIBRARY_ROOT)/lattice_support/fifos/pmi_fifo_sc_fwft_v1_0/hdl/pmi_fifo_sc_fwft_v1_0.sv \
# $(IP_LIBRARY_ROOT)/lattice_support/fifos/pmi_fifo_dc_fwft_v1_0/hdl/pmi_fifo_dc_fwft_v1_0.sv \
# $(IP_LIBRARY_ROOT)/mib_bus/hdl/mib_master.sv \
# $(IP_LIBRARY_ROOT)/mib_bus/hdl/mib_slave.sv \
# $(IP_LIBRARY_ROOT)/mib_bus/hdl/mib_master_wrapper.sv \
# $(IP_LIBRARY_ROOT)/mib_bus/hdl/mib_slave_wrapper.sv \
# $(IP_LIBRARY_ROOT)/graviton_ti_cfg/hdl/graviton_ti_cfg.sv \
# $(IP_LIBRARY_ROOT)/graviton_ti_cfg/hdl/ti_sif.sv \
# $(IP_LIBRARY_ROOT)/n25q_qspi_reader/hdl/n25q_qspi_reader.sv \
# $(IP_LIBRARY_ROOT)/ecp5_slave_serial_programmer/hdl/ecp5_slave_serial_programmer.sv \
# $(IP_LIBRARY_ROOT)/upconverter/hdl/duc_fixed_dds.sv \
# $(IP_LIBRARY_ROOT)/upconverter/hdl/duc_hb_cascade.sv \
# $(IP_LIBRARY_ROOT)/upconverter/hdl/duc_hb_interp_fir_h0.sv \
# $(IP_LIBRARY_ROOT)/upconverter/hdl/duc_skid.sv \
# $(IP_LIBRARY_ROOT)/upconverter/hdl/upconverter.sv \
# $(IP_LIBRARY_ROOT)/downconverter/hdl/downconverter.sv \
# $(IP_LIBRARY_ROOT)/downconverter/hdl/fixed_ddsx2.sv \
# $(IP_LIBRARY_ROOT)/downconverter/hdl/ddc_hb_cascade.sv \
# $(IP_LIBRARY_ROOT)/downconverter/hdl/ddc_hb_decim_fir_h1.sv \
# $(IP_LIBRARY_ROOT)/downconverter/hdl/ddc_hb_decim_fir_h2.sv \
# $(IP_LIBRARY_ROOT)/downconverter/hdl/ddc_hb_decim_firx2_h0.sv \

# $(HIGGS_ROOT)/fpgas/packages/higgs_sdr_global_pkg.sv \








# use this when you want the default paths for all files in higgs
HIGGS_TB_ALL_VERILOG=\
$(BOARD_TB_TOP_ONLY) \
$(BOARD_TB_NO_TOP_VERILOG)

# $(DISABLE_TRACING_PATHS) \


BOARD_INCLUDE_PATHS=\
-I$(HW_ROOT)/hdl/top/sim  \
-I$(IP_LIBRARY_ROOT)/common  \


RISCV_C_INC_PATH=$(RVS_ROOT)/inc
LD_STANDARD_PATH=$(RVS_ROOT)/ld/ld_standard
CRT_STANDARD_PATH=$(RVS_ROOT)/src/asm_init/crt_standard.S
