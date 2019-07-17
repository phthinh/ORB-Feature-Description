

module Top(clk, rst, ena, isCorner, pixel, descriptors, out_valid);

parameter WIDTH_PIXEL = 8;
parameter WIDTH_DESCRIPTORS = 256;
parameter WIDTH_RX = 3072; // 6 * 512
parameter WIDTH_BUFFER = 4096; // 8 * 512

parameter DELAY = 11504; // it is actually 11502, we plus 2 to get 11504, because each pixel
// get after the first register, and we add 0 in testbench to simulate the latency.
parameter WIDTH_DELAY_ADDRESS = 14;

input clk;
input rst;
input ena;
input isCorner;

input [WIDTH_PIXEL-1:0] pixel;
output [WIDTH_DESCRIPTORS-1:0] descriptors;
output out_valid;


wire [WIDTH_PIXEL-1:0] e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11,e12,e13,e14,e15,e16,e17,e18,e19,
			e20,e21,e22,e23,e24,e25,e26,e27,e28,e29,e30,e31,e32,e33,e34,e35,e36,e37;


wire delayCorner;
// RowBuffer block

RowBuffer RowBuffer_instance(clk, rst, ena, pixel, 
	e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16, e17, e18, e19, e20, e21, e22, e23,
	e24, e25, e26, e27, e28, e29, e30, e31, e32, e33, e34, e35, e36, e37);

// Delay isCorner from Harris
Delay_Corner_Signal #(.DELAY(DELAY), .WIDTH_DELAY_ADDRESS(WIDTH_DELAY_ADDRESS)) Delay_Corner_Signal1(clk, rst, ena, isCorner, delayCorner);

// BRIEF block

RBRIEF RBIEF(clk, rst, ena, delayCorner,
	e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16, e17, e18, e19, e20, e21, e22, e23,
	e24, e25, e26, e27, e28, e29, e30, e31, e32, e33, e34, e35, e36, e37, descriptors, out_valid);

endmodule



