
// This file is Centroid block

module Centroid(clk, rst, ena, isCorner, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10,
		e11, e12, e13, e14, e15, e16, e17, e18, e19, e20, e21,
		e22, e23, e24, e25, e26, e27, e28, e29, e30, e31, e32,
		e33, e34, e35, e36, e37, m10_optimize, m01_optimize, valid);

parameter W = 8; // pixel, max number is 255 so just need 8 bits, no sign
parameter BW_OUT = 22; // max when 37*255*(1+2+3+...+18) ~= 1m6, so 21 bit, plus 1 bit sign, so 22 bits
parameter BW_OUT_OPTIMIZATION = 10;

// parameter to calculate m01
parameter BW_C1 = 14; // max value after adder is 255*37 ~= 9k, so 14 bits(always >0)
parameter BW_S1 = 19; // s is 35 times addition of c( so max is 35 * 37*255 ~=300k), so need 19 bits
parameter BW_MULTIPLY = 14; // value after multiply block

// parameter to calculate m01
parameter BW_C2 = 17; // max value after adder is 255*(0+1+2+...+18) ~= 40k, plus 1 sign bit so 17 bits

input clk;
input rst;
input ena;
input isCorner;

input [W-1:0] e1;
input [W-1:0] e2;
input [W-1:0] e3;
input [W-1:0] e4;
input [W-1:0] e5;
input [W-1:0] e6;
input [W-1:0] e7;
input [W-1:0] e8;
input [W-1:0] e9;
input [W-1:0] e10;
input [W-1:0] e11;
input [W-1:0] e12;
input [W-1:0] e13;
input [W-1:0] e14;
input [W-1:0] e15;
input [W-1:0] e16;
input [W-1:0] e17;
input [W-1:0] e18;
input [W-1:0] e19;
input [W-1:0] e20;
input [W-1:0] e21;
input [W-1:0] e22;
input [W-1:0] e23;
input [W-1:0] e24;
input [W-1:0] e25;
input [W-1:0] e26;
input [W-1:0] e27;
input [W-1:0] e28;
input [W-1:0] e29;
input [W-1:0] e30;
input [W-1:0] e31;
input [W-1:0] e32;
input [W-1:0] e33;
input [W-1:0] e34;
input [W-1:0] e35;
input [W-1:0] e36;
input [W-1:0] e37;



wire signed [BW_OUT-1:0] m10; // +1 for sign bit
wire signed [BW_OUT-1:0] m01; // +1 for sign bit

output signed [BW_OUT_OPTIMIZATION-1:0] m10_optimize;
output signed [BW_OUT_OPTIMIZATION-1:0] m01_optimize;

output valid;

// Shift isCorner many clocks as exact m10, m01
Valid_Shift_Register #(.D(43), .B(6)) Valid_Shift_Register_ins (clk, rst, isCorner, valid);

// Delay e1 -> e37
wire [W-1:0] e1_pp;
wire [W-1:0] e2_pp;
wire [W-1:0] e3_pp;
wire [W-1:0] e4_pp;
wire [W-1:0] e5_pp;
wire [W-1:0] e6_pp;
wire [W-1:0] e7_pp;
wire [W-1:0] e8_pp;
wire [W-1:0] e9_pp;
wire [W-1:0] e10_pp;
wire [W-1:0] e11_pp;
wire [W-1:0] e12_pp;
wire [W-1:0] e13_pp;
wire [W-1:0] e14_pp;
wire [W-1:0] e15_pp;
wire [W-1:0] e16_pp;
wire [W-1:0] e17_pp;
wire [W-1:0] e18_pp;
wire [W-1:0] e19_pp;
wire [W-1:0] e20_pp;
wire [W-1:0] e21_pp;
wire [W-1:0] e22_pp;
wire [W-1:0] e23_pp;
wire [W-1:0] e24_pp;
wire [W-1:0] e25_pp;
wire [W-1:0] e26_pp;
wire [W-1:0] e27_pp;
wire [W-1:0] e28_pp;
wire [W-1:0] e29_pp;
wire [W-1:0] e30_pp;
wire [W-1:0] e31_pp;
wire [W-1:0] e32_pp;
wire [W-1:0] e33_pp;
wire [W-1:0] e34_pp;
wire [W-1:0] e35_pp;
wire [W-1:0] e36_pp;
wire [W-1:0] e37_pp;

