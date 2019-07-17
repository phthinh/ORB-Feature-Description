// This take 3 cycles

module Centroid_Adder2(clk, rst, ena, bout1, bout2, bout3, bout4, bout5, bout6, bout7, bout8, bout9, bout10, bout11, bout12, 
			bout13, bout14, bout15, bout16, bout17, bout18, out);

parameter W = 8; // pixel, max number is 255 so just need 8 bits, no sign
parameter BW_C2 = 17; // max value after adder is 255*(0+1+2+...+18) ~= 40k, plus 1 sign bit so 17 bits

parameter BW_ADD = 9;
parameter BW_MULTIPLY = 14;


parameter BW_ADDER2_TIME1 = 15;
parameter BW_ADDER2_TIME2 = 15;

parameter BW_ADDER3_TIME1 = 16;
parameter BW_ADDER3_TIME2 = 17;

parameter BW_ADDER4 = 17;

input clk;
input rst;
input ena;

output signed [BW_C2-1:0] out;

input signed [BW_MULTIPLY-1:0] bout1;
input signed [BW_MULTIPLY-1:0] bout2;
input signed [BW_MULTIPLY-1:0] bout3;
input signed [BW_MULTIPLY-1:0] bout4;
input signed [BW_MULTIPLY-1:0] bout5;
input signed [BW_MULTIPLY-1:0] bout6;
input signed [BW_MULTIPLY-1:0] bout7;
input signed [BW_MULTIPLY-1:0] bout8;
input signed [BW_MULTIPLY-1:0] bout9;
input signed [BW_MULTIPLY-1:0] bout10;
input signed [BW_MULTIPLY-1:0] bout11;
input signed [BW_MULTIPLY-1:0] bout12;
input signed [BW_MULTIPLY-1:0] bout13;
input signed [BW_MULTIPLY-1:0] bout14;
input signed [BW_MULTIPLY-1:0] bout15;
input signed [BW_MULTIPLY-1:0] bout16;
input signed [BW_MULTIPLY-1:0] bout17;
input signed [BW_MULTIPLY-1:0] bout18;


// LAYER 1 // 

// first adder
wire signed [BW_ADDER2_TIME1-1:0] f1;
wire signed [BW_ADDER2_TIME1-1:0] f2;
wire signed [BW_ADDER2_TIME1-1:0] f3;
wire signed [BW_ADDER2_TIME1-1:0] f4;
wire signed [BW_ADDER2_TIME1-1:0] f5;
wire signed [BW_ADDER2_TIME1-1:0] f6;
wire signed [BW_ADDER2_TIME1-1:0] f7;
wire signed [BW_ADDER2_TIME1-1:0] f8;
wire signed [BW_ADDER2_TIME1-1:0] f9;


assign f1 = bout1 + bout2; // max is -765 to 765
assign f2 = bout3 + bout4; // max is -1785 to 1785
assign f3 = bout5 + bout6; // max is -2805 to 2805
assign f4 = bout7 + bout8; // max -3825 to 3825
assign f5 = bout9 + bout10; // max is -4845 to 4845
assign f6 = bout11 + bout12; // max is -5865 to 5865
assign f7 = bout13 + bout14; // max is -6885 to 6885
assign f8 = bout15 + bout16; // max is -7905 to 7905
assign f9 = bout17 + bout18; // max is -8925 to 8925

wire signed [BW_ADDER2_TIME2-1:0] g1, g1out;
wire signed [BW_ADDER2_TIME2-1:0] g2, g2out;
wire signed [BW_ADDER2_TIME2-1:0] g3, g3out;
wire signed [BW_ADDER2_TIME2-1:0] g4, g4out;
wire signed [BW_ADDER2_TIME2-1:0] g5, g5out;

assign g1 = f1 + f2; // max is -765 to 2550
assign g2 = f3 + f4; // max is -1785 to 6630
assign g3 = f5 + f6; // max is -2805 to 10710
assign g4 = f7 + f8; // max -3825 to 14790
assign g5 = f9; // max is -4845 to 8925


Delay_reg #(.WIDTH(BW_ADDER2_TIME2)) DFF20(clk, rst, ena, g1, g1out);
Delay_reg #(.WIDTH(BW_ADDER2_TIME2)) DFF21(clk, rst, ena, g2, g2out);
Delay_reg #(.WIDTH(BW_ADDER2_TIME2)) DFF22(clk, rst, ena, g3, g3out);
Delay_reg #(.WIDTH(BW_ADDER2_TIME2)) DFF23(clk, rst, ena, g4, g4out);
Delay_reg #(.WIDTH(BW_ADDER2_TIME2)) DFF24(clk, rst, ena, g5, g5out);


// LAYER 2 // 


wire signed [BW_ADDER3_TIME1-1:0] h1;
wire signed [BW_ADDER3_TIME1-1:0] h2;
wire signed [BW_ADDER3_TIME1-1:0] h3;


assign h1 = g1out + g2out; // max is -765 to 9180
assign h2 = g3out + g4out; // max is -1785 to 25550
assign h3 = g5out; // max is -2805 to 89254

wire signed [BW_ADDER3_TIME2-1:0] i1, i1out;
wire signed [BW_ADDER3_TIME2-1:0] i2, i2out;

assign i1 = h1 + h2; // max is -765 to 34730
assign i2 = h3; // max is -1785 to 8925

Delay_reg #(.WIDTH(BW_ADDER3_TIME2)) DFF30(clk, rst, ena, i1, i1out);
Delay_reg #(.WIDTH(BW_ADDER3_TIME2)) DFF31(clk, rst, ena, i2, i2out);


// LAYER 3 //

wire signed [BW_ADDER4-1:0] j, jout;
assign j = i1out + i2out; // max is -765 to 43655

Delay_reg #(.WIDTH(BW_ADDER4)) DFF41(clk, rst, ena, j, jout);

assign out = jout;

endmodule