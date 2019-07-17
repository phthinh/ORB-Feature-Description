//`timescale 1ns / 1ps

module Top_tb;

parameter WIDTH_PIXEL = 8;
parameter WIDTH_DESCRIPTORS = 256;
parameter WIDTH_BUFFER = 10952; // 1369 * 8 (1396 pixels, each pixel max is 255, so 8 bits)

reg clk;
reg clk_half;
reg rst;
reg ena;
reg isCorner;

reg [WIDTH_PIXEL-1:0] pixel;
wire [WIDTH_DESCRIPTORS-1:0] descriptors;
wire out_valid;

Top Top_instance(clk, rst, ena, isCorner, pixel, descriptors, out_valid);

integer f;

initial begin
#0 clk = 1;
   rst = 1;
#1 rst = 0;
   ena = 1;
end

initial begin
#0 isCorner = 0;
end


always begin
#1 clk = ~clk;
end


integer counter;
always @(posedge clk) begin
	if (rst) counter <= 1;
	else if (counter >= 650000) begin
		$fclose(f);
		$stop;
	end
	else counter <= counter+2;
end

// Write

`define NULL 0    


integer c;

initial begin
  f = $fopen("../../../../../data/fpga_tb_output.txt", "w");
  c = 0;
end



always @(posedge clk) begin
  if (out_valid == 1) begin
      c = c + 1;
	$fwrite(f, "%b \n", descriptors);
  end
end

// READ ISCORNER

reg [20-1:0] timeCorner;   

integer corner_file;
integer scan_corner;

initial begin
  corner_file = $fopen("../../../../../data/isCorner.txt", "r");
  if (corner_file == `NULL) begin
    $display("data_file handle was NULL");
    $finish;
  end
end

initial begin
  scan_corner = $fscanf(corner_file, "%d\n", timeCorner);
end
integer xx;
initial begin
xx = 0;
end
always @(negedge clk) begin
  if (timeCorner == counter) begin
	isCorner <= 1;
	xx <= xx + 1;
  end
  else if(counter == (timeCorner+2)) begin
	isCorner <= 0;
	scan_corner <= $fscanf(corner_file, "%d\n", timeCorner);
  end
end

// ======================

// READ PIXEL

reg [WIDTH_PIXEL-1:0] captured_data;  

integer data_file;
integer scan_file;

initial begin
  data_file = $fopen("../../../../../data/image.txt", "r");
  if (data_file == `NULL) begin
    $display("data_file handle was NULL");
    $finish;
  end
end



always @(posedge clk) begin
  scan_file = $fscanf(data_file, "%d\n", captured_data);
  if (!$feof(data_file)) begin
	pixel <= captured_data[WIDTH_PIXEL-1:0];
  end
end

// ======================

endmodule