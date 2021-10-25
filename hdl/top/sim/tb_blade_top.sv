`include "configurable_mif_paths.v"


module tb_higgs_top 
  (
      input wire         clk,
      input wire         MIB_MASTER_RESET,



      input wire [31:0]  i_data_adc,
      input wire         i_data_valid_adc,



      // port 30000
        // data bound for cs20
      input wire [31:0]  tx_turnstile_data_in,
      input wire         tx_turnstile_data_last, 
      input wire         tx_turnstile_data_valid,
      output wire        tx_turnstile_data_ready,

      // port 20000
        // data bound for input dma of eth's riscv
      input wire [31:0]  ringbus_in_data,
      input wire         ringbus_in_data_vld,
      output wire        ringbus_in_data_ready,

      // ETH UART
      output wire        snap_eth_io_uart_txd,
      input wire         snap_eth_io_uart_rxd,

      // port 10000
      output wire [31:0] ringbus_out_data,
      output wire        ringbus_out_data_vld,

      input wire         ring_bus_i0_ready,


`ifdef TB_USE_CS22
      output wire [31:0] snap_cs22_riscv_out_data,
      output wire        snap_cs22_riscv_out_last,
      output wire        snap_cs22_riscv_out_valid,
      output wire        snap_cs22_riscv_out_ready,

      input wire [31:0]  inject_cs22_riscv_in_data,
      input wire         inject_cs22_riscv_in_last,
      input wire         inject_cs22_riscv_in_valid,
      output wire        inject_cs22_riscv_in_ready,
      output wire        snap_cs22_io_uart_txd,
      output wire        snap_cs22_io_uart_rxd,
`endif

      // HIJACKED
      input wire [31:0]  adc_data_out,
      input wire         adc_data_out_valid,
      output wire        adc_data_out_ready,



      output wire [31:0] snap_mapmov_in_data,
      output wire        snap_mapmov_in_valid,
      output wire        snap_mapmov_in_ready,

      //
      output wire [31:0] o_data_eth,
      output wire        o_data_valid_eth,
      output wire        o_data_last_eth,

      output wire [31:0] o_rx_data_eth,
      output wire        o_rx_valid_eth,
      input wire         i_rx_ready_eth


      );

   logic        tb_is_blade;
   assign tb_is_blade = 1'b1;

parameter VERILATE = 1'b1;

   logic        cs12_o_ringbus;


   logic [31:0] cs32_out_data;
   logic        cs32_o_data_last;
   logic        cs32_o_data_vld;
   logic        cs32_i_ready;
   logic        cs32_o_ringbus;

   logic [31:0] cs22_out_data;
   logic        cs22_o_data_last;
   logic        cs22_o_data_vld;
   logic        cs22_i_ready;
   logic        cs22_o_ringbus;


   logic          eth_o_ringbus;
   logic          eth_i_ringbus;
   // logic [31:0]   o_data_eth;
   // logic       o_data_valid_eth;

   logic          i_o_ready_eth;

   logic          eth_rst;

   logic    [20:0] MIB_AD;


`ifdef TB_USE_CS22
   blade_top #(.VERILATE (VERILATE),
              .SCALAR_MEM_0 (`CS22_SCALAR_0),
              .SCALAR_MEM_1 (`CS22_SCALAR_1),
              .SCALAR_MEM_2 (`CS22_SCALAR_2),
              .SCALAR_MEM_3 (`CS22_SCALAR_3),
              .VMEM0 (`CS22_VMEM0),
              .VMEM1 (`CS22_VMEM1),
              .VMEM2 (`CS22_VMEM2),
              .VMEM3 (`CS22_VMEM3),
              .VMEM4 (`CS22_VMEM4),
              .VMEM5 (`CS22_VMEM5),
              .VMEM6 (`CS22_VMEM6),
              .VMEM7 (`CS22_VMEM7),
              .VMEM8 (`CS22_VMEM8),
              .VMEM9 (`CS22_VMEM9),
              .VMEM10 (`CS22_VMEM10),
              .VMEM11 (`CS22_VMEM11),
              .VMEM12 (`CS22_VMEM12),
              .VMEM13 (`CS22_VMEM13),
              .VMEM14 (`CS22_VMEM14),
              .VMEM15 (`CS22_VMEM15))
      blade_top (
         .CLK                                (clk),
         .FPGA_LED                           (),
         .HS_WEST_OUT                        ({o_rx_valid_eth,o_rx_data_eth}), // data valid + 32 bit data
         .HS_WEST_OUT_LAST                   (),
         .HS_WEST_IN                         (i_rx_ready_eth), // ready
         .HS_NORTH_IN_RB                     (cs12_o_ringbus), // i_ringbus
         .HS_SOUTH_OUT_RB                    (cs22_o_ringbus), // o_ringbus
         .HS_SOUTH_IN                        ({adc_data_out_valid,adc_data_out}), // data valid + 32 bit data
         .HS_SOUTH_IN_LAST                   (1'b0),
         .HS_SOUTH_OUT                       (adc_data_out_ready),   // ready

         .snap_riscv_out_data                (snap_cs22_riscv_out_data),
         .snap_riscv_out_last                (snap_cs22_riscv_out_last),
         .snap_riscv_out_valid               (snap_cs22_riscv_out_valid),
         .snap_riscv_out_ready               (snap_cs22_riscv_out_ready),
         .snap_io_uart_txd                   (snap_cs22_io_uart_txd),
         .snap_io_uart_rxd                   (snap_cs22_io_uart_rxd),
         // .snap_riscv_in_data                 (snap_cs22_riscv_in_data),
         // .snap_riscv_in_valid                (snap_cs22_riscv_in_valid),
         // .snap_riscv_in_ready                (snap_cs22_riscv_in_ready),

         .MIB_MASTER_RESET (MIB_MASTER_RESET)
      );


`else
assign cs22_o_ringbus = 1'b1;

`endif


endmodule
