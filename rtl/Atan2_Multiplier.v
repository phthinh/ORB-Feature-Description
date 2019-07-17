// 25 elements in table, first 10 bits for multiplying.
module Atan2_Multiplier(clk, rst, ena, x, y0, y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, y13, y14, y15,
			y16, y17, y18, y19, y20, y21, y22, y23, y24);

parameter BIT_WIDTH = 12; // maximum BIT LENGTH is 22 because window 37x37, 
			  // in case of 255, is 37x255(1+..+18) ~= 1m6, + 1 bit sign , so 22 bits. After optimize, it is 12
parameter NO_FIRSTBITS_MUL = 9;

input clk;
input rst;
input ena;

input [BIT_WIDTH-1:0] x;
output [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] y0, y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, y13, y14, y15,
						y16, y17, y18, y19, y20, y21, y22, y23, y24;


// first layer

wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w0, w0out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w1, w1out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w2, w2out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w3, w3out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w4, w4out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w5, w5out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w6, w6out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w7, w7out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w8, w8out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w9, w9out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w10, w10out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w11, w11out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w12, w12out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w13, w13out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w14, w14out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w15, w15out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w16, w16out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w17, w17out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w18, w18out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w19, w19out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w20, w20out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w21, w21out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w22, w22out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w23, w23out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] w24, w24out;


// help 1, 3, 15, 20, 37
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] x1, x1out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] x3, x3out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] x15, x15out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] x20, x20out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] x36, x36out;

assign x1 = x;
assign x3 = (x << 1) + x;
assign x15 = (x << 4) - x;
assign x20 = (x << 4) + (x << 2);
assign x36 = (x << 5) + (x << 2);


