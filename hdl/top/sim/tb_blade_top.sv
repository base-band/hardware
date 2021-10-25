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

      output wire        o_data_valid_dac,
`ifndef TB_USE_DAC
`ifdef VERILATE_MULTIPLE_HIGGS
      input wire         i_o_ready_dac,
`else
      output reg         i_o_ready_dac, // an output because we are controlling this from verilog not the tb
`endif
      output wire [31:0] o_data_dac,
`endif


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


`ifdef ETH_USE_MEGA_WRAPPER
      input              MAC_RX_WRITE,
      input              MAC_RX_EOF,
      input [7:0]        MAC_RX_FIFODATA,
      output             MAC_TX_FIFOAVAIL,
      output [7:0]       MAC_TX_FIFODATA,
      output             MAC_TX_FIFOEOF,
      input              MAC_TX_MACREAD,
`endif

      output wire [31:0] snap_mapmov_in_data,
      output wire        snap_mapmov_in_valid,
      output wire        snap_mapmov_in_ready,

      //
      output wire [31:0] o_data_eth,
      output wire        o_data_valid_eth,
      output wire        o_data_last_eth,

      output wire [31:0] o_rx_data_eth,
      output wire        o_rx_valid_eth,
      input wire         i_rx_ready_eth,

      output             DAC_CTRL_SDIO, // technically an inout, but we currently don't support reads from DAC SIF
      output             DAC_CTRL_SDENN,
      output             DAC_CTRL_SCLK,
      output             DAC_CTRL_RESETN

        // only when we are not using the dac


      );

   logic        tb_is_blade;
   assign tb_is_blade = 1'b1;

parameter VERILATE = 1'b1;


   logic [31:0] cs12_out_data;
   logic        cs12_o_data_last;
   logic        cs12_o_data_vld;
   logic        cs12_i_ready;
   logic        cs12_o_ringbus;

   logic [31:0] cs02_out_data;
   logic        cs02_o_data_last;
   logic        cs02_o_data_vld;
   logic        cs02_i_ready;
   logic        cs02_o_ringbus;

   logic        cs01_o_ringbus;

   logic [31:0] cs31_out_data;
   logic        cs31_o_data_last;
   logic        cs31_o_data_vld;
   logic        cs31_i_ready;
   logic        cs31_o_ringbus;

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

   logic [31:0] cs21_out_data;
   logic        cs21_o_data_last;
   logic        cs21_o_data_vld;
   logic        cs21_i_ready;
   logic        cs21_o_ringbus;

   logic [31:0] cs20_out_data;
   logic        cs20_o_data_last;
   logic        cs20_o_data_vld;
   logic        cs20_i_ready;
   logic        cs20_o_ringbus;

   logic [31:0]   i_data_eth;
   logic          i_data_valid_eth;
   logic          i_data_last_eth;
   logic          o_i_ready_eth;

   logic          eth_o_ringbus;
   logic          eth_i_ringbus;
   // logic [31:0]   o_data_eth;
   // logic       o_data_valid_eth;

   logic          i_o_ready_eth;

   logic          eth_rst;

   logic    [20:0] MIB_AD;


`ifdef TB_USE_DAC
    logic  [31:0]    o_data_dac;
    logic      o_data_valid_dac;
    logic         i_o_ready_dac;
`endif

`ifdef TB_USE_ADC
    wire [31:0] adc_data_out;
    wire  adc_data_out_valid;