Delay_reg #(.WIDTH(W)) reg1(clk, rst, ena, e1, e1_pp);
Delay_reg #(.WIDTH(W)) reg2(clk, rst, ena, e2, e2_pp);
Delay_reg #(.WIDTH(W)) reg3(clk, rst, ena, e3, e3_pp);
Delay_reg #(.WIDTH(W)) reg4(clk, rst, ena, e4, e4_pp);
Delay_reg #(.WIDTH(W)) reg5(clk, rst, ena, e5, e5_pp);
Delay_reg #(.WIDTH(W)) reg6(clk, rst, ena, e6, e6_pp);
Delay_reg #(.WIDTH(W)) reg7(clk, rst, ena, e7, e7_pp);
Delay_reg #(.WIDTH(W)) reg8(clk, rst, ena, e8, e8_pp);
Delay_reg #(.WIDTH(W)) reg9(clk, rst, ena, e9, e9_pp);
Delay_reg #(.WIDTH(W)) reg10(clk, rst, ena, e10, e10_pp);
Delay_reg #(.WIDTH(W)) reg11(clk, rst, ena, e11, e11_pp);
Delay_reg #(.WIDTH(W)) reg12(clk, rst, ena, e12, e12_pp);
Delay_reg #(.WIDTH(W)) reg13(clk, rst, ena, e13, e13_pp);
Delay_reg #(.WIDTH(W)) reg14(clk, rst, ena, e14, e14_pp);
Delay_reg #(.WIDTH(W)) reg15(clk, rst, ena, e15, e15_pp);
Delay_reg #(.WIDTH(W)) reg16(clk, rst, ena, e16, e16_pp);
Delay_reg #(.WIDTH(W)) reg17(clk, rst, ena, e17, e17_pp);
Delay_reg #(.WIDTH(W)) reg18(clk, rst, ena, e18, e18_pp);
Delay_reg #(.WIDTH(W)) reg19(clk, rst, ena, e19, e19_pp);
Delay_reg #(.WIDTH(W)) reg20(clk, rst, ena, e20, e20_pp);
Delay_reg #(.WIDTH(W)) reg21(clk, rst, ena, e21, e21_pp);
Delay_reg #(.WIDTH(W)) reg22(clk, rst, ena, e22, e22_pp);
Delay_reg #(.WIDTH(W)) reg23(clk, rst, ena, e23, e23_pp);
Delay_reg #(.WIDTH(W)) reg24(clk, rst, ena, e24, e24_pp);
Delay_reg #(.WIDTH(W)) reg25(clk, rst, ena, e25, e25_pp);
Delay_reg #(.WIDTH(W)) reg26(clk, rst, ena, e26, e26_pp);
Delay_reg #(.WIDTH(W)) reg27(clk, rst, ena, e27, e27_pp);
Delay_reg #(.WIDTH(W)) reg28(clk, rst, ena, e28, e28_pp);
Delay_reg #(.WIDTH(W)) reg29(clk, rst, ena, e29, e29_pp);
Delay_reg #(.WIDTH(W)) reg30(clk, rst, ena, e30, e30_pp);
Delay_reg #(.WIDTH(W)) reg31(clk, rst, ena, e31, e31_pp);
Delay_reg #(.WIDTH(W)) reg32(clk, rst, ena, e32, e32_pp);
Delay_reg #(.WIDTH(W)) reg33(clk, rst, ena, e33, e33_pp);
Delay_reg #(.WIDTH(W)) reg34(clk, rst, ena, e34, e34_pp);
Delay_reg #(.WIDTH(W)) reg35(clk, rst, ena, e35, e35_pp);
Delay_reg #(.WIDTH(W)) reg36(clk, rst, ena, e36, e36_pp);
Delay_reg #(.WIDTH(W)) reg37(clk, rst, ena, e37, e37_pp);
/////////// calculate m10 ///////////// 42 cycles

// first add all 37 elements

wire [BW_C1-1:0] c; // the max sum is 37*255 ~= 9k, so need 14 bits

// This needs 3 cycles
Centroid_Adder1 Centroid_Adder1_instance(clk, rst, ena, e1_pp, e2_pp, e3_pp, e4_pp, e5_pp, 
		e6_pp, e7_pp, e8_pp, e9_pp, e10_pp, e11_pp, e12_pp, e13_pp, e14_pp, e15_pp, e16_pp, 
		e17_pp, e18_pp, e19_pp, e20_pp, e21_pp, e22_pp, e23_pp, e24_pp, e25_pp, e26_pp, e27_pp,
		e28_pp, e29_pp, e30_pp, e31_pp, e32_pp, e33_pp, e34_pp, e35_pp, e36_pp, e37_pp, c);
//

wire signed [BW_OUT-1:0] m01_out;
wire signed [BW_OUT-1:0] m01_in;
wire [BW_C1-1:0] a36;
wire [BW_C1-1:0] a37;
wire [BW_S1-1:0] s_in, s_out;
// This needs 37 cycles to sum 37 values + 2 pipelines ==================================================================
ShiftRegister #(.D(36), .WIDTH(BW_C1)) shiftRegister01(.clk(clk), .rst(rst), .ena(ena), .dat_in(c), .dat_out(a36));
Delay_reg #(.WIDTH(BW_C1)) DFF_01(.clk(clk), .rst(rst), .ena(ena), .dat_in(a36), .dat_out(a37));
Delay_reg #(.WIDTH(BW_S1)) DFF_02(.clk(clk), .rst(rst), .ena(ena), .dat_in(s_in), .dat_out(s_out));
Delay_reg #(.WIDTH(BW_OUT)) DFF_03(.clk(clk), .rst(rst), .ena(ena), .dat_in(m01_in), .dat_out(m01_out));

