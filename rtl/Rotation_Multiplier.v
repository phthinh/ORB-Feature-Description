module Rotation_Multiplier(clk, rst, ena, theta, theta0, theta1, theta2, theta3, theta4, theta5, theta6, theta7, theta8, theta9,
		theta10, theta11, theta12, theta13, theta14, theta15, theta16, theta17, theta18);

parameter BW_XCOS = 16;
parameter BW_TRIGONOMETRY = 11;

input signed [BW_TRIGONOMETRY-1:0] theta;
input clk;
input rst;
input ena;

output signed [BW_XCOS-1:0] theta0;
output signed [BW_XCOS-1:0] theta1;
output signed [BW_XCOS-1:0] theta2;
output signed [BW_XCOS-1:0] theta3;
output signed [BW_XCOS-1:0] theta4;
output signed [BW_XCOS-1:0] theta5;
output signed [BW_XCOS-1:0] theta6;
output signed [BW_XCOS-1:0] theta7;
output signed [BW_XCOS-1:0] theta8;
output signed [BW_XCOS-1:0] theta9;
output signed [BW_XCOS-1:0] theta10;
output signed [BW_XCOS-1:0] theta11;
output signed [BW_XCOS-1:0] theta12;
output signed [BW_XCOS-1:0] theta13;
output signed [BW_XCOS-1:0] theta14;
output signed [BW_XCOS-1:0] theta15;
output signed [BW_XCOS-1:0] theta16;
output signed [BW_XCOS-1:0] theta17;
output signed [BW_XCOS-1:0] theta18;


// first layer

wire signed [BW_XCOS-1:0] w0, w0out;
wire signed [BW_XCOS-1:0] w1, w1out;
wire signed [BW_XCOS-1:0] w2, w2out;
wire signed [BW_XCOS-1:0] w3, w3out;
wire signed [BW_XCOS-1:0] w4, w4out;
wire signed [BW_XCOS-1:0] w5, w5out;

wire signed [BW_XCOS-1:0] w7, w7out;
wire signed [BW_XCOS-1:0] w8, w8out;
wire signed [BW_XCOS-1:0] w9, w9out;

wire signed [BW_XCOS-1:0] w15, w15out;
wire signed [BW_XCOS-1:0] w16, w16out;
wire signed [BW_XCOS-1:0] w17, w17out;


assign w0 = {BW_XCOS{1'b0}};
assign w1 = theta;
assign w2 = theta << 1;
assign w4 = theta << 2;
assign w3 = w4 - theta;
assign w5 = w4 + theta;
assign w8 = theta << 3;
assign w7 = w8 - theta;
assign w9 = w8 + theta;
assign w16 = theta << 4;
assign w15 = w16 - theta;
assign w17 = w16 + theta;

Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg0(clk, rst, ena,  w0, w0out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg1(clk, rst, ena,  w1, w1out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg2(clk, rst, ena,  w2, w2out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg3(clk, rst, ena,  w3, w3out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg4(clk, rst, ena,  w4, w4out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg5(clk, rst, ena,  w5, w5out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg6(clk, rst, ena,  w7, w7out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg7(clk, rst, ena,  w8, w8out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg8(clk, rst, ena,  w9, w9out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg9(clk, rst, ena,  w15, w15out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg10(clk, rst, ena,  w16, w16out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg11(clk, rst, ena,  w17, w17out);

// 2nd layer
wire signed [BW_XCOS-1:0] z0, z0out;
wire signed [BW_XCOS-1:0] z1, z1out;
wire signed [BW_XCOS-1:0] z2, z2out;
wire signed [BW_XCOS-1:0] z3, z3out;
wire signed [BW_XCOS-1:0] z4, z4out;
wire signed [BW_XCOS-1:0] z5, z5out;
wire signed [BW_XCOS-1:0] z6, z6out;
wire signed [BW_XCOS-1:0] z7, z7out;
wire signed [BW_XCOS-1:0] z8, z8out;
wire signed [BW_XCOS-1:0] z9, z9out;
wire signed [BW_XCOS-1:0] z10, z10out;
wire signed [BW_XCOS-1:0] z11, z11out;
wire signed [BW_XCOS-1:0] z12, z12out;
wire signed [BW_XCOS-1:0] z13, z13out;
wire signed [BW_XCOS-1:0] z14, z14out;
wire signed [BW_XCOS-1:0] z15, z15out;
wire signed [BW_XCOS-1:0] z16, z16out;
wire signed [BW_XCOS-1:0] z17, z17out;
wire signed [BW_XCOS-1:0] z18, z18out;

assign z0 = w0out;
assign z1 = w1out;
assign z2 = w2out;
assign z3 = w3out;
assign z4 = w4out;
assign z5 = w5out;
assign z6 = w3out << 1;
assign z7 = w7out;
assign z8 = w8out;
assign z9 = w9out;
assign z10 = w5out << 1;
assign z11 = w8out + w3out;
assign z12 = w3out << 2;
assign z13 = w5out + w8out;
assign z14 = w7out << 1;
assign z15 = w15out;
assign z16 = w16out;
assign z17 = w17out;
assign z18 = w9out << 1;

Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg20(clk, rst, ena,  z0, z0out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg21(clk, rst, ena,  z1, z1out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg22(clk, rst, ena,  z2, z2out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg23(clk, rst, ena,  z3, z3out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg24(clk, rst, ena,  z4, z4out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg25(clk, rst, ena,  z5, z5out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg26(clk, rst, ena,  z6, z6out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg27(clk, rst, ena,  z7, z7out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg28(clk, rst, ena,  z8, z8out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg29(clk, rst, ena,  z9, z9out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg30(clk, rst, ena,  z10, z10out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg31(clk, rst, ena,  z11, z11out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg32(clk, rst, ena,  z12, z12out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg33(clk, rst, ena,  z13, z13out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg34(clk, rst, ena,  z14, z14out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg35(clk, rst, ena,  z15, z15out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg36(clk, rst, ena,  z16, z16out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg37(clk, rst, ena,  z17, z17out);
Delay_reg #(.WIDTH(BW_XCOS)) Delay_reg38(clk, rst, ena,  z18, z18out);

assign theta0 = z0out;
assign theta1 = z1out;
assign theta2 = z2out;
assign theta3 = z3out;
assign theta4 = z4out;
assign theta5 = z5out;
assign theta6 = z6out;
assign theta7 = z7out;
assign theta8 = z8out;
assign theta9 = z9out;
assign theta10 = z10out;
assign theta11 = z11out;
assign theta12 = z12out;
assign theta13 = z13out;
assign theta14 = z14out;
assign theta15 = z15out;
assign theta16 = z16out;
assign theta17 = z17out;
assign theta18 = z18out;

endmodule




