module Atan2(clk, rst, ena, y, x, sin, cos);

parameter BIT_WIDTH = 12; // maximum BIT LENGTH is 22 because window 37x37, 
			  // in case of 255, is 37x255(1+..+18) ~= 1m6, but it is all positive so 21 bit. Optimize after so it needs 10 bit
			// for sign, because positive so it needs 9 bit
parameter BW_OUT = 7; // WIDTH OF cos and sin

parameter NO_ELEMENTS_TABLE = 25; // number of elements in table
parameter WIDTH_INDEX = 5; // number of bits require to store index of TABLE
parameter WIDTH_X = 11; // number of first bits in tan table chosen to multiply with x ( easy to shift)

// y and x must be positive, to handle negative, do outside out of this module
input [BIT_WIDTH-1:0] y; // m01
input [BIT_WIDTH-1:0] x; // m10
input clk;
input rst;
input ena;

output [BW_OUT-1:0] cos;
output [BW_OUT-1:0] sin;


// next step is multiply x to each elements in table

wire [BIT_WIDTH + WIDTH_X - 1:0] y_table [NO_ELEMENTS_TABLE-1:0]; // width of y(m01) is equal the sum of width x(m10) and width of tan table

Atan2_Multiplier #(.BIT_WIDTH(BIT_WIDTH), .NO_FIRSTBITS_MUL(WIDTH_X)) Atan2_Multiplier_ins(clk, rst, ena, x, 
	y_table[0], y_table[1], y_table[2], y_table[3], y_table[4], y_table[5], y_table[6], y_table[7], y_table[8], 
	y_table[9], y_table[10], y_table[11], y_table[12], y_table[13], y_table[14], y_table[15], y_table[16], 
	y_table[17], y_table[18], y_table[19], y_table[20], y_table[21], y_table[22], y_table[23], y_table[24]);

// Because Atan2_Multiplier takes 2 clocks, we need to delay 'y' by 2 clocks too

// First stage ==============================
reg [BIT_WIDTH-1:0] y_pp1;
always @(posedge clk) begin
    if (rst) y_pp1 <= 0;
    else if (ena) y_pp1 <= y;
end
// ==========================================

// Second stage =============================
reg [BIT_WIDTH-1:0] y_pp2;
always @(posedge clk) begin
    if (rst) y_pp2 <= 0;
    else if (ena) y_pp2 <= y_pp1;
end
// ==========================================

// expand y from BIT_WIDTH bit to equal BIT_WIDTH + WIDTH_X bit so it could compare with y_table

wire [BIT_WIDTH+WIDTH_X-1:0] y_temp;


assign y_temp = {{5{1'b0}}, {y_pp2}, {(WIDTH_X-5){1'b0}}};// expand y from 22 bit to (A.Y.WIDTH_X-A) bit so is comparable with y_table,
						// A is max bit to store max integer value in tan_table, Y is y

// Compare each result in y_table with y
wire [NO_ELEMENTS_TABLE-1:0] bit_result;

genvar i;
generate
    for(i=0;i<=NO_ELEMENTS_TABLE-1;i=i+1) begin : HHH
	Atan2_Select #(.BW_INPUT(BIT_WIDTH+WIDTH_X)) Atan2_Select_instance(y_table[i], y_temp, bit_result[i]);
    end
endgenerate


// Third Stage ===========================================

wire [BIT_WIDTH + WIDTH_X - 1:0] y_table_pp3 [NO_ELEMENTS_TABLE-1:0];
wire [BIT_WIDTH+WIDTH_X-1:0] 		y_pp3;
wire [NO_ELEMENTS_TABLE-1:0] bit_result_pp3;


genvar k;
generate
	for(k=0;k<=NO_ELEMENTS_TABLE-1;k=k+1) begin : Stage3
		Delay_reg #(.WIDTH(BIT_WIDTH + WIDTH_X)) y_table_pp_Reg3(clk, rst, ena, y_table[k], y_table_pp3[k]);
	end
endgenerate

Delay_reg #(.WIDTH(BIT_WIDTH+WIDTH_X)) y_pp_Reg3(clk, rst, ena, y_temp, y_pp3);
Delay_reg #(.WIDTH(NO_ELEMENTS_TABLE)) bit_result_Reg3(clk, rst, ena, bit_result, bit_result_pp3);

