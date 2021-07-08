module alu54b_wrapper
  (input wire [35:0] a,
   input wire [35:0]  b,
   input wire 	      subadd,
   input wire 	      ce,
   output wire [54:0] c,
   input wire 	      clk,rst);

`ifdef VERILATE
   always @(posedge clk or posedge rst)
     if(rst)
       c<=0;
     else
       c <= subadd ? $signed(a) - $signed(b) : $signed(a) + $signed(b);
`else


   wire 	      scuba_vlo;
   wire 	      scuba_vhi;


   defparam dsp_alu_0.CLK3_DIV = "ENABLED" ;
   defparam dsp_alu_0.CLK2_DIV = "ENABLED" ;
   defparam dsp_alu_0.CLK1_DIV = "ENABLED" ;
   defparam dsp_alu_0.CLK0_DIV = "ENABLED" ;
   defparam dsp_alu_0.REG_INPUTCFB_RST = "RST0" ;
   defparam dsp_alu_0.REG_INPUTCFB_CE = "CE0" ;
   defparam dsp_alu_0.REG_INPUTCFB_CLK = "NONE" ;
   defparam dsp_alu_0.REG_OPCODEIN_1_RST = "RST0" ;
   defparam dsp_alu_0.REG_OPCODEIN_1_CE = "CE0" ;
   defparam dsp_alu_0.REG_OPCODEIN_1_CLK = "NONE" ;
   defparam dsp_alu_0.REG_OPCODEIN_0_RST = "RST0" ;
   defparam dsp_alu_0.REG_OPCODEIN_0_CE = "CE0" ;
   defparam dsp_alu_0.REG_OPCODEIN_0_CLK = "NONE" ;
   defparam dsp_alu_0.REG_OPCODEOP1_1_CLK = "NONE" ;
   defparam dsp_alu_0.REG_OPCODEOP1_0_CLK = "NONE" ;
   defparam dsp_alu_0.REG_OPCODEOP0_1_RST = "RST0" ;
   defparam dsp_alu_0.REG_OPCODEOP0_1_CE = "CE0" ;
   defparam dsp_alu_0.REG_OPCODEOP0_1_CLK = "CLK0" ;
   defparam dsp_alu_0.REG_OPCODEOP0_0_RST = "RST0" ;
   defparam dsp_alu_0.REG_OPCODEOP0_0_CE = "CE0" ;
   defparam dsp_alu_0.REG_OPCODEOP0_0_CLK = "CLK0" ;
   defparam dsp_alu_0.REG_INPUTC1_RST = "RST0" ;
   defparam dsp_alu_0.REG_INPUTC1_CE = "CE0" ;
   defparam dsp_alu_0.REG_INPUTC1_CLK = "NONE" ;
   defparam dsp_alu_0.REG_INPUTC0_RST = "RST0" ;
   defparam dsp_alu_0.REG_INPUTC0_CE = "CE0" ;
   defparam dsp_alu_0.REG_INPUTC0_CLK = "NONE" ;
   defparam dsp_alu_0.LEGACY = "ENABLED" ;
   defparam dsp_alu_0.REG_FLAG_RST = "RST0" ;
   defparam dsp_alu_0.REG_FLAG_CE = "CE0" ;
   defparam dsp_alu_0.REG_FLAG_CLK = "NONE" ;
   defparam dsp_alu_0.REG_OUTPUT1_RST = "RST0" ;
   defparam dsp_alu_0.REG_OUTPUT1_CE = "CE0" ;
   defparam dsp_alu_0.REG_OUTPUT1_CLK = "CLK0" ;
   defparam dsp_alu_0.REG_OUTPUT0_RST = "RST0" ;
   defparam dsp_alu_0.REG_OUTPUT0_CE = "CE0" ;
   defparam dsp_alu_0.REG_OUTPUT0_CLK = "CLK0" ;
   defparam dsp_alu_0.MULT9_MODE = "DISABLED" ;
   defparam dsp_alu_0.RNDPAT = "0x00000000000000" ;
   defparam dsp_alu_0.MASKPAT = "0x00000000000000" ;
   defparam dsp_alu_0.MCPAT = "0x00000000000000" ;
   defparam dsp_alu_0.MASK01 = "0x00000000000000" ;
   defparam dsp_alu_0.MASKPAT_SOURCE = "STATIC" ;
   defparam dsp_alu_0.MCPAT_SOURCE = "STATIC" ;
   defparam dsp_alu_0.RESETMODE = "ASYNC" ;
   defparam dsp_alu_0.GSR = "ENABLED" ;

   ALU54B dsp_alu_0 (.A35(a[35]), .A34(a[34]),
		     .A33(a[33]), .A32(a[32]),
		     .A31(a[31]), .A30(a[30]),
		     .A29(a[29]), .A28(a[28]),
		     .A27(a[27]), .A26(a[26]),
		     .A25(a[25]), .A24(a[22]),
		     .A23(a[23]), .A22(a[22]),
		     .A21(a[21]), .A20(a[20]),
		     .A19(a[19]), .A18(a[18]),
		     .A17(a[17]), .A16(a[16]),
		     .A15(a[15]), .A14(a[14]),
		     .A13(a[13]), .A12(a[12]),
		     .A11(a[11]), .A10(a[10]),
		     .A9(a[9]), .A8(a[8]),
		     .A7(a[7]), .A6(a[6]),
		     .A5(a[5]), .A4(a[4]),
		     .A3(a[3]), .A2(a[2]),
		     .A1(a[1]), .A0(a[0]),
		     .B35(b[35]), .B34(b[34]),
		     .B33(b[33]), .B32(b[32]),
		     .B31(b[31]), .B30(b[30]),
		     .B29(b[29]), .B28(b[28]),
		     .B27(b[27]), .B26(b[26]),
		     .B25(b[25]), .B24(b[24]),
		     .B23(b[23]), .B22(b[22]),
		     .B21(b[21]), .B20(b[20]),
		     .B19(b[19]), .B18(b[18]),
		     .B17(b[17]), .B16(b[16]),
		     .B15(b[15]), .B14(b[14]),
		     .B13(b[13]), .B12(b[12]),
		     .B11(b[11]), .B10(b[10]),
		     .B9(b[9]), .B8(b[8]),
		     .B7(b[7]), .B6(b[6]),
		     .B5(b[5]), .B4(b[4]),
		     .B3(b[3]), .B2(b[2]),
		     .B1(b[1]), .B0(b[0]),
		     .CFB53(scuba_vlo), .CFB52(scuba_vlo), .CFB51(scuba_vlo), .CFB50(scuba_vlo),
		     .CFB49(scuba_vlo), .CFB48(scuba_vlo), .CFB47(scuba_vlo), .CFB46(scuba_vlo),
		     .CFB45(scuba_vlo), .CFB44(scuba_vlo), .CFB43(scuba_vlo), .CFB42(scuba_vlo),
		     .CFB41(scuba_vlo), .CFB40(scuba_vlo), .CFB39(scuba_vlo), .CFB38(scuba_vlo),
		     .CFB37(scuba_vlo), .CFB36(scuba_vlo), .CFB35(scuba_vlo), .CFB34(scuba_vlo),
		     .CFB33(scuba_vlo), .CFB32(scuba_vlo), .CFB31(scuba_vlo), .CFB30(scuba_vlo),
		     .CFB29(scuba_vlo), .CFB28(scuba_vlo), .CFB27(scuba_vlo), .CFB26(scuba_vlo),
		     .CFB25(scuba_vlo), .CFB24(scuba_vlo), .CFB23(scuba_vlo), .CFB22(scuba_vlo),
		     .CFB21(scuba_vlo), .CFB20(scuba_vlo), .CFB19(scuba_vlo), .CFB18(scuba_vlo),
		     .CFB17(scuba_vlo), .CFB16(scuba_vlo), .CFB15(scuba_vlo), .CFB14(scuba_vlo),
		     .CFB13(scuba_vlo), .CFB12(scuba_vlo), .CFB11(scuba_vlo), .CFB10(scuba_vlo),
		     .CFB9(scuba_vlo), .CFB8(scuba_vlo), .CFB7(scuba_vlo), .CFB6(scuba_vlo),
		     .CFB5(scuba_vlo), .CFB4(scuba_vlo), .CFB3(scuba_vlo), .CFB2(scuba_vlo),
		     .CFB1(scuba_vlo), .CFB0(scuba_vlo), .C53(scuba_vlo), .C52(scuba_vlo),
		     .C51(scuba_vlo), .C50(scuba_vlo), .C49(scuba_vlo), .C48(scuba_vlo),
		     .C47(scuba_vlo), .C46(scuba_vlo), .C45(scuba_vlo), .C44(scuba_vlo),
		     .C43(scuba_vlo), .C42(scuba_vlo), .C41(scuba_vlo), .C40(scuba_vlo),
		     .C39(scuba_vlo), .C38(scuba_vlo), .C37(scuba_vlo), .C36(scuba_vlo),
		     .C35(scuba_vlo), .C34(scuba_vlo), .C33(scuba_vlo), .C32(scuba_vlo),
		     .C31(scuba_vlo), .C30(scuba_vlo), .C29(scuba_vlo), .C28(scuba_vlo),
		     .C27(scuba_vlo), .C26(scuba_vlo), .C25(scuba_vlo), .C24(scuba_vlo),
		     .C23(scuba_vlo), .C22(scuba_vlo), .C21(scuba_vlo), .C20(scuba_vlo),
		     .C19(scuba_vlo), .C18(scuba_vlo), .C17(scuba_vlo), .C16(scuba_vlo),
		     .C15(scuba_vlo), .C14(scuba_vlo), .C13(scuba_vlo), .C12(scuba_vlo),
		     .C11(scuba_vlo), .C10(scuba_vlo), .C9(scuba_vlo), .C8(scuba_vlo),
		     .C7(scuba_vlo), .C6(scuba_vlo), .C5(scuba_vlo), .C4(scuba_vlo),
		     .C3(scuba_vlo), .C2(scuba_vlo), .C1(scuba_vlo), .C0(scuba_vlo),
		     .CE0(ce), .CE1(scuba_vhi), .CE2(scuba_vhi), .CE3(scuba_vhi), .CLK0(clk),
		     .CLK1(scuba_vlo), .CLK2(scuba_vlo), .CLK3(scuba_vlo), .RST0(rst),
		     .RST1(scuba_vlo), .RST2(scuba_vlo), .RST3(scuba_vlo), .SIGNEDIA(a[35]),
		     .SIGNEDIB(b[35]), .SIGNEDCIN(1'b0),
		     .MA35(a[35]), .MA34(a[34]),
		     .MA33(a[33]), .MA32(a[32]),
		     .MA31(a[31]), .MA30(a[30]),
		     .MA29(a[29]), .MA28(a[28]),
		     .MA27(a[27]), .MA26(a[26]),
		     .MA25(a[25]), .MA24(a[24]),
		     .MA23(a[23]), .MA22(a[22]),
		     .MA21(a[21]), .MA20(a[20]),
		     .MA19(a[19]), .MA18(a[18]),
		     .MA17(a[17]), .MA16(a[16]),
		     .MA15(a[15]), .MA14(a[14]),
		     .MA13(a[13]), .MA12(a[12]),
		     .MA11(a[11]), .MA10(a[10]),
		     .MA9(a[9]), .MA8(a[8]),
		     .MA7(a[7]), .MA6(a[6]),
		     .MA5(a[5]), .MA4(a[4]),
		     .MA3(a[3]), .MA2(a[2]),
		     .MA1(a[1]), .MA0(a[0]),
		     .MB35(b[35]), .MB34(b[34]),
		     .MB33(b[33]), .MB32(b[32]),
		     .MB31(b[31]), .MB30(b[30]),
		     .MB29(b[29]), .MB28(b[28]),
		     .MB27(b[27]), .MB26(b[26]),
		     .MB25(b[25]), .MB24(b[24]),
		     .MB23(b[23]), .MB22(b[22]),
		     .MB21(b[21]), .MB20(b[20]),
		     .MB19(b[19]), .MB18(b[18]),
		     .MB17(b[17]), .MB16(b[16]),
		     .MB15(b[15]), .MB14(b[14]),
		     .MB13(b[13]), .MB12(b[12]),
		     .MB11(b[11]), .MB10(b[10]),
		     .MB9(b[9]), .MB8(b[8]),
		     .MB7(b[7]), .MB6(b[6]),
		     .MB5(b[5]), .MB4(b[4]),
		     .MB3(b[3]), .MB2(b[2]),
		     .MB1(b[1]), .MB0(b[0]),
		     .CIN53(1'b0), .CIN52(1'b0),
		     .CIN51(1'b0), .CIN50(1'b0),
		     .CIN49(1'b0), .CIN48(1'b0),
		     .CIN47(1'b0), .CIN46(1'b0),
		     .CIN45(1'b0), .CIN44(1'b0),
		     .CIN43(1'b0), .CIN42(1'b0),
		     .CIN41(1'b0), .CIN40(1'b0),
		     .CIN39(1'b0), .CIN38(1'b0),
		     .CIN37(1'b0), .CIN36(1'b0),
		     .CIN35(1'b0), .CIN34(1'b0),
		     .CIN33(1'b0), .CIN32(1'b0),
		     .CIN31(1'b0), .CIN30(1'b0),
		     .CIN29(1'b0), .CIN28(1'b0),
		     .CIN27(1'b0), .CIN26(1'b0),
		     .CIN25(1'b0), .CIN24(1'b0),
		     .CIN23(1'b0), .CIN22(1'b0),
		     .CIN21(1'b0), .CIN20(1'b0),
		     .CIN19(1'b0), .CIN18(1'b0),
		     .CIN17(1'b0), .CIN16(1'b0),
		     .CIN15(1'b0), .CIN14(1'b0),
		     .CIN13(1'b0), .CIN12(1'b0),
		     .CIN11(1'b0), .CIN10(1'b0),
		     .CIN9(1'b0), .CIN8(1'b0),
		     .CIN7(1'b0), .CIN6(1'b0),
		     .CIN5(1'b0), .CIN4(1'b0),
		     .CIN3(1'b0), .CIN2(1'b0),
		     .CIN1(1'b0), .CIN0(1'b0),
		     .OP10(scuba_vlo), .OP9(scuba_vhi), .OP8(scuba_vlo), .OP7(subadd),
		     .OP6(scuba_vlo), .OP5(scuba_vlo), .OP4(scuba_vlo), .OP3(scuba_vlo),
		     .OP2(scuba_vhi), .OP1(scuba_vlo), .OP0(scuba_vhi), .R53(c[53]),
		     .R52(c[52]), .R51(c[51]),
		     .R50(c[50]), .R49(c[49]),
		     .R48(c[48]), .R47(c[47]),
		     .R46(c[46]), .R45(c[45]),
		     .R44(c[44]), .R43(c[43]),
		     .R42(c[42]), .R41(c[41]),
		     .R40(c[40]), .R39(c[39]),
		     .R38(c[38]), .R37(c[37]),
		     .R36(c[36]), .R35(c[35]),
		     .R34(c[34]), .R33(c[33]),
		     .R32(c[32]), .R31(c[31]),
		     .R30(c[30]), .R29(c[29]),
		     .R28(c[28]), .R27(c[27]),
		     .R26(c[26]), .R25(c[25]),
		     .R24(c[24]), .R23(c[23]),
		     .R22(c[22]), .R21(c[21]),
		     .R20(c[20]), .R19(c[19]),
		     .R18(c[18]), .R17(c[17]),
		     .R16(c[16]), .R15(c[15]),
		     .R14(c[14]), .R13(c[13]),
		     .R12(c[12]), .R11(c[11]),
		     .R10(c[10]), .R9(c[9]),
		     .R8(c[8]), .R7(c[7]),
		     .R6(c[6]), .R5(c[5]),
		     .R4(c[4]), .R3(c[3]),
		     .R2(c[2]), .R1(c[1]),
		     .R0(c[0]), .CO53(), .CO52(), .CO51(), .CO50(),
		     .CO49(), .CO48(), .CO47(), .CO46(), .CO45(), .CO44(), .CO43(), .CO42(),
		     .CO41(), .CO40(), .CO39(), .CO38(), .CO37(), .CO36(), .CO35(), .CO34(),
		     .CO33(), .CO32(), .CO31(), .CO30(), .CO29(), .CO28(), .CO27(), .CO26(),
		     .CO25(), .CO24(), .CO23(), .CO22(), .CO21(), .CO20(), .CO19(), .CO18(),
		     .CO17(), .CO16(), .CO15(), .CO14(), .CO13(), .CO12(), .CO11(), .CO10(),
		     .CO9(), .CO8(), .CO7(), .CO6(), .CO5(), .CO4(), .CO3(), .CO2(),
		     .CO1(), .CO0(), .EQZ(), .EQZM(), .EQOM(), .EQPAT(), .EQPATB(), .OVER(),
		     .UNDER(), .OVERUNDER(), .SIGNEDR(c[54]));


   VHI scuba_vhi_inst (.Z(scuba_vhi));

   VLO scuba_vlo_inst (.Z(scuba_vlo));
`endif

endmodule