assign w0 = x << 1; // 2
assign w1 = (x << 2) + (x << 1); // 6
assign w2 = (x << 3) + (x << 1); // 10
assign w3 = (x << 4) - (x << 1); // 14
assign w4 = (x << 4) + (x << 1); // 18
assign w5 = (x << 4) + (x << 3); // 23, it is 24, minus 1
assign w6 = w3; // 27, it is 14, need to shift left 1 and minus 1
assign w7 = x << 5; // 32
assign w8 = (x << 5) + (x << 2); // 37, it is 36, add 1
assign w9 = (x << 5) + (x << 3); // 43, it is 40, add 3
assign w10 = (x << 5) + (x << 4); // 49, it is 48, add 1
assign w11 = w3; // 56, it is 14, shift 2 left
assign w12 = (x << 6) - x; // 63
assign w13 = (x << 6) + (x << 3); // 72
assign w14 = (x << 6) + (x << 4); // 82, it is 80, add 2
assign w15 = (x << 6) + (x << 5); // 94, it is 96, minus 2
assign w16 = w3; // 108, it is 14, shift 3, minus 4
assign w17 = (x << 7) - x; // 125, it is 127, minus 2
assign w18 = (x << 7) + (x << 4); // 147, it is 144, add 3
assign w19 = (x << 7) + (x << 6); // 177, it is 192, minus 15
assign w20 = x << 8; // 220, it is 256, minus 36(w8)
assign w21 = (x << 8) + (x << 5); // 286, it is 288, minus 2
assign w22 = (x << 8) + (x << 7); // 404, it is 384, add 20
assign w23 = w14 << 3; // 676, 640, add 36 =====================================================================
assign w24 = (x << 11) - (x << 4); // 2036, it is 2032, add 4

Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_regx1(clk, rst, ena, x1, x1out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_regx2(clk, rst, ena, x3, x3out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_regx3(clk, rst, ena, x15, x15out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_regx4(clk, rst, ena, x20, x20out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_regx5(clk, rst, ena, x36, x36out);

Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg00(clk, rst, ena, w0, w0out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg01(clk, rst, ena, w1, w1out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg02(clk, rst, ena, w2, w2out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg03(clk, rst, ena, w3, w3out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg04(clk, rst, ena, w4, w4out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg05(clk, rst, ena, w5, w5out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg06(clk, rst, ena, w6, w6out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg07(clk, rst, ena, w7, w7out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg08(clk, rst, ena, w8, w8out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg09(clk, rst, ena, w9, w9out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg10(clk, rst, ena, w10, w10out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg11(clk, rst, ena, w11, w11out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg12(clk, rst, ena, w12, w12out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg13(clk, rst, ena, w13, w13out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg14(clk, rst, ena, w14, w14out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg15(clk, rst, ena, w15, w15out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg16(clk, rst, ena, w16, w16out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg17(clk, rst, ena, w17, w17out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg18(clk, rst, ena, w18, w18out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg19(clk, rst, ena, w19, w19out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg20(clk, rst, ena, w20, w20out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg21(clk, rst, ena, w21, w21out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg22(clk, rst, ena, w22, w22out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg23(clk, rst, ena, w23, w23out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg24(clk, rst, ena, w24, w24out);

wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z0, z0out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z1, z1out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z2, z2out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z3, z3out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z4, z4out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z5, z5out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z6, z6out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z7, z7out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z8, z8out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z9, z9out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z10, z10out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z11, z11out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z12, z12out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z13, z13out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z14, z14out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z15, z15out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z16, z16out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z17, z17out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z18, z18out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z19, z19out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z20, z20out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z21, z21out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z22, z22out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z23, z23out;
wire [BIT_WIDTH + NO_FIRSTBITS_MUL - 1:0] z24, z24out;

assign z0 = w0out;
assign z1 = w1out;
assign z2 = w2out;
assign z3 = w3out;
assign z4 = w4out;
assign z5 = w5out - x1out;
assign z6 = (w6out << 1) - x1out;
assign z7 = w7out;
assign z8 = w8out + x1out;
assign z9 = w9out + x3out;
assign z10 = w10out + x1out;
assign z11 = w11out << 2;
assign z12 = w12out;
assign z13 = w13out;
assign z14 = w14out + w0out;
assign z15 = w15out - w0out;
assign z16 = (w16out << 3) - (x1out << 2);
assign z17 = w17out - w0out;
assign z18 = w18out + x3out;
assign z19 = w19out - x15out;
assign z20 = w20out - w8out;
assign z21 = w21out - w0out;
assign z22 = w22out + x20out;
assign z23 = w23out + x36out;
assign z24 = w24out + (x1out << 2);


Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg30(clk, rst, ena, z0, z0out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg31(clk, rst, ena, z1, z1out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg32(clk, rst, ena, z2, z2out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg33(clk, rst, ena, z3, z3out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg34(clk, rst, ena, z4, z4out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg35(clk, rst, ena, z5, z5out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg36(clk, rst, ena, z6, z6out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg37(clk, rst, ena, z7, z7out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg38(clk, rst, ena, z8, z8out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg39(clk, rst, ena, z9, z9out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg40(clk, rst, ena, z10, z10out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg41(clk, rst, ena, z11, z11out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg42(clk, rst, ena, z12, z12out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg43(clk, rst, ena, z13, z13out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg44(clk, rst, ena, z14, z14out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg45(clk, rst, ena, z15, z15out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg46(clk, rst, ena, z16, z16out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg47(clk, rst, ena, z17, z17out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg48(clk, rst, ena, z18, z18out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg49(clk, rst, ena, z19, z19out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg50(clk, rst, ena, z20, z20out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg51(clk, rst, ena, z21, z21out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg52(clk, rst, ena, z22, z22out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg53(clk, rst, ena, z23, z23out);
Delay_reg #(.WIDTH(BIT_WIDTH + NO_FIRSTBITS_MUL)) Delay_reg54(clk, rst, ena, z24, z24out);


assign y0 = z0out;
assign y1 = z1out;
assign y2 = z2out;
assign y3 = z3out;
assign y4 = z4out;
assign y5 = z5out;
assign y6 = z6out;
assign y7 = z7out;
assign y8 = z8out;
assign y9 = z9out;
assign y10 = z10out;
assign y11 = z11out;
assign y12 = z12out;
assign y13 = z13out;
assign y14 = z14out;
assign y15 = z15out;
assign y16 = z16out;
assign y17 = z17out;
assign y18 = z18out;
assign y19 = z19out;
assign y20 = z20out;
assign y21 = z21out;
assign y22 = z22out;
assign y23 = z23out;
assign y24 = z24out;

endmodule

