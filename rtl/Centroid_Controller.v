module Centroid_Controller(clk, rst, ena, isCorner, enable_out);

input clk;
input rst;
input ena;

input isCorner;

output enable_out;

reg [6-1:0] counter;

always @(posedge clk) begin
    if (rst) counter <= 0;
    if (isCorner == 1) counter <= 1;
	 else if (counter && (counter <= 6'b101001)) counter <= counter + 1; // 41
	 else if (counter == 6'b101010) counter <= 0; // 42
end

assign enable_out = isCorner || (counter != 0);

endmodule