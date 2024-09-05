// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Thu Apr  4 13:40:07 2019
// Host        : DESKTOP-V0T5RHE running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               C:/Users/klink/Desktop/TripGenie/TripGenie.sim/sim_1/synth/func/xsim/TripGenieSimu_func_synth.v
// Design      : TripGenie
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NotValidForBitStream *)
module TripGenie
   (Hooterville,
    SilerCity,
    Mayberry,
    MtPilot,
    Hwy1,
    Hwy2,
    Hwy3,
    Hwy4,
    Hwy5,
    Hwy6);
  input Hooterville;
  input SilerCity;
  input Mayberry;
  input MtPilot;
  output Hwy1;
  output Hwy2;
  output Hwy3;
  output Hwy4;
  output Hwy5;
  output Hwy6;

  wire Hooterville;
  wire Hooterville_IBUF;
  wire Hwy1;
  wire Hwy1_OBUF;
  wire Hwy2;
  wire Hwy2_OBUF;
  wire Hwy3;
  wire Hwy3_OBUF;
  wire Hwy4;
  wire Hwy5;
  wire Hwy6;
  wire Hwy6_OBUF;
  wire Mayberry;
  wire Mayberry_IBUF;
  wire MtPilot;
  wire MtPilot_IBUF;
  wire SilerCity;
  wire SilerCity_IBUF;

  IBUF Hooterville_IBUF_inst
       (.I(Hooterville),
        .O(Hooterville_IBUF));
  OBUF Hwy1_OBUF_inst
       (.I(Hwy1_OBUF),
        .O(Hwy1));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h0228)) 
    Hwy1_OBUF_inst_i_1
       (.I0(SilerCity_IBUF),
        .I1(Hooterville_IBUF),
        .I2(Mayberry_IBUF),
        .I3(MtPilot_IBUF),
        .O(Hwy1_OBUF));
  OBUF Hwy2_OBUF_inst
       (.I(Hwy2_OBUF),
        .O(Hwy2));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'h0060)) 
    Hwy2_OBUF_inst_i_1
       (.I0(SilerCity_IBUF),
        .I1(Hooterville_IBUF),
        .I2(MtPilot_IBUF),
        .I3(Mayberry_IBUF),
        .O(Hwy2_OBUF));
  OBUF Hwy3_OBUF_inst
       (.I(Hwy3_OBUF),
        .O(Hwy3));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h0060)) 
    Hwy3_OBUF_inst_i_1
       (.I0(Hooterville_IBUF),
        .I1(SilerCity_IBUF),
        .I2(Mayberry_IBUF),
        .I3(MtPilot_IBUF),
        .O(Hwy3_OBUF));
  OBUF Hwy4_OBUF_inst
       (.I(1'b0),
        .O(Hwy4));
  OBUF Hwy5_OBUF_inst
       (.I(1'b0),
        .O(Hwy5));
  OBUF Hwy6_OBUF_inst
       (.I(Hwy6_OBUF),
        .O(Hwy6));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h0040)) 
    Hwy6_OBUF_inst_i_1
       (.I0(Hooterville_IBUF),
        .I1(MtPilot_IBUF),
        .I2(Mayberry_IBUF),
        .I3(SilerCity_IBUF),
        .O(Hwy6_OBUF));
  IBUF Mayberry_IBUF_inst
       (.I(Mayberry),
        .O(Mayberry_IBUF));
  IBUF MtPilot_IBUF_inst
       (.I(MtPilot),
        .O(MtPilot_IBUF));
  IBUF SilerCity_IBUF_inst
       (.I(SilerCity),
        .O(SilerCity_IBUF));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
