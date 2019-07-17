module Rotation(clk, rst, ena_clk, ena, cos, sin, rx, ry, valid);

parameter BW_XY_SAMPLE = 5;
parameter BW_TRIGONOMETRY = 11; // [1 bit integer. BW_TRIGONOMETRY-1 bit fraction] -0.9 to 0.9, after optimization is 11
parameter BW_OUT = 7; // from -18 to 18 so 6 bits is enough, add 1 fraction bits
parameter LENGTH_OUT = 3584; // 7 * 512
parameter BW_XCOS = BW_XY_SAMPLE + BW_TRIGONOMETRY -1;

input signed [BW_TRIGONOMETRY-1:0] sin; // format [1 signed bit. (BW_TRIGONOMETRY-1) bits fractions] [-0.9 to 0.9]
input signed [BW_TRIGONOMETRY-1:0] cos; // format [1 signed bit. (BW_TRIGONOMETRY-1) bits fractions] [-0.9 to 0.9]

input clk;
input rst;
input ena; // This signal from Centroid -> Angle, indicate a corner.
input ena_clk; // enable global clock
 
// because we want to parallel compute new x, so output needs to contain

output [LENGTH_OUT-1:0] rx; // 512 register of BW_OUT bits
output [LENGTH_OUT-1:0] ry; // 512 register of BW_OUT bits
output reg valid;

reg signed [BW_TRIGONOMETRY-1:0] sin_i; // format [1 signed bit. (BW_TRIGONOMETRY-1) bits fractions] [-1 to 1]
reg signed [BW_TRIGONOMETRY-1:0] cos_i; // format [1 signed bit. (BW_TRIGONOMETRY-1) bits fractions] [-1 to 1]


reg [3:0] ena_i;
always @(posedge clk) begin
	if (rst) 	ena_i <= 1'b0;
	else 		ena_i <= {ena_i[2:0],ena};
end
//
	
//=========================== 1st stage at input ===============================================	
always @(posedge clk) begin
	if (rst) begin
		sin_i <= {BW_TRIGONOMETRY{1'b0}};
		cos_i <= {BW_TRIGONOMETRY{1'b0}};
		end
	else if (ena && (~ena_i[0])) begin
		sin_i <= sin;
		cos_i <= cos;
		end		
end
//==============================================================================================

// format [5 interger bits inluding a signed bit. (BW_TRIGONOMETRY-1) bits fractions] [-18 to 18]
// 5 bit integer due to -13 <= sample <= 13
wire signed [BW_XCOS-1:0] 	 cos0,  cos1,  cos2,  cos3,  cos4,  cos5,  cos6,  cos7,  cos8, cos9, 
					cos10, cos11, cos12, cos13, cos14, cos15, cos16, cos17, cos18;

// format [5 interger bits inluding a signed bit. (BW_TRIGONOMETRY-1) bit fractions] [-18 to 18]
wire signed [BW_XCOS-1:0] 	 sin0, sin1,  sin2,  sin3,  sin4,  sin5,  sin6,  sin7,  sin8, sin9,
					sin10,sin11, sin12, sin13, sin14, sin15, sin16, sin17, sin18;

//============== 2th and 3th stages of Rotation multiplier (The latency of 2 clock) =============
Rotation_Multiplier #(.BW_XCOS(BW_XCOS), .BW_TRIGONOMETRY(BW_TRIGONOMETRY)) 
		S1_Rotation_Multiplier_sin(clk, rst, ena_clk, sin_i, sin0, sin1, sin2, sin3, sin4, sin5, sin6, 
		sin7, sin8, sin9, sin10, sin11, sin12, sin13, sin14, sin15, sin16, sin17, sin18);

Rotation_Multiplier #(.BW_XCOS(BW_XCOS), .BW_TRIGONOMETRY(BW_TRIGONOMETRY)) 
		S1_Rotation_Multiplier_cos(clk, rst, ena_clk, cos_i, cos0, cos1, cos2, cos3, cos4, cos5, cos6,
		cos7, cos8, cos9, cos10, cos11, cos12, cos13, cos14, cos15, cos16, cos17, cos18);
//===============================================================================================

wire [512*BW_XCOS-1:0] out_cos_x, out_sin_x; //5.(BW_TRIGONOMETRY-1)
wire [512*BW_XCOS-1:0] out_cos_y, out_sin_y;

	
	MultX_connect #(.BW_XCOS(BW_XCOS)) S2_MultX_connect_ins_cos(cos0, cos1, 
	cos2, cos3, cos4, cos5, cos6, cos7, cos8, cos9, cos10, cos11, cos12, cos13, cos14, cos15, cos16, cos17, cos18, out_cos_x);

	MultX_connect #(.BW_XCOS(BW_XCOS)) S2_MultX_connect_ins_sin(sin0, sin1, 
	sin2, sin3, sin4, sin5, sin6, sin7, sin8, sin9, sin10, sin11, sin12, sin13, sin14, sin15, sin16, sin17, sin18, out_sin_x);

	MultY_connect #(.BW_XCOS(BW_XCOS)) S2_MultY_connect_ins_cos(cos0, cos1, 
	cos2, cos3, cos4, cos5, cos6, cos7, cos8, cos9, cos10, cos11, cos12, cos13, cos14, cos15, cos16, cos17, cos18, out_cos_y);

	MultY_connect #(.BW_XCOS(BW_XCOS)) S2_MultY_connect_ins_sin(sin0, sin1, 
	sin2, sin3, sin4, sin5, sin6, sin7, sin8, sin9, sin10, sin11, sin12, sin13, sin14, sin15, sin16, sin17, sin18, out_sin_y);