wire [WIDTH_INDEX-1:0] index1;
wire [WIDTH_INDEX-1:0] index2;

Atan2_Decoder #(.WIDTH(NO_ELEMENTS_TABLE), .WIDTH_INDEX(WIDTH_INDEX)) Atan2_Decoder01(bit_result_pp3, index1, index2);

// fourth stage ===========================

wire [WIDTH_INDEX-1:0] index1_pp4;
wire [WIDTH_INDEX-1:0] index2_pp4;

wire [BIT_WIDTH + WIDTH_X - 1:0] y_table_pp4 [NO_ELEMENTS_TABLE-1:0];
wire [BIT_WIDTH+WIDTH_X-1:0] 		y_pp4;

genvar j;
generate
	for(j=0;j<=NO_ELEMENTS_TABLE-1;j=j+1) begin : Stage4
		Delay_reg #(.WIDTH(BIT_WIDTH + WIDTH_X)) y_table_pp_Reg4(clk, rst, ena, y_table_pp3[j], y_table_pp4[j]);
	end
endgenerate

Delay_reg #(.WIDTH(BIT_WIDTH + WIDTH_X)) y_pp_Reg4(clk, rst, ena, y_pp3, y_pp4);
Delay_reg #(.WIDTH(WIDTH_INDEX)) index1_pp_Reg4(clk, rst, ena, index1, index1_pp4);
Delay_reg #(.WIDTH(WIDTH_INDEX)) index2_pp_Reg4(clk, rst, ena, index2, index2_pp4);

//assign index2_pp4 = (index1_pp4 == (NO_ELEMENTS_TABLE-1)) ? 0 : index1_pp4 + 1;

wire [BIT_WIDTH+WIDTH_X-1:0] 		y_candidate0  = y_table_pp4[index1_pp4];
wire [BIT_WIDTH+WIDTH_X-1:0] 		y_candidate1  = y_table_pp4[index2_pp4];

// ========================================

// Fifth stage

wire [WIDTH_INDEX-1:0] index1_pp5, index2_pp5;
wire [BIT_WIDTH+WIDTH_X-1:0] y_candidate0_pp5, y_candidate1_pp5;
wire [BIT_WIDTH+WIDTH_X-1:0] y_pp5;

Delay_reg #(.WIDTH(WIDTH_INDEX)) Delay_index1_pp5(clk, rst, ena, index1_pp4, index1_pp5);
Delay_reg #(.WIDTH(WIDTH_INDEX)) Delay_index2_pp5(clk, rst, ena, index2_pp4, index2_pp5);

Delay_reg #(.WIDTH(BIT_WIDTH+WIDTH_X)) Delay_y0_pp5(clk, rst, ena, y_candidate0, y_candidate0_pp5);
Delay_reg #(.WIDTH(BIT_WIDTH+WIDTH_X)) Delay_y1_pp5(clk, rst, ena, y_candidate1, y_candidate1_pp5);
Delay_reg #(.WIDTH(BIT_WIDTH+WIDTH_X)) y_pp_Reg5(clk, rst, ena, y_pp4, y_pp5);

wire compare_cadidates = (y_pp5 - y_candidate0_pp5) <= (y_candidate1_pp5 - y_pp5);
wire [WIDTH_INDEX-1:0] index_correct = (compare_cadidates)? index1_pp5 : index2_pp5; // = 1 choose candidate 0 (index); 0 choose candidate1 (index + 1)

// Sixth stage ===================================
reg [WIDTH_INDEX-1:0] index_delay;

always @(posedge clk) begin
    if (rst) index_delay <= 0;
    else if (ena) index_delay <= index_correct;
end

// ==================================================

wire [BW_OUT-1:0] cos_temp;
wire [BW_OUT-1:0] sin_temp;

Angle_LUT_Cos_Sin #(.BW_OUT(BW_OUT)) Angle_LUT_Cos_Sin_instance(index_delay, sin_temp, cos_temp);

// Seventh stage ===================================

Delay_reg #(.WIDTH(BW_OUT)) Delay_cos(clk, rst, ena, cos_temp, cos);
Delay_reg #(.WIDTH(BW_OUT)) Delay_sin(clk, rst, ena, sin_temp, sin);

// ==================================================


endmodule