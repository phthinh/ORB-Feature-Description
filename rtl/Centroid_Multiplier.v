// This takes 2 cycles

module Centroid_Multiplier(clk, rst, ena, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10,
		e11, e12, e13, e14, e15, e16, e17, e18, e19, e20, e21,
		e22, e23, e24, e25, e26, e27, e28, e29, e30, e31, e32,
		e33, e34, e35, e36, e37, out1, out2, out3, out4, out5, out6, out7, out8, out9,
		out10, out11, out12, out13, out14, out15, out16, out17, out18);

parameter W = 8; // pixel, max number is 255 so just need 8 bits, no sign
parameter BW_C2 = 17; // max value after adder is 255*(0+1+2+...+18) ~= 40k, plus 1 sign bit so 17 bits

parameter BW_ADD = 9;
parameter BW_MULTIPLY = 14;

input clk;
input rst;
input ena;

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

output signed [BW_MULTIPLY-1:0] out1;
output signed [BW_MULTIPLY-1:0] out2;
output signed [BW_MULTIPLY-1:0] out3;
output signed [BW_MULTIPLY-1:0] out4;
output signed [BW_MULTIPLY-1:0] out5;
output signed [BW_MULTIPLY-1:0] out6;
output signed [BW_MULTIPLY-1:0] out7;
output signed [BW_MULTIPLY-1:0] out8;
output signed [BW_MULTIPLY-1:0] out9;
output signed [BW_MULTIPLY-1:0] out10;
output signed [BW_MULTIPLY-1:0] out11;
output signed [BW_MULTIPLY-1:0] out12;
output signed [BW_MULTIPLY-1:0] out13;
output signed [BW_MULTIPLY-1:0] out14;
output signed [BW_MULTIPLY-1:0] out15;
output signed [BW_MULTIPLY-1:0] out16;
output signed [BW_MULTIPLY-1:0] out17;
output signed [BW_MULTIPLY-1:0] out18;

// FIRST, SUBSTRACT

wire signed [BW_ADD-1:0] c1, c1out;
wire signed [BW_ADD-1:0] c2, c2out;
wire signed [BW_ADD-1:0] c3, c3out;
wire signed [BW_ADD-1:0] c4, c4out;
wire signed [BW_ADD-1:0] c5, c5out;
wire signed [BW_ADD-1:0] c6, c6out;
wire signed [BW_ADD-1:0] c7, c7out;
wire signed [BW_ADD-1:0] c8, c8out;
wire signed [BW_ADD-1:0] c9, c9out;
wire signed [BW_ADD-1:0] c10, c10out;
wire signed [BW_ADD-1:0] c11, c11out;
wire signed [BW_ADD-1:0] c12, c12out;
wire signed [BW_ADD-1:0] c13, c13out;
wire signed [BW_ADD-1:0] c14, c14out;
wire signed [BW_ADD-1:0] c15, c15out;
wire signed [BW_ADD-1:0] c16, c16out;
wire signed [BW_ADD-1:0] c17, c17out;
wire signed [BW_ADD-1:0] c18, c18out;

assign c1 = e20 - e18;
assign c2 = e21 - e17;
assign c3 = e22 - e16;
assign c4 = e23 - e15;
assign c5 = e24 - e14;
assign c6 = e25 - e13;
assign c7 = e26 - e12;
assign c8 = e27 - e11;
assign c9 = e28 - e10;
assign c10 = e29 - e9;
assign c11 = e30 - e8;
assign c12 = e31 - e7;
assign c13 = e32 - e6;
assign c14 = e33 - e5;
assign c15 = e34 - e4;
assign c16 = e35 - e3;
assign c17 = e36 - e2;
assign c18 = e37 - e1;

// DFF after substraction

Delay_reg #(.WIDTH(BW_ADD)) DFF01(clk, rst, ena, c1, c1out);
Delay_reg #(.WIDTH(BW_ADD)) DFF02(clk, rst, ena, c2, c2out);
Delay_reg #(.WIDTH(BW_ADD)) DFF03(clk, rst, ena, c3, c3out);
Delay_reg #(.WIDTH(BW_ADD)) DFF04(clk, rst, ena, c4, c4out);
Delay_reg #(.WIDTH(BW_ADD)) DFF05(clk, rst, ena, c5, c5out);
Delay_reg #(.WIDTH(BW_ADD)) DFF06(clk, rst, ena, c6, c6out);
Delay_reg #(.WIDTH(BW_ADD)) DFF07(clk, rst, ena, c7, c7out);
Delay_reg #(.WIDTH(BW_ADD)) DFF08(clk, rst, ena, c8, c8out);
Delay_reg #(.WIDTH(BW_ADD)) DFF09(clk, rst, ena, c9, c9out);
Delay_reg #(.WIDTH(BW_ADD)) DFF10(clk, rst, ena, c10, c10out);
Delay_reg #(.WIDTH(BW_ADD)) DFF11(clk, rst, ena, c11, c11out);
Delay_reg #(.WIDTH(BW_ADD)) DFF12(clk, rst, ena, c12, c12out);
Delay_reg #(.WIDTH(BW_ADD)) DFF13(clk, rst, ena, c13, c13out);
Delay_reg #(.WIDTH(BW_ADD)) DFF14(clk, rst, ena, c14, c14out);
Delay_reg #(.WIDTH(BW_ADD)) DFF15(clk, rst, ena, c15, c15out);
Delay_reg #(.WIDTH(BW_ADD)) DFF16(clk, rst, ena, c16, c16out);
Delay_reg #(.WIDTH(BW_ADD)) DFF17(clk, rst, ena, c17, c17out);
Delay_reg #(.WIDTH(BW_ADD)) DFF18(clk, rst, ena, c18, c18out);

