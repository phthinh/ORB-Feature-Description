module Atan2_Select(in, y, out);

parameter BW_INPUT = 16; // parameterize this outside this module

input [BW_INPUT-1:0] in;
input [BW_INPUT-1:0] y;

output out;

assign out = (y <= in);

endmodule
    