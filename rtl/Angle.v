module Angle(clk, rst, ena, angle_ena, x, y, cos, sin, valid);

parameter BW_IN = 12; // max when 37*255*(1+2+3+...+18) ~= 1m6, so 21 bit, plus 1 bit sign, so 22 bits, but after optimize is 12 bit
parameter BW_OUT = 7; // make sure that output has the form [1 bit integer . BW_OUT-1 bit fractions] because -1 <= cos,sin <= 1, but
                      // we approximately 1 ~= 0.9999; therefore, we just need 1 bit for integer part. Then optimize to BW_OUT bits
parameter WIDTH_SHIFT = 11; // number of bit shift in atan2_table


input signed [BW_IN-1:0] x; // m10
input signed [BW_IN-1:0] y; // m01

input clk;
input rst;
input ena;
input angle_ena;

output reg signed [BW_OUT-1:0] cos;
output reg signed [BW_OUT-1:0] sin;
output valid;

// Shift ena many clocks as output needs to get result from input

Valid_Shift_Register #(.D(7), .B(3)) Valid_Shift_Register_ins(clk, rst, angle_ena, valid);


// check if x or y is smaller than 0, convert it
wire sign_x; // sign of x, 1 if negative, 0 if positive
wire sign_y; // sign of y, 1 if negative, 0 if positive

wire signed [BW_IN-1-1:0] newx; // newx is new position of x after rotation, newx is positive after rotation
wire signed [BW_IN-1-1:0] newy; // newy is new position of y after rotation, newy is positive after rotation

assign sign_x = (x[BW_IN-1] == 1'b1) ? 1'b1 : 1'b0;
assign sign_y = (y[BW_IN-1] == 1'b1) ? 1'b1 : 1'b0;

wire signed [BW_IN-1:0] absx; // absolute value of x
wire signed [BW_IN-1:0] absy; // absolute value of y

assign absx = (x[BW_IN-1] == 1'b1) ? ~x + 1'b1 : x;
assign absy = (y[BW_IN-1] == 1'b1) ? ~y + 1'b1 : y;

wire [1:0] index;

//assign index = (sign_x == 0 && sign_y == 0) ? 3'b000 :
//		(sign_x == 1 && sign_y == 0) ? 3'b001 :
//		(sign_x == 1 && sign_y == 1) ? 3'b010 :
//		(sign_x == 0 && sign_y == 1) ? 3'b011 :
//		(x == {BW_IN{1'b0}} && sign_y == 0) ? 3'b100 :
//		(x == {BW_IN{1'b0}} && sign_y == 1) ? 3'b101 :
//		(y == {BW_IN{1'b0}} && sign_x == 0) ? 3'b110 : 3'b111;
//
//assign newx = (sign_x == 0 && sign_y == 0) ? x[BW_IN-2:0] :
//		(sign_x == 1 && sign_y == 0) ? y[BW_IN-2:0] :
//		(sign_x == 1 && sign_y == 1) ? absx[BW_IN-2:0] :
//		(sign_x == 0 && sign_y == 1) ? absy[BW_IN-2:0] :
//		(x == {BW_IN{1'b0}} && sign_y == 0) ? y[BW_IN-2:0] :
//		(x == {BW_IN{1'b0}} && sign_y == 1) ? absy[BW_IN-2:0] :
//		(y == {BW_IN{1'b0}} && sign_x == 0) ? y[BW_IN-2:0] : absx[BW_IN-2:0];
//		
//assign newy = (sign_x == 0 && sign_y == 0) ? y[BW_IN-2:0] :
//		(sign_x == 1 && sign_y == 0) ? absx[BW_IN-2:0] :
//		(sign_x == 1 && sign_y == 1) ? absy[BW_IN-2:0] :
//		(sign_x == 0 && sign_y == 1) ? x[BW_IN-2:0] :
//		(x == {BW_IN{1'b0}} && sign_y == 0) ? x[BW_IN-2:0] :
//		(x == {BW_IN{1'b0}} && sign_y == 1) ? x[BW_IN-2:0] :
//		(y == {BW_IN{1'b0}} && sign_x == 0) ? y[BW_IN-2:0] : y[BW_IN-2:0];

assign index = (sign_x == 0 && sign_y == 0) ? 2'b00 :
		(sign_x == 1 && sign_y == 0) ? 2'b01 :
		(sign_x == 1 && sign_y == 1) ? 2'b10 : 2'b11;

assign newx = (sign_x == 0 && sign_y == 0) ? x[BW_IN-2:0] :
		(sign_x == 1 && sign_y == 0) ? y[BW_IN-2:0] :
		(sign_x == 1 && sign_y == 1) ? absx[BW_IN-2:0] : absy[BW_IN-2:0];
		
assign newy = (sign_x == 0 && sign_y == 0) ? y[BW_IN-2:0] :
		(sign_x == 1 && sign_y == 0) ? absx[BW_IN-2:0] :
		(sign_x == 1 && sign_y == 1) ? absy[BW_IN-2:0] : x[BW_IN-2:0];

// delay index 6 clocks

reg [1:0] index1, index2, index3, index4, index5, index6, index7;

// First stage
always @(posedge clk) begin
    if (rst) index1 <= 0;
    else if (ena) index1 <= index;
end
// ===========

// Second stage
always @(posedge clk) begin
    if (rst)  index2 <= 0;
    else if (ena) index2 <= index1;
end
// ============

// Third stage
always @(posedge clk) begin
    if (rst)  index3 <= 0;
    else if (ena) index3 <= index2;
end
// ============

// Fourth stage
always @(posedge clk) begin
    if (rst)  index4 <= 0;
    else if (ena) index4 <= index3;
end
// ============

// Fifth stage
always @(posedge clk) begin
    if (rst) index5 <= 0;
    else if (ena) index5 <= index4;
end
// ============

// Sixth stage
always @(posedge clk) begin
    if (rst) index6 <= 0;
    else if (ena) index6 <= index5;
end
//// ============
//
//// Seventh stage
always @(posedge clk) begin
    if (rst) index7 <= 0;
    else if (ena) index7 <= index6;
end
// ============

// fetch the newx and newy into Atan2 module

wire [BW_OUT-1:0] temp_cos;
wire [BW_OUT-1:0] temp_sin;

wire signed [BW_OUT-1:0] cosx;
wire signed [BW_OUT-1:0] sinx;

Atan2 #(.BW_OUT(BW_OUT), .BIT_WIDTH(BW_IN-1), .WIDTH_X(WIDTH_SHIFT)) Atan2_instance(.clk(clk), .rst(rst), .ena(ena), 
		.y(newy), .x(newx), .sin(temp_sin), .cos(temp_cos));

assign cosx = (index7 == 0) ? temp_cos : // first quadrant
	(index7 == 1) ? ~temp_sin + 1'b1 : // second quandrant
	(index7 == 2) ? ~temp_cos + 1'b1 : // third quandrant
	temp_sin; // fourth quadrant


assign sinx = (index7 == 0) ? temp_sin : // first quadrant
	(index7 == 1) ? temp_cos : // second quadrant
	(index7 == 2) ? ~temp_sin + 1'b1 : // third quadrant
	~temp_cos + 1'b1; // fourth quadrant


always @* begin
    cos = cosx;
    sin = sinx;
end


endmodule