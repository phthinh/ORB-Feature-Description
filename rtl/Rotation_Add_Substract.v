module Rotation_Add_Substract(x11, x12,y11, y12, out_x, out_y);

parameter BW_XCOS = 9; // [5 bit integer. BW_XCOS-5 bit fraction] -18 to 18
parameter BW_OUT = 6; // from -18 to 18 so 8 bits is enough

// format [6 interger bits inluding a signed bit. (BW_XCOS-6) bit fractions] [-18 to 18]
input signed [BW_XCOS-1:0] x11; // cosx
input signed [BW_XCOS-1:0] x12; // sinx
input signed [BW_XCOS-1:0] y11; // cosy
input signed [BW_XCOS-1:0] y12; // siny

output signed [BW_OUT-1:0] out_x;
output signed [BW_OUT-1:0] out_y;

wire signed [BW_OUT-1:0] x;
wire signed [BW_OUT-1:0] y;

wire signed [BW_XCOS:0] x_temp; // cosx - siny
wire signed [BW_XCOS:0] y_temp; // sinx + cosy

assign x_temp = x11 - y12;
assign y_temp = x12 + y11;


assign x = x_temp[BW_XCOS:BW_XCOS-6]; 
assign y = y_temp[BW_XCOS:BW_XCOS-6]; 

assign out_x = x;
assign out_y = y;

endmodule


