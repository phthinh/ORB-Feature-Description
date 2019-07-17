module Rotation_AddSubVec(cosx, sinx, cosy, siny, x, y);

parameter BW_XCOS = 11; // [6 bit integer. BW_XCOS-6 bit fraction] -18 to 18
parameter BW_OUT = 6; // from -18 to 18 so 8 bits is enough

// format [5 interger bits inluding a signed bit. (BW_XCOS-5) bit fractions] [-18 to 18]
input [128*BW_XCOS-1:0] cosx;
input [128*BW_XCOS-1:0] sinx; // sinx
input [128*BW_XCOS-1:0] cosy; // cosy
input [128*BW_XCOS-1:0] siny; // siny

output [128*BW_OUT-1:0] x;
output [128*BW_OUT-1:0] y;


wire signed [BW_OUT-1:0] new_x [0:127]; // output after add and substract
wire signed [BW_OUT-1:0] new_y [0:127];
genvar i;
generate
   for(i=0; i<128; i=i+1) begin : AAA
	// format [6 interger bits inluding a signed bit. (BW_XCOS-6) bit fractions] [-18 to 18]
	Rotation_Add_Substract #(.BW_XCOS(BW_XCOS), .BW_OUT(BW_OUT)) 
	Rotation_AddSubstract_01(cosx[i*BW_XCOS +: BW_XCOS], 
									 sinx[i*BW_XCOS +: BW_XCOS],
									 cosy[i*BW_XCOS +: BW_XCOS], 
									 siny[i*BW_XCOS +: BW_XCOS], 
									 new_x[i], new_y[i]);
   end
endgenerate
//
genvar p;
generate
	for(p=0; p<128; p=p+1) begin : BBB
		 assign  x[p*BW_OUT +: BW_OUT] = new_x[p];
	    assign  y[p*BW_OUT +: BW_OUT] = new_y[p];
	end
endgenerate

endmodule


