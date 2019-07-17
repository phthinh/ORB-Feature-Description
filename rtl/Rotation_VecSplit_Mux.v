module Rotation_VecSplit_Mux(clk, rst,  cnt, cnt_ena, 
										in_cos_x, in_sin_x, in_cos_y, in_sin_y, 
										cosx_vec, sinx_vec, cosy_vec, siny_vec);

parameter BW_XCOS = 10; // [5 bit integer. BW_XCOS-5 bit fraction] -18 to 18

input 		clk;
input 		rst;
input [1:0] cnt;
input 		cnt_ena;

input  [512*BW_XCOS-1:0] in_cos_x;
input  [512*BW_XCOS-1:0] in_sin_x;
input  [512*BW_XCOS-1:0] in_cos_y;
input  [512*BW_XCOS-1:0] in_sin_y;

output reg [128*BW_XCOS-1:0] cosx_vec;
output reg [128*BW_XCOS-1:0] sinx_vec;
output reg [128*BW_XCOS-1:0] cosy_vec;
output reg [128*BW_XCOS-1:0] siny_vec;

always @(posedge clk) begin
	if (rst)	begin
						cosx_vec <= {128*BW_XCOS{1'b0}};
						sinx_vec <= {128*BW_XCOS{1'b0}};
						cosy_vec <= {128*BW_XCOS{1'b0}};
						siny_vec <= {128*BW_XCOS{1'b0}};
				end
	else if (cnt_ena) begin
		case (cnt)
			2'b00 : begin
						cosx_vec <= in_cos_x[128*BW_XCOS-1:0];
						sinx_vec <= in_sin_x[128*BW_XCOS-1:0];
						cosy_vec <= in_cos_y[128*BW_XCOS-1:0];
						siny_vec <= in_sin_y[128*BW_XCOS-1:0];
					  end
			2'b01	: begin
						cosx_vec <= in_cos_x[256*BW_XCOS-1:128*BW_XCOS];
						sinx_vec <= in_sin_x[256*BW_XCOS-1:128*BW_XCOS];
						cosy_vec <= in_cos_y[256*BW_XCOS-1:128*BW_XCOS];
						siny_vec <= in_sin_y[256*BW_XCOS-1:128*BW_XCOS];
					end
			2'b10 : begin
						cosx_vec <= in_cos_x[384*BW_XCOS-1:256*BW_XCOS];
						sinx_vec <= in_sin_x[384*BW_XCOS-1:256*BW_XCOS];
						cosy_vec <= in_cos_y[384*BW_XCOS-1:256*BW_XCOS];
						siny_vec <= in_sin_y[384*BW_XCOS-1:256*BW_XCOS];
				  end
			2'b11 : begin
						cosx_vec <= in_cos_x[512*BW_XCOS-1:384*BW_XCOS];
						sinx_vec <= in_sin_x[512*BW_XCOS-1:384*BW_XCOS];
						cosy_vec <= in_cos_y[512*BW_XCOS-1:384*BW_XCOS];
						siny_vec <= in_sin_y[512*BW_XCOS-1:384*BW_XCOS];
				  end
		endcase
	end
end
//



endmodule
