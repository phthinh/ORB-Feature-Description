module Angle_LUT_Cos_Sin(index, out_sin, out_cos);

parameter BW_IN = 5;
parameter BW_OUT = 11;
parameter TABLE_WIDTH = 12;

input [BW_IN-1:0] index;

output [BW_OUT-1:0] out_sin;
output [BW_OUT-1:0] out_cos;

// table for cos, 12 bits, [1 bit integer . 14 bit fractions], we approximate 1 ~ 0.9999999

wire [TABLE_WIDTH-1:0] cos_table [24:0];
// theta_vec = pi/2 * [0:1:N-1]/N + pi/(4*N);
assign cos_table[00] = 12'b011111111110; // cos(0) = 1;
assign cos_table[01] = 12'b011111110110; // cos(pi/2*1/25) = 0.998026728428272
assign cos_table[02] = 12'b011111100110; // cos(pi/2*2/25) = 0.992114701314478
assign cos_table[03] = 12'b011111001110; // cos(pi/2*3/25) = 0.982287250728689
assign cos_table[04] = 12'b011110101110; // cos(pi/2*4/25) = 0.960293685676943
assign cos_table[05] = 12'b011110000110; // cos(pi/2*5/25) = 0.940880768954226
assign cos_table[06] = 12'b011101010111; // cos(pi/2*6/25) = 0.917754625683981
assign cos_table[07] = 12'b011100100000; // cos(pi/2*7/25) = 0.904827052466020
assign cos_table[08] = 12'b011011100010; // cos(pi/2*8/25) = 0.860742027003944
assign cos_table[09] = 12'b011010011101; // cos(pi/2*9/25) = 0.827080574274562
assign cos_table[10] = 12'b011001010010; // cos(pi/2*10/25) = 0.790155012375690
assign cos_table[11] = 12'b011000000000; // cos(pi/2*11/25) = 0.750111069630460
assign cos_table[12] = 12'b010110101000; // cos(pi/2*12/25) = 0.707106781186548
assign cos_table[13] = 12'b010101001010; // cos(pi/2*13/25) = 0.661311865323652
assign cos_table[14] = 12'b010011100111; // cos(pi/2*14/25) = 0.612907053652977
assign cos_table[15] = 12'b010001111111; // cos(pi/2*15/25) = 0.562083377852131
assign cos_table[16] = 12'b010000010010; // cos(pi/2*16/25) = 0.509041415750371
assign cos_table[17] = 12'b001110100001; // cos(pi/2*17/25) = 0.453990499739547
assign cos_table[18] = 12'b001100101101; // cos(pi/2*18/25) = 0.397147890634781
assign cos_table[19] = 12'b001010110101; // cos(pi/2*19/25) = 0.338737920245292
assign cos_table[20] = 12'b001000111011; // cos(pi/2*20/25) = 0.278991106039229
assign cos_table[21] = 12'b000110111110; // cos(pi/2*21/25) = 0.218143241396542
assign cos_table[22] = 12'b000101000000; // cos(pi/2*22/25) = 0.156434465040231
assign cos_table[23] = 12'b000011000000; // cos(pi/2*23/25) = 0.094108313318515
assign cos_table[24] = 12'b000001000000; // cos(pi/2*24/25) = 0.031410759078128

// table for sin, 16 bits, [1 bit integer . 15 bit fractions]

wire [TABLE_WIDTH-1:0] sin_table [24:0];

assign sin_table[00] = 12'b000001000000; // sin(0) = 0.031410759078128
assign sin_table[01] = 12'b000011000000; // sin(pi/2*1/25) = 0.094108313318514
assign sin_table[02] = 12'b000101000000; // sin(pi/2*2/25) = 0.156434465040231
assign sin_table[03] = 12'b000110111110; // sin(pi/2*3/25) = 0.218143241396543
assign sin_table[04] = 12'b001000111011; // sin(pi/2*4/25) = 0.278991106039229
assign sin_table[05] = 12'b001010110101; // sin(pi/2*5/25) = 0.338737920245291
assign sin_table[06] = 12'b001100101101; // sin(pi/2*6/25) = 0.397147890634781
assign sin_table[07] = 12'b001110100001; // sin(pi/2*7/25) = 0.425779291565073
assign sin_table[08] = 12'b010000010010; // sin(pi/2*8/25) = 0.509041415750371
assign sin_table[09] = 12'b010001111111; // sin(pi/2*9/25) = 0.562083377852131
assign sin_table[10] = 12'b010011100111; // sin(pi/2*10/25) = 0.612907053652977
assign sin_table[11] = 12'b010101001010; // sin(pi/2*11/25) = 0.661311865323652
assign sin_table[12] = 12'b010110101000; // sin(pi/2*12/25) = 0.707106781186548
assign sin_table[13] = 12'b011000000000; // sin(pi/2*13/25) = 0.750111069630460
assign sin_table[14] = 12'b011001010010; // sin(pi/2*14/25) = 0.790155012375690
assign sin_table[15] = 12'b011010011101; // sin(pi/2*15/25) = 0.827080574274562
assign sin_table[16] = 12'b011011100010; // sin(pi/2*16/25) = 0.860742027003944
assign sin_table[17] = 12'b011100100000; // sin(pi/2*17/25) = 0.891006524188368
assign sin_table[18] = 12'b011101010111; // sin(pi/2*18/25) = 0.917754625683981
assign sin_table[19] = 12'b011110000110; // sin(pi/2*19/25) = 0.940880768954226
assign sin_table[20] = 12'b011110101110; // sin(pi/2*20/25) = 0.960293685676943
assign sin_table[21] = 12'b011111001110; // sin(pi/2*21/25) = 0.975916761938747
assign sin_table[22] = 12'b011111100110; // sin(pi/2*22/25) = 0.987688340595138
assign sin_table[23] = 12'b011111110110; // sin(pi/2*23/25) = 0.995561964603080
assign sin_table[24] = 12'b011111111110; // sin(pi/2*24/25) = 0.999506560365732

// adjust 32 bit to parameter BW_OUT
wire [TABLE_WIDTH-1:0] cos;
wire [TABLE_WIDTH-1:0] sin;

assign sin = sin_table[index];
assign cos = cos_table[index];

assign out_cos = cos[TABLE_WIDTH-1:TABLE_WIDTH-BW_OUT];
assign out_sin = sin[TABLE_WIDTH-1:TABLE_WIDTH-BW_OUT];

endmodule