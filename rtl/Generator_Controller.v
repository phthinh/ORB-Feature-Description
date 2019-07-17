module Generator_Controller(clk, rst, isCorner, sample_valid, isWorking1, isGenerating1, isWorking2, isGenerating2,
			isWorking3, isGenerating3, isWorking4, isGenerating4, ena1, ena2, ena3, ena4,
			sample_valid1, sample_valid2, sample_valid3, sample_valid4, isFull);

input isCorner;
input sample_valid;
input clk, rst;

input isWorking1, isGenerating1, isWorking2, isGenerating2, isWorking3, isGenerating3, isWorking4, isGenerating4;
output ena1, ena2, ena3, ena4;
output sample_valid1, sample_valid2, sample_valid3, sample_valid4;
output isFull;

assign ena1 = isCorner & (~isWorking1);
assign ena2 = isCorner & isWorking1 & (~isWorking2);
assign ena3 = isCorner & isWorking2 & isWorking1 & (~isWorking3);
assign ena4 = isCorner & isWorking3 & isWorking2 & isWorking1 & (~isWorking4);


assign isFull = isWorking1 & isWorking2 & isWorking3 & isWorking4;

reg [2:0] x [0:3];
reg [1:0] c_corner;
reg [1:0] c_sample;

assign sample_valid1 = sample_valid & (x[c_sample] == 1);
assign sample_valid2 = sample_valid & (x[c_sample] == 2);
assign sample_valid3 = sample_valid & (x[c_sample] == 3);
assign sample_valid4 = sample_valid & (x[c_sample] == 4);

always @(posedge clk) begin
    if (rst) c_corner <= 0;
    else if (ena1 | ena2 | ena3 | ena4) c_corner <= c_corner + 1;
end

always @(posedge clk) begin
    if (rst) x[c_corner] <= 0;	
    else if (ena1) x[c_corner] <= 1;
    else if (ena2) x[c_corner] <= 2;
    else if (ena3) x[c_corner] <= 3;
    else if (ena4) x[c_corner] <= 4;
end

always @(posedge clk) begin
    if (rst) c_sample <= 0;
    else if (sample_valid) c_sample <= c_sample + 1;
end


endmodule