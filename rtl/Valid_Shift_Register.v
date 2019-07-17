module Valid_Shift_Register(clk, rst, dat_in, dat_out);

parameter D = 41;
parameter B = 6;

input clk;
input rst;
input dat_in;

output dat_out;

reg [B-1:0] adr_cnt;
reg [D-1:0] dat_ram;
reg dat_val;

always@ (posedge clk)begin
    if(rst) begin
	adr_cnt <= {B{1'b0}};
	dat_ram[adr_cnt] <= 1'b0;
    end
   else begin
	dat_ram[adr_cnt] <= dat_in;
	if (adr_cnt == D-1) begin 
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

assign dat_out  = (dat_val)? dat_ram[adr_cnt]: 1'b0;

endmodule