assign s_in = s_out + c - a36;

wire [BW_C1:0] sp, sp_pp; // this is temporary value of c + a37
assign sp = c + a37; //(c << 4) + (c << 1) +(a37 << 4) + (a37 << 1);

wire [BW_C1+5:0] sp_m18; // this is temporary value of 18*(c + a37)
assign sp_m18 = (sp_pp << 4) + (sp_pp << 1);


wire [BW_S1-1:0] s_out_pp1, s_out_pp2;
wire [BW_C1+5:0] sp_m18_pp; // dff out value

//1st pipeline stage
Delay_reg #(.WIDTH(BW_S1)) DFF_02a(.clk(clk), .rst(rst), .ena(ena), .dat_in(s_out), .dat_out(s_out_pp1));
Delay_reg #(.WIDTH(BW_C1+1)) DFF_SP01(.clk(clk), .rst(rst), .ena(ena), .dat_in(sp), .dat_out(sp_pp));


//2nd pipeline stage
Delay_reg #(.WIDTH(BW_S1)) DFF_02b(.clk(clk), .rst(rst), .ena(ena), .dat_in(s_out_pp1), .dat_out(s_out_pp2));
Delay_reg #(.WIDTH(BW_C1+6)) DFF_SP02(.clk(clk), .rst(rst), .ena(ena), .dat_in(sp_m18), .dat_out(sp_m18_pp));

assign m01_in =  m01_out + $signed({1'b0,sp_m18_pp}) - $signed({1'b0, s_out_pp2});

assign m01 = m01_out;



/////////// calculate m10 ///////////// 42 cycles
wire signed [BW_C2-1:0] c2;
wire signed [BW_C2-1:0] a2_37;

// first Multiply module
wire signed [BW_MULTIPLY-1:0] mo1; // output of multiplier
wire signed [BW_MULTIPLY-1:0] mo2;
wire signed [BW_MULTIPLY-1:0] mo3;
wire signed [BW_MULTIPLY-1:0] mo4;
wire signed [BW_MULTIPLY-1:0] mo5;
wire signed [BW_MULTIPLY-1:0] mo6;
wire signed [BW_MULTIPLY-1:0] mo7;
wire signed [BW_MULTIPLY-1:0] mo8;
wire signed [BW_MULTIPLY-1:0] mo9;
wire signed [BW_MULTIPLY-1:0] mo10;
wire signed [BW_MULTIPLY-1:0] mo11;
wire signed [BW_MULTIPLY-1:0] mo12;
wire signed [BW_MULTIPLY-1:0] mo13;
wire signed [BW_MULTIPLY-1:0] mo14;
wire signed [BW_MULTIPLY-1:0] mo15;
wire signed [BW_MULTIPLY-1:0] mo16;
wire signed [BW_MULTIPLY-1:0] mo17;
wire signed [BW_MULTIPLY-1:0] mo18;
//Centroid_Multiplier takes 2 cycles
Centroid_Multiplier Centroid_Multiplier_instance(clk, rst, ena, e1_pp, e2_pp, e3_pp, e4_pp, 
		e5_pp, e6_pp, e7_pp, e8_pp, e9_pp, e10_pp, e11_pp, e12_pp, e13_pp, e14_pp, e15_pp, 
		e16_pp, e17_pp, e18_pp, e19_pp, e20_pp, e21_pp, e22_pp, e23_pp, e24_pp, e25_pp, 
		e26_pp, e27_pp, e28_pp, e29_pp, e30_pp, e31_pp, e32_pp, e33_pp, e34_pp, e35_pp, 
		e36_pp, e37_pp, mo1, mo2, mo3, mo4, mo5, mo6, mo7, mo8, mo9, mo10, mo11, mo12,
		mo13, mo14, mo15, mo16, mo17, mo18);
//

//Centroid_Adder2 takes 3 cycles
Centroid_Adder2 Centroid_Adder2_instance(clk, rst, ena, mo1, mo2, mo3, mo4, mo5, mo6, mo7, mo8, mo9, mo10, mo11,
		mo12, mo13, mo14, mo15, mo16, mo17, mo18, c2);
//


// This needs 37 cycles to sum 37 values =================================================================================
wire signed [BW_OUT-1:0] m10_in;
wire signed [BW_OUT-1:0] m10_out;
assign m10_in = c2 + m10_out - a2_37;
ShiftRegister #(.D(37), .WIDTH(BW_C2)) shiftRegister02(.clk(clk), .rst(rst), .ena(ena), .dat_in(c2), 
			.dat_out(a2_37));
Delay_reg #(.WIDTH(BW_OUT)) DFF_04(.clk(clk), .rst(rst), .ena(ena), .dat_in(m10_in), .dat_out(m10_out));
// ========================================================================================================================
assign m10 = m10_out;

assign m01_optimize = m01[BW_OUT-1:BW_OUT-BW_OUT_OPTIMIZATION]; // change name
assign m10_optimize = m10[BW_OUT-1:BW_OUT-BW_OUT_OPTIMIZATION]; // change name

endmodule