`endif
    wire  adc_data_out_parity; // not really used anymore but still wired up





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
         .HS_WEST_OUT                        ({cs22_o_data_vld,cs22_out_data}), // data valid + 32 bit data
         .HS_WEST_OUT_LAST                   (cs22_o_data_last),
         .HS_WEST_IN                         (cs22_i_ready), // ready
         .HS_NORTH_IN_RB                     (cs12_o_ringbus), // i_ringbus
         .HS_SOUTH_OUT_RB                    (cs22_o_ringbus), // o_ringbus
         .HS_SOUTH_IN                        ({cs32_o_data_vld,cs32_out_data}), // data valid + 32 bit data
         .HS_SOUTH_IN_LAST                   (cs32_o_data_last),
         .HS_SOUTH_OUT                       (cs32_i_ready),   // ready

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


`ifdef TB_USE_ETH

   eth_top #(.VERILATE (VERILATE),
            .SCALAR_MEM_0 (`ETH_SCALAR_0),
            .SCALAR_MEM_1 (`ETH_SCALAR_1),
            .SCALAR_MEM_2 (`ETH_SCALAR_2),
            .SCALAR_MEM_3 (`ETH_SCALAR_3),
            .VMEM0 (`ETH_VMEM0),
            .VMEM1 (`ETH_VMEM1),
            .VMEM2 (`ETH_VMEM2),
            .VMEM3 (`ETH_VMEM3),
            .VMEM4 (`ETH_VMEM4),
            .VMEM5 (`ETH_VMEM5),
            .VMEM6 (`ETH_VMEM6),
            .VMEM7 (`ETH_VMEM7),
            .VMEM8 (`ETH_VMEM8),
            .VMEM9 (`ETH_VMEM9),
            .VMEM10 (`ETH_VMEM10),
            .VMEM11 (`ETH_VMEM11),
            .VMEM12 (`ETH_VMEM12),
            .VMEM13 (`ETH_VMEM13),
            .VMEM14 (`ETH_VMEM14),
            .VMEM15 (`ETH_VMEM15)

         )
      eth_top (
         .CLK           (clk),

         .LED_D4           (),
         .LED_D12       (),

         // .P1A_DDR_IN      ({o_data_valid_eth,o_data_eth}),
         // .P1A_DDR_OUT     (i_o_ready_eth),

            // connection with cs20
         // .P1B_DDR_OUT     ({i_data_valid_eth,i_data_eth}),
         // .P1B_DDR_IN      (o_i_ready_eth),

         // .P1B_SDR_OUT     (eth_rst),
         .HS_SOUTH_IN        ({cs20_o_data_vld,cs20_out_data}),
         .HS_SOUTH_OUT       (cs20_i_ready),
         .HS_EAST_OUT        ({i_data_valid_eth,i_data_eth}),
         .HS_EAST_IN         (o_i_ready_eth),
         .HS_SOUTH_IN_RB     (cs20_o_ringbus),
         .HS_EAST_OUT_RB     (eth_o_ringbus),
         .UART_TX            (snap_eth_io_uart_txd),
         .UART_RX            (snap_eth_io_uart_rxd),
         // .MIB_AD          (MIB_AD),

         .MIB_MASTER_RESET(MIB_MASTER_RESET),

            .snap_mapmov_in_data(snap_mapmov_in_data),
            .snap_mapmov_in_valid(snap_mapmov_in_valid),
            .snap_mapmov_in_ready(snap_mapmov_in_ready),

               .split_fb_data(o_rx_data_eth),
               .split_fb_valid(o_rx_valid_eth),
               .split_fb_ready(i_rx_ready_eth),
`ifdef ETH_USE_MEGA_WRAPPER
            .MAC_RX_WRITE(MAC_RX_WRITE),
            .MAC_RX_EOF(MAC_RX_EOF),
            .MAC_RX_FIFODATA(MAC_RX_FIFODATA),
            .MAC_TX_FIFOAVAIL(MAC_TX_FIFOAVAIL),
            .MAC_TX_FIFODATA(MAC_TX_FIFODATA),
            .MAC_TX_FIFOEOF(MAC_TX_FIFOEOF),
            .MAC_TX_MACREAD(MAC_TX_MACREAD),
`endif


         // port 30000
            // data bound for cs20
         .tx_turnstile_data_in     (tx_turnstile_data_in),
         .tx_turnstile_data_valid  (tx_turnstile_data_valid),
            .tx_turnstile_data_ready  (tx_turnstile_data_ready),

         // port 20000
            // data bound for input dma of eth's riscv
            // this is a ringbus bytes which eth will internally convert
            // and omit a ringbus message to it's partners. aka "bridge" udp->ringbus
         .ringbus_in_data          (ringbus_in_data),
         .ringbus_in_data_vld      (ringbus_in_data_vld),
            .ringbus_in_data_ready    (ringbus_in_data_ready),

         // port 10000
         .ringbus_out_data         (ringbus_out_data),
         .ringbus_out_data_vld     (ringbus_out_data_vld),

         .ring_bus_i0_ready        (ring_bus_i0_ready)

         );
`endif


   cfg_top #(.VERILATE (VERILATE))
       cfg_top (
         .CFG_CLK          (clk),
         .MIB_AD           (MIB_AD[20:17]),
         .DAC_CTRL_SDIO    (DAC_CTRL_SDIO),
         .DAC_CTRL_SDENN   (DAC_CTRL_SDENN),
         .DAC_CTRL_SCLK    (DAC_CTRL_SCLK),
         .DAC_CTRL_RESETN  (DAC_CTRL_RESETN)

         );


endmodule
