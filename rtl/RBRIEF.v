	module RBRIEF(clk, rst, ena, isCorner,
	e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16, e17, e18, e19, e20, e21, e22, e23,
	e24, e25, e26, e27, e28, e29, e30, e31, e32, e33, e34, e35, e36, e37, descriptors, out_valid);


parameter WIDTH_PIXEL = 8;

// CENTROID PARAMETER
parameter WIDTH_OUT_CENTROID = 12; // max is approximately ~1m6, plus sign bit, but after optimization, it needs 10 bit only

// ===============================

// ANGLE PARAMETER
parameter WIDTH_OUT_ANGLE = 7; // we choose the width of cos/sin is 7 bits
parameter WIDTH_SHIFT = 11;

// ===============================

// ANGLE PARAMETER
parameter WIDTH_OUT_ROTATION = 3584; // form -18 to 18, multiply with 512

// ===============================

parameter WIDTH_OUT_GENERATOR = 256;
parameter WIDTH_1_ROW_WINDOW = WIDTH_PIXEL*37; // WIDTH OF 1 ROW OF BUFFER 37*8
parameter WIDTH_RX = 3584; // 6 * 512
parameter WIDTH_BUFFER = 4096; // 8 * 512
parameter WIDTH_EACH_RX_RY = 7;

input clk;
input rst;
input ena;

input [WIDTH_PIXEL-1:0] e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19,
			e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36,e37;

// when isCorner is 1, a column has been saved into Generator and Centroid as well. Because this isCorner will trigger
// the Angle, this isCorner must be delay for how many times equal as delay of Centroid block.
input isCorner;

output [WIDTH_OUT_GENERATOR-1:0] descriptors;
output out_valid;

// Centroid module
wire [WIDTH_OUT_CENTROID-1:0] m01;
wire [WIDTH_OUT_CENTROID-1:0] m10;
wire centroid_valid;
wire centroid_ena, centroid_corner;

wire isFull;
assign centroid_corner = isCorner & (~isFull);

Centroid_Controller Controller(clk, rst, ena, centroid_corner, centroid_ena); 

Centroid  #(.BW_OUT_OPTIMIZATION(WIDTH_OUT_CENTROID)) 
A_Centroid (clk, rst, centroid_ena, centroid_corner, e1, e2, e3, e4, e5, e6, e7, 
			e8, e9, e10, e11, e12, e13, e14, e15, e16, e17, e18, e19, e20, e21,
			e22, e23, e24, e25, e26, e27, e28, e29, e30, e31, e32,
			e33, e34, e35, e36, e37, m10, m01, centroid_valid);


// Angle module
wire [WIDTH_OUT_ANGLE-1:0] cos;
wire [WIDTH_OUT_ANGLE-1:0] sin;
wire angle_valid;
wire angle_ena;

assign angle_ena = centroid_valid;

Angle	 #(.BW_IN(WIDTH_OUT_CENTROID), .BW_OUT(WIDTH_OUT_ANGLE), .WIDTH_SHIFT(WIDTH_SHIFT)) 
B_Angle (clk, rst, ena, angle_ena, m10, m01, cos, sin, angle_valid);

// Rotation module
wire [WIDTH_OUT_ROTATION-1:0] rx;
wire [WIDTH_OUT_ROTATION-1:0] ry;

wire rotation_ena;
wire rotation_valid;

assign rotation_ena = angle_valid;

Rotation  #(.BW_TRIGONOMETRY(WIDTH_OUT_ANGLE))
C_Rotation (clk, rst, ena, rotation_ena, cos, sin, rx, ry, rotation_valid);


// Genarator module
 

Generator  #(.NUMBER_OF_DESCRIPTORS(WIDTH_OUT_GENERATOR), .WIDTH_PIXEL(WIDTH_PIXEL), .WIDTH_RX(WIDTH_RX),
		.WIDTH_IN(WIDTH_EACH_RX_RY))
D_Generator (clk, rst, ena, isCorner, rotation_valid, rx, ry, e1, e2, e3, e4, e5, e6, e7, e8, 
		e9, e10, e11, e12, e13, e14, e15, e16, e17, e18, e19, e20, e21, e22, e23, e24, e25, e26, e27, e28, 
		e29, e30, e31, e32, e33, e34, e35, e36, e37, descriptors, out_valid, isFull);
//

endmodule