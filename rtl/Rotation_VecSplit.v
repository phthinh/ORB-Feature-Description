module Rotation_VecSplit(clk, rst,  latch_ena, compute, in_cos_x, in_sin_x, in_cos_y, in_sin_y, 
			cosx_vec, sinx_vec, cosy_vec, siny_vec);

parameter BW_TRIGONOMETRY = 9; // [6 bit integer. BW_TRIGONOMETRY-6 bit fraction] -18 to 18

input clk;
input rst;
input latch_ena;
input compute;

input  [512*BW_TRIGONOMETRY-1:0] in_cos_x;
input  [512*BW_TRIGONOMETRY-1:0] in_sin_x;
input  [512*BW_TRIGONOMETRY-1:0] in_cos_y;
input  [512*BW_TRIGONOMETRY-1:0] in_sin_y;

output [128*BW_TRIGONOMETRY-1:0] cosx_vec;
output [128*BW_TRIGONOMETRY-1:0] sinx_vec;
output [128*BW_TRIGONOMETRY-1:0] cosy_vec;
output [128*BW_TRIGONOMETRY-1:0] siny_vec;

reg  [512*BW_TRIGONOMETRY-1:0]	cosx_reg;
reg  [512*BW_TRIGONOMETRY-1:0] 	sinx_reg;
reg  [512*BW_TRIGONOMETRY-1:0]	cosy_reg;
reg  [512*BW_TRIGONOMETRY-1:0]	siny_reg;

always @(posedge clk) begin
	if(rst) begin
		cosx_reg <= {(512*BW_TRIGONOMETRY){1'b0}};
		sinx_reg <= {(512*BW_TRIGONOMETRY){1'b0}};
		cosy_reg <= {(512*BW_TRIGONOMETRY){1'b0}};
		siny_reg <= {(512*BW_TRIGONOMETRY){1'b0}};
		end
	else if (latch_ena) begin
		cosx_reg <= in_cos_x;
		sinx_reg <= in_sin_x;
		cosy_reg <= in_cos_y;
		siny_reg <= in_sin_y;
		end
   else if (compute) begin
		cosx_reg <= {{(128*BW_TRIGONOMETRY){1'b0}}, cosx_reg[512*BW_TRIGONOMETRY-1:128*BW_TRIGONOMETRY]};
		sinx_reg <= {{(128*BW_TRIGONOMETRY){1'b0}}, sinx_reg[512*BW_TRIGONOMETRY-1:128*BW_TRIGONOMETRY]};
		cosy_reg <= {{(128*BW_TRIGONOMETRY){1'b0}}, cosy_reg[512*BW_TRIGONOMETRY-1:128*BW_TRIGONOMETRY]};
		siny_reg <= {{(128*BW_TRIGONOMETRY){1'b0}}, siny_reg[512*BW_TRIGONOMETRY-1:128*BW_TRIGONOMETRY]};
		end
end

assign cosx_vec = cosx_reg[128*BW_TRIGONOMETRY-1:0];
assign sinx_vec = sinx_reg[128*BW_TRIGONOMETRY-1:0];
assign cosy_vec = cosy_reg[128*BW_TRIGONOMETRY-1:0];
assign siny_vec = siny_reg[128*BW_TRIGONOMETRY-1:0];

endmodule