// MULTIPLY LAYER // 

wire signed [BW_MULTIPLY-1:0] b1, b1out;
wire signed [BW_MULTIPLY-1:0] b2, b2out;
wire signed [BW_MULTIPLY-1:0] b3, b3out;
wire signed [BW_MULTIPLY-1:0] b4, b4out;
wire signed [BW_MULTIPLY-1:0] b5, b5out;
wire signed [BW_MULTIPLY-1:0] b6, b6out;
wire signed [BW_MULTIPLY-1:0] b7, b7out;
wire signed [BW_MULTIPLY-1:0] b8, b8out;
wire signed [BW_MULTIPLY-1:0] b9, b9out;
wire signed [BW_MULTIPLY-1:0] b10, b10out;
wire signed [BW_MULTIPLY-1:0] b11, b11out;
wire signed [BW_MULTIPLY-1:0] b12, b12out;
wire signed [BW_MULTIPLY-1:0] b13, b13out;
wire signed [BW_MULTIPLY-1:0] b14, b14out;
wire signed [BW_MULTIPLY-1:0] b15, b15out;
wire signed [BW_MULTIPLY-1:0] b16, b16out;
wire signed [BW_MULTIPLY-1:0] b17, b17out;
wire signed [BW_MULTIPLY-1:0] b18, b18out;

assign b1 = c1out; // max is 255
assign b2 = c2out << 1; // *2 // max is 510
assign b3 = (c3out << 2) - c3out; // *3 max is 765
assign b4 = c4out << 2; // 4
assign b5 = (c5out << 2) + c5out; // 5
assign b6 = (c6out << 3) - (c6out << 1); // 6
assign b7 = (c7out << 3) - c7out;
assign b8 = c8out << 3; // 8
assign b9 = (c9out << 3) + c9out;
assign b10 = (c10out << 3) + (c10out << 1);
assign b11 = (c11out << 3) + (c11out << 2) - c11out;
assign b12 = (c12out << 4) - (c12out << 2);
assign b13 = (c13out << 4) - (c13out << 2) + c13out;
assign b14 = (c14out << 4) - (c14out << 1);
assign b15 = (c15out << 4) - c15out;
assign b16 = c16out << 4;
assign b17 = (c17out << 4) + c17out; // max is 
assign b18 = (c18out << 4) + (c18out << 1); // max is -4590 to 4590

// LAYER 1 //

Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF21(clk, rst, ena, b1, b1out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF22(clk, rst, ena, b2, b2out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF23(clk, rst, ena, b3, b3out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF24(clk, rst, ena, b4, b4out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF25(clk, rst, ena, b5, b5out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF26(clk, rst, ena, b6, b6out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF27(clk, rst, ena, b7, b7out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF28(clk, rst, ena, b8, b8out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF29(clk, rst, ena, b9, b9out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF30(clk, rst, ena, b10, b10out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF31(clk, rst, ena, b11, b11out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF32(clk, rst, ena, b12, b12out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF33(clk, rst, ena, b13, b13out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF34(clk, rst, ena, b14, b14out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF35(clk, rst, ena, b15, b15out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF36(clk, rst, ena, b16, b16out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF37(clk, rst, ena, b17, b17out);
Delay_reg #(.WIDTH(BW_MULTIPLY)) DFF38(clk, rst, ena, b18, b18out);


assign out1 = b1out;
assign out2 = b2out;
assign out3 = b3out;
assign out4 = b4out;
assign out5 = b5out;
assign out6 = b6out;
assign out7 = b7out;
assign out8 = b8out;
assign out9 = b9out;
assign out10 = b10out;
assign out11 = b11out;
assign out12 = b12out;
assign out13 = b13out;
assign out14 = b14out;
assign out15 = b15out;
assign out16 = b16out;
assign out17 = b17out;
assign out18 = b18out;

endmodule
