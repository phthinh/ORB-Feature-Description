module Generator(clk, rst, ena, isCorner, sample_valid, rx, ry, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, 
		c16, c17, c18, c19, c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, c30, c31, c32, c33, c34, c35, c36, c37, 
		out, out_valid, isFull);

parameter WIDTH_IN = 7; // from -18 to 18 so 6 bits is enough
parameter NUMBER_OF_DESCRIPTORS = 256;
parameter WIDTH_PIXEL = 8; // max is 255 so just need 8 bits
parameter WIDTH_RX = 3072;


input clk;
input rst;
input ena; // Because streamming, so it is always on.
input sample_valid; // This is pulse from Rotator block
input isCorner; // indicate corner is 18 columns advance, therefore, have to calculate

input [WIDTH_RX-1:0] rx;
input [WIDTH_RX-1:0] ry;

input [WIDTH_PIXEL-1:0] c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,
			c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31,c32,c33,c34,c35,c36,c37;


output reg [NUMBER_OF_DESCRIPTORS-1:0] out;
output reg out_valid;

wire ena1, ena2, ena3, ena4, sample_valid1, sample_valid2, sample_valid3, sample_valid4;
wire done1, done2, done3, done4;
wire isWorking1, isWorking2, isWorking3, isWorking4, isGenerating1, isGenerating2, isGenerating3, isGenerating4;

wire [NUMBER_OF_DESCRIPTORS-1:0] out1, out2, out3, out4;
output isFull;
wire isDrop;

Delay_D #(.WIDTH(1), .D(318), .B(10)) Delay_XXX(clk, rst, ena, isFull & isCorner, isDrop);

Generator_Controller AAA(clk, rst, isCorner, sample_valid, isWorking1, isGenerating1, isWorking2, isGenerating2,
			isWorking3, isGenerating3, isWorking4, isGenerating4, ena1, ena2, ena3, ena4,
			sample_valid1, sample_valid2, sample_valid3, sample_valid4, isFull);

PointDescriptor #(.BW_IN(WIDTH_IN), .LENGTH_IN(WIDTH_RX)) PointDescriptor1(clk, rst, ena1, sample_valid1, rx, ry, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, 
		c13, c14, c15, c16, c17, c18, c19, c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, c30, c31, 
		c32, c33, c34, c35, c36, c37, out1, isWorking1, isGenerating1, done1);

PointDescriptor #(.BW_IN(WIDTH_IN), .LENGTH_IN(WIDTH_RX)) PointDescriptor2(clk, rst, ena2, sample_valid2, rx, ry, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, 
		c13, c14, c15, c16, c17, c18, c19, c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, c30, c31, 
		c32, c33, c34, c35, c36, c37, out2, isWorking2, isGenerating2, done2);

PointDescriptor #(.BW_IN(WIDTH_IN), .LENGTH_IN(WIDTH_RX)) PointDescriptor3(clk, rst, ena3, sample_valid3, rx, ry, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, 
		c13, c14, c15, c16, c17, c18, c19, c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, c30, c31, 
		c32, c33, c34, c35, c36, c37, out3, isWorking3, isGenerating3, done3);

PointDescriptor #(.BW_IN(WIDTH_IN), .LENGTH_IN(WIDTH_RX)) PointDescriptor4(clk, rst, ena4, sample_valid4, rx, ry, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, 
		c13, c14, c15, c16, c17, c18, c19, c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, c30, c31, 
		c32, c33, c34, c35, c36, c37, out4, isWorking4, isGenerating4, done4);


always@(posedge clk) begin
    if(isDrop) out <= 256'd0;
    if(done1) begin
	out <= out1;
    end
    else if (done2) begin
	out <= out2;
    end
    else if (done3) begin
	out <= out3;
    end
    else if (done4) begin
	out <= out4;
    end
end

always @(posedge clk) begin
    if (rst) out_valid <= 0;
    else if (isDrop) out_valid <= 1;
    else out_valid <= done1 | done2 | done3 | done4;
end

endmodule