
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:22:04 04/15/2012 
// Design Name: 
// Module Name:    Delay64 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Delay_D #(parameter WIDTH = 8, D = 593, B = 10)(
	input  clk, rst, ena,
	input  [WIDTH-1:0] dat_in,	
	output [WIDTH-1:0] dat_out
);
reg [WIDTH-1:0] dat_ram [D-1:0];
reg [B-1:0]  adr_cnt;
reg dat_val;


always@ (posedge clk)begin
	if(rst) begin
		adr_cnt <= 10'b0;
		dat_ram[adr_cnt] <= {WIDTH{1'b0}};
   end
   else if (ena) begin
		dat_ram[adr_cnt] <= dat_in;
	
		if (adr_cnt == D-1) begin // 592 because we have 593 register
			adr_cnt <= {B{1'b0}};
			end
		else begin
			adr_cnt <= adr_cnt + 1'b1;
			end
    end		
end

always@ (posedge clk)begin
    if(rst) dat_val <= 1'b0;
    else if (adr_cnt == D-1) dat_val <= 1'b1;
end

assign 	  dat_out  = (dat_val)? dat_ram[adr_cnt]: {WIDTH{1'b0}};

endmodule
