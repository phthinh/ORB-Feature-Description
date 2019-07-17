// This module take 3 cycles

module Centroid_Adder1(clk, rst, ena, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10,
		e11, e12, e13, e14, e15, e16, e17, e18, e19, e20, e21,
		e22, e23, e24, e25, e26, e27, e28, e29, e30, e31, e32,
		e33, e34, e35, e36, e37, out);

parameter W = 8; // pixel, max number is 255 so just need 8 bits, no sign
parameter BW_OUT = 22; // max when 37*255*(1+2+3+...+18) ~= 1m6, so 21 bit, plus 1 bit sign, so 22 bits
parameter ADDER_LAYER1_TIME1 = 9;
parameter ADDER_LAYER1_TIME2 = 10;
parameter ADDER_LAYER2_TIME1 = 11;
parameter ADDER_LAYER2_TIME2 = 12;
parameter ADDER_LAYER3_TIME1 = 13;
parameter ADDER_LAYER3_TIME2 = 14;

parameter BW_C1 = 14; // max value after adder is 255*37 ~= 9k, so 14 bits(always >0)

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

output [BW_C1-1:0] out;

// LAYER 1 //

// This is first adder
wire [ADDER_LAYER1_TIME1-1:0] c1;
wire [ADDER_LAYER1_TIME1-1:0] c2;
wire [ADDER_LAYER1_TIME1-1:0] c3;
wire [ADDER_LAYER1_TIME1-1:0] c4;
wire [ADDER_LAYER1_TIME1-1:0] c5;
wire [ADDER_LAYER1_TIME1-1:0] c6;
wire [ADDER_LAYER1_TIME1-1:0] c7;
wire [ADDER_LAYER1_TIME1-1:0] c8;
wire [ADDER_LAYER1_TIME1-1:0] c9;
wire [ADDER_LAYER1_TIME1-1:0] c10;
wire [ADDER_LAYER1_TIME1-1:0] c11;
wire [ADDER_LAYER1_TIME1-1:0] c12;
wire [ADDER_LAYER1_TIME1-1:0] c13;
wire [ADDER_LAYER1_TIME1-1:0] c14;
wire [ADDER_LAYER1_TIME1-1:0] c15;
wire [ADDER_LAYER1_TIME1-1:0] c16;
wire [ADDER_LAYER1_TIME1-1:0] c17;
wire [ADDER_LAYER1_TIME1-1:0] c18;
wire [ADDER_LAYER1_TIME1-1:0] c19;

assign c1 = e1 + e2; // max is 510, no sign, so need 9 bits
assign c2 = e3 + e4;
assign c3 = e5 + e6;
assign c4 = e7 + e8;
assign c5 = e9 + e10;
assign c6 = e11 + e12;
assign c7 = e13 + e14;
assign c8 = e15 + e16;
assign c9 = e17 + e18;
assign c10 = e19 + e20;
assign c11 = e21 + e22;
assign c12 = e23 + e24;
assign c13 = e25 + e26;
assign c14 = e27 + e28;
assign c15 = e29 + e30;
assign c16 = e31 + e32;
assign c17 = e33 + e34;
assign c18 = e35 + e36;
assign c19 = e37;

// this is the second adder

wire [ADDER_LAYER1_TIME2-1:0] d1, d1out;
wire [ADDER_LAYER1_TIME2-1:0] d2, d2out;
wire [ADDER_LAYER1_TIME2-1:0] d3, d3out;
wire [ADDER_LAYER1_TIME2-1:0] d4, d4out;
wire [ADDER_LAYER1_TIME2-1:0] d5, d5out;
wire [ADDER_LAYER1_TIME2-1:0] d6, d6out;
wire [ADDER_LAYER1_TIME2-1:0] d7, d7out;
wire [ADDER_LAYER1_TIME2-1:0] d8, d8out;
wire [ADDER_LAYER1_TIME2-1:0] d9, d9out;
wire [ADDER_LAYER1_TIME2-1:0] d10, d10out;

assign d1 = c1 + c2;
assign d2 = c3 + c4;
assign d3 = c5 + c6;
assign d4 = c7 + c8;
assign d5 = c9 + c10;
assign d6 = c11 + c12;
assign d7 = c13 + c14;
assign d8 = c15 + c16;
assign d9 = c17 + c18;
assign d10 = c19;

Delay_reg #(.WIDTH(ADDER_LAYER1_TIME2)) DFF_ADD00(clk, rst, ena, d1, d1out);
Delay_reg #(.WIDTH(ADDER_LAYER1_TIME2)) DFF_ADD01(clk, rst, ena, d2, d2out);
Delay_reg #(.WIDTH(ADDER_LAYER1_TIME2)) DFF_ADD02(clk, rst, ena, d3, d3out);
Delay_reg #(.WIDTH(ADDER_LAYER1_TIME2)) DFF_ADD03(clk, rst, ena, d4, d4out);
Delay_reg #(.WIDTH(ADDER_LAYER1_TIME2)) DFF_ADD04(clk, rst, ena, d5, d5out);
Delay_reg #(.WIDTH(ADDER_LAYER1_TIME2)) DFF_ADD05(clk, rst, ena, d6, d6out);
Delay_reg #(.WIDTH(ADDER_LAYER1_TIME2)) DFF_ADD06(clk, rst, ena, d7, d7out);
Delay_reg #(.WIDTH(ADDER_LAYER1_TIME2)) DFF_ADD07(clk, rst, ena, d8, d8out);
Delay_reg #(.WIDTH(ADDER_LAYER1_TIME2)) DFF_ADD08(clk, rst, ena, d9, d9out);
Delay_reg #(.WIDTH(ADDER_LAYER1_TIME2)) DFF_ADD09(clk, rst, ena, d10, d10out);

// LAYER2 //


// first adder
wire [ADDER_LAYER2_TIME1-1:0] i1;
wire [ADDER_LAYER2_TIME1-1:0] i2;
wire [ADDER_LAYER2_TIME1-1:0] i3;
wire [ADDER_LAYER2_TIME1-1:0] i4;
wire [ADDER_LAYER2_TIME1-1:0] i5;

assign i1 = d1out + d2out;
assign i2 = d3out + d4out;
assign i3 = d5out + d6out;
assign i4 = d7out + d8out;
assign i5 = d9out + d10out;

// second adder

wire [ADDER_LAYER2_TIME2-1:0] f1, f1out;
wire [ADDER_LAYER2_TIME2-1:0] f2, f2out;
wire [ADDER_LAYER2_TIME2-1:0] f3, f3out;

assign f1 = i1 + i2;
assign f2 = i3 + i4;
assign f3 = i5;

Delay_reg #(.WIDTH(ADDER_LAYER2_TIME2)) DFF_ADD10(clk, rst, ena, f1, f1out);
Delay_reg #(.WIDTH(ADDER_LAYER2_TIME2)) DFF_ADD11(clk, rst, ena, f2, f2out);
Delay_reg #(.WIDTH(ADDER_LAYER2_TIME2)) DFF_ADD12(clk, rst, ena, f3, f3out);

// LAYER 3 //

wire [ADDER_LAYER3_TIME1-1:0] g1;
wire [ADDER_LAYER3_TIME2-1:0] g2;

assign g1 = f1out + f2out;
assign g2 = f3out;

wire [ADDER_LAYER3_TIME2-1:0] h, hout;

assign h = g1 + g2;

Delay_reg #(.WIDTH(ADDER_LAYER3_TIME2)) DFF_ADD30(clk, rst, ena, h, hout);

assign out = hout;

endmodule