//


//counter enable is actived after 3 clocks after enable signal is actived (1 stage at input and Rotation_Multiplier has two stages)


//start counting from 0 at 3nd stage ==============
reg [1:0]  cnt;
reg 		  cnt_ena;

wire cntiszero = (cnt == 2'b00);

always @(posedge clk) begin
	if (rst) 									cnt_ena <= 1'b0;
	else if ((~ena_i[2]) && ena_i[1])	cnt_ena <= 1'b1;
	else if (cnt == 2'b11)					cnt_ena <= 1'b0;
end

always @(posedge clk) begin
	if (rst) 				cnt <= 2'b00;
	else if  (cnt_ena)	cnt <= cnt + 1'b1;
	//else 						cnt <= 2'b00;
end
//


//start shifting and computing at 4nd stage ==============
reg compute;
always @(posedge clk) begin
	if (rst) 	compute <= 1'b0;
	else	 		compute <= cnt_ena;	
end
//




wire [128*BW_XCOS-1:0] cosx_vec;
wire [128*BW_XCOS-1:0] sinx_vec;
wire [128*BW_XCOS-1:0] cosy_vec;
wire [128*BW_XCOS-1:0] siny_vec;

////===================== 4th stage at Vector split into 4 parts using shift register===========	
//wire latch_ena = (~ena_i[3]) && ena_i[2];
//Rotation_VecSplit   #(.BW_TRIGONOMETRY(BW_TRIGONOMETRY))
//S3_Rotation_VecSplit_01 ( clk, rst,  latch_ena, compute,
//			out_cos_x, out_sin_x,  out_cos_y, out_sin_y,
//			cosx_vec,  sinx_vec,   cosy_vec,  siny_vec);
////============================================================================================	

//======= 4th stage at Vector split into 4 parts using MUX repecting to cnt value ============	
Rotation_VecSplit_Mux   #(.BW_XCOS(BW_XCOS))
S3_Rotation_VecSplit_01 ( clk, rst, cnt, cnt_ena,
			out_cos_x, out_sin_x,  out_cos_y, out_sin_y,
			cosx_vec,  sinx_vec,   cosy_vec,  siny_vec);
//============================================================================================	

wire [128*BW_OUT-1:0] new_x;
wire [128*BW_OUT-1:0] new_y;

Rotation_AddSubVec 	#(.BW_XCOS(BW_XCOS), .BW_OUT(BW_OUT)) 
S4_Rotation_AddSubVec_01 (cosx_vec, sinx_vec, cosy_vec, siny_vec, new_x, new_y);
//

//===================== 5th stage at shift register of output concatnate 4 parts =============
reg [LENGTH_OUT-1:0] rx_reg; // 512 register of BW_OUT bits
reg [LENGTH_OUT-1:0] ry_reg; // 512 register of BW_OUT bits
always @(posedge clk) begin
	if(rst) begin
		rx_reg <= {LENGTH_OUT{1'b0}};
		ry_reg <= {LENGTH_OUT{1'b0}};
		end
   else if (compute) begin
		rx_reg <= {new_x, rx_reg[512*BW_OUT-1:128*BW_OUT]};
		ry_reg <= {new_y, ry_reg[512*BW_OUT-1:128*BW_OUT]};
    end
end
//============================================================================================	

always @(posedge clk) begin
	if (rst) 								valid <= 1'b0;
	else if (compute & cntiszero)	valid <= 1'b1;
	else 										valid <= 1'b0;
end
//

assign rx = rx_reg;
assign ry = ry_reg;

// TEST
//wire [6-1:0] vx [0:511];
//wire [6-1:0] vy [0:511];
//
//genvar mm;
//generate
//    for(mm = 0; mm<512;mm=mm+1) begin : MMM
//	assign vx[mm] = rx[mm*BW_OUT +: BW_OUT];
//	assign vy[mm] = ry[mm*BW_OUT +: BW_OUT];
//    end
//endgenerate


endmodule
