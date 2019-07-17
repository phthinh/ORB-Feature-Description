module PointDescriptor(clk, rst, ena, sample_valid, rx, ry, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, 
		c16, c17, c18, c19, c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, c30, c31, c32, c33, c34, c35, c36, c37, 
		out, isWorking, isGenerating, done);

parameter BW_IN = 6; // from -18 to 18 so 6 bits is enough
parameter NUMBER_OF_POINTS = 512;
parameter NUMBER_OF_DESCRIPTORS = 256;
parameter WIDTH_PIXEL = 8; // max is 255 so just need 8 bits
parameter LENGTH_IN = 3072;

input [LENGTH_IN-1:0] rx;
input [LENGTH_IN-1:0] ry;

input clk;
input rst;
input ena; // a pulse to indicate this is corner, therefore receive 37 columns in 37 clks and calculate
input sample_valid; // This ena from rotation, which trigger to start calculate descriptors. After receiving 37x37,
		// it stops accepting, wait for sample_valid = 1, and then calculate descriptors.

input [WIDTH_PIXEL-1:0] c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,
			c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31,c32,c33,c34,c35,c36,c37;

output [NUMBER_OF_DESCRIPTORS-1:0] out;
output reg isWorking;
output wire isGenerating;

reg [6-1:0] counter_37; 
reg [8-1:0] counter_256;

output reg done;

// isWorking announce that if it is 1, this Generator is working, else, it wants to accept 37 columns
always@(posedge clk) begin
    if(rst) 			isWorking <= 0;
    else if(ena == 1)   	isWorking <= 1;
    else if(counter_256 == 255) isWorking <= 0;
end

// counter_37 is address counter to fetch c1,...,37 into 37 rows corresponding the number of counter_37
// in the second compare, we add counter_37 to prevent calculate descriptors when any sample_valid
// appear before finishing fetching 37 rows
always @(posedge clk) begin
    if (rst) begin
	counter_37 <= 6'b000000;
    end
    else if (ena == 1 && isWorking == 0) begin
	counter_37 <= counter_37 + 1'b1;
    end
    else if(isWorking == 1 && counter_37 != 37) begin
	counter_37 <= counter_37 + 1'b1;
    end
    else if(counter_256 == 255) begin
	counter_37 <= 0;
    end
end
// create 37 rows buffers to make a 37x37 window ==========================================
reg [WIDTH_PIXEL-1:0] row1 [0:36];
reg [WIDTH_PIXEL-1:0] row2 [0:36];
reg [WIDTH_PIXEL-1:0] row3 [0:36];
reg [WIDTH_PIXEL-1:0] row4 [0:36];
reg [WIDTH_PIXEL-1:0] row5 [0:36];
reg [WIDTH_PIXEL-1:0] row6 [0:36];
reg [WIDTH_PIXEL-1:0] row7 [0:36];
reg [WIDTH_PIXEL-1:0] row8 [0:36];
reg [WIDTH_PIXEL-1:0] row9 [0:36];
reg [WIDTH_PIXEL-1:0] row10 [0:36];
reg [WIDTH_PIXEL-1:0] row11 [0:36];
reg [WIDTH_PIXEL-1:0] row12 [0:36];
reg [WIDTH_PIXEL-1:0] row13 [0:36];
reg [WIDTH_PIXEL-1:0] row14 [0:36];
reg [WIDTH_PIXEL-1:0] row15 [0:36];
reg [WIDTH_PIXEL-1:0] row16 [0:36];
reg [WIDTH_PIXEL-1:0] row17 [0:36];
reg [WIDTH_PIXEL-1:0] row18 [0:36];
reg [WIDTH_PIXEL-1:0] row19 [0:36];
reg [WIDTH_PIXEL-1:0] row20 [0:36];
reg [WIDTH_PIXEL-1:0] row21 [0:36];
reg [WIDTH_PIXEL-1:0] row22 [0:36];
reg [WIDTH_PIXEL-1:0] row23 [0:36];
reg [WIDTH_PIXEL-1:0] row24 [0:36];
reg [WIDTH_PIXEL-1:0] row25 [0:36];
reg [WIDTH_PIXEL-1:0] row26 [0:36];
reg [WIDTH_PIXEL-1:0] row27 [0:36];
reg [WIDTH_PIXEL-1:0] row28 [0:36];
reg [WIDTH_PIXEL-1:0] row29 [0:36];
reg [WIDTH_PIXEL-1:0] row30 [0:36];
reg [WIDTH_PIXEL-1:0] row31 [0:36];
reg [WIDTH_PIXEL-1:0] row32 [0:36];
reg [WIDTH_PIXEL-1:0] row33 [0:36];
reg [WIDTH_PIXEL-1:0] row34 [0:36];
reg [WIDTH_PIXEL-1:0] row35 [0:36];
reg [WIDTH_PIXEL-1:0] row36 [0:36];
reg [WIDTH_PIXEL-1:0] row37 [0:36];

always @(posedge clk) begin
   if(counter_37 != 6'b100101) begin
	row1[counter_37] <= c1;
	row2[counter_37] <= c2;
	row3[counter_37] <= c3;
	row4[counter_37] <= c4;
	row5[counter_37] <= c5;
	row6[counter_37] <= c6;
	row7[counter_37] <= c7;
	row8[counter_37] <= c8;
	row9[counter_37] <= c9;
	row10[counter_37] <= c10;
	row11[counter_37] <= c11;
	row12[counter_37] <= c12;
	row13[counter_37] <= c13;
	row14[counter_37] <= c14;
	row15[counter_37] <= c15;
	row16[counter_37] <= c16;
	row17[counter_37] <= c17;
	row18[counter_37] <= c18;
	row19[counter_37] <= c19;
	row20[counter_37] <= c20;
	row21[counter_37] <= c21;
	row22[counter_37] <= c22;
	row23[counter_37] <= c23;
	row24[counter_37] <= c24;
	row25[counter_37] <= c25;
	row26[counter_37] <= c26;
	row27[counter_37] <= c27;
	row28[counter_37] <= c28;
	row29[counter_37] <= c29;
	row30[counter_37] <= c30;
	row31[counter_37] <= c31;
	row32[counter_37] <= c32;
	row33[counter_37] <= c33;
	row34[counter_37] <= c34;
	row35[counter_37] <= c35;
	row36[counter_37] <= c36;
	row37[counter_37] <= c37;
    end
end
// =========================================================================================

reg [LENGTH_IN-1:0] X_vect;
reg [LENGTH_IN-1:0] Y_vect;

// First stage: latch and shift samples =======================================================

always @(posedge clk) begin // keep the rx and ry when starting rotation
    if (rst) begin
	X_vect <= {(LENGTH_IN){1'b0}};
	Y_vect <= {(LENGTH_IN){1'b0}};
    end
    else if(counter_256 == 0 && sample_valid == 1) begin
    	X_vect <= rx;
    	Y_vect <= ry;
    end
    else if (counter_256 != 0) begin
	X_vect <= {14'b0, X_vect[LENGTH_IN-1:2*BW_IN]};
	Y_vect <= {14'b0, Y_vect[LENGTH_IN-1:2*BW_IN]};
    end
end

reg sample_valid_pp;
always @(posedge clk) begin
    if (rst) begin
	sample_valid_pp <= 0;
    end
    else if (isWorking) begin// ADD CHECKING ISWORKING
	sample_valid_pp <= sample_valid;
    end
end
// ==========================================================================================

// First stage
reg sample_shift;
always @(posedge clk) begin
    if (rst) 			 	sample_shift <= 0;
    else if (sample_valid && isWorking) sample_shift <= 1;
    else if (counter_256 == 255) 	sample_shift <= 0;
    
end
assign isGenerating = sample_shift;
// ===============================

// Second stage
reg sample_shift_pp1;
always @(posedge clk) begin
    if (rst) 	sample_shift_pp1 <= 0;
    else	sample_shift_pp1 <= sample_shift;
end
//================================

// Third stage
reg sample_shift_pp2;
always @(posedge clk) begin
    if (rst) 	sample_shift_pp2 <= 0;
    else	sample_shift_pp2 <= sample_shift_pp1;
end
//================================

// Fourth stage
reg sample_shift_pp3;
always @(posedge clk) begin
    if (rst) 	sample_shift_pp3 <= 0;
    else	sample_shift_pp3 <= sample_shift_pp2;
end
//================================

// fifth stage
reg generating_shift;
always @(posedge clk) begin
    if (rst) 	generating_shift <= 0;
    else	generating_shift <= sample_shift_pp3;
end

//================================


always @(posedge clk) begin
    if (rst) begin
	counter_256 <= 0;
    end
    else if(sample_valid_pp == 1 && counter_256 == 0 && counter_37 == 37) begin
	counter_256 <= counter_256 + 1'b1;
    end
    else if(counter_256 != 0) begin
	counter_256 <= counter_256+1'b1;
    end
end


wire signed [BW_IN-1:0] Sx1_pre, Sx2_pre;
wire signed [6-1:0] Sx1, Sx2;

assign Sx1_pre = X_vect[BW_IN-1:0];
assign Sx2_pre = X_vect[BW_IN*2-1:BW_IN];

assign Sx1 = (Sx1_pre[0] == 0) ? Sx1_pre[6:1] : Sx1_pre[6:1] + 2'b01;
assign Sx2 = (Sx2_pre[0] == 0) ? Sx2_pre[6:1] : Sx2_pre[6:1] + 2'b01;





wire signed [BW_IN-1:0] Sy1_pre, Sy2_pre; // 7 bit
wire [5:0] Sy1, Sy2;
//wire [5:0] Sy1_temp, Sy2_temp;

assign Sy1_pre = Y_vect[BW_IN-1:0];
assign Sy2_pre = Y_vect[BW_IN*2-1:BW_IN];

assign Sy1 = (Sy1_pre[0] == 0) ? Sy1_pre[6:1] + 6'b010010 : Sy1_pre[6:1] + 6'b010011;
assign Sy2 = (Sy2_pre[0] == 0) ? Sy2_pre[6:1] + 6'b010010 : Sy2_pre[6:1] + 6'b010011;


// Second stage

wire [5:0] Sx1_pp2, Sx2_pp2;
wire [5:0] Sy1_pp2, Sy2_pp2;

Delay_reg #(.WIDTH(6)) Sx1_Reg(clk, rst, isWorking, Sx1, Sx1_pp2);
Delay_reg #(.WIDTH(6)) Sx2_Reg(clk, rst, isWorking, Sx2, Sx2_pp2);

Delay_reg #(.WIDTH(6)) Sy1_Reg(clk, rst, isWorking, Sy1, Sy1_pp2);
Delay_reg #(.WIDTH(6)) Sy2_Reg(clk, rst, isWorking, Sy2, Sy2_pp2);


//assign Sy1 = (Sy1_temp > 6'd48) ? 0 :
//		(Sy1_temp > 6'd37) ? 36 : Sy1_temp;
//assign Sy2 = (Sy2_temp > 6'd48) ? 0 :
//		(Sy2_temp > 6'd37) ? 36 : Sy2_temp;



// Third stage: Access columns for 2 samples at 1 clock cycle =======================================================================
reg [WIDTH_PIXEL-1:0] ry1_1, ry1_2, ry1_3, ry1_4, ry1_5, ry1_6, ry1_7, ry1_8, ry1_9, ry1_10, ry1_11, ry1_12, ry1_13, ry1_14, ry1_15,
	ry1_16, ry1_17, ry1_18, ry1_19, ry1_20, ry1_21, ry1_22, ry1_23, ry1_24, ry1_25, ry1_26, ry1_27, ry1_28, ry1_29, ry1_30, ry1_31,
	ry1_32, ry1_33, ry1_34, ry1_35, ry1_36, ry1_37;
reg [WIDTH_PIXEL-1:0] ry2_1, ry2_2, ry2_3, ry2_4, ry2_5, ry2_6, ry2_7, ry2_8, ry2_9, ry2_10, ry2_11, ry2_12, ry2_13, ry2_14, ry2_15,
	ry2_16, ry2_17, ry2_18, ry2_19, ry2_20, ry2_21, ry2_22, ry2_23, ry2_24, ry2_25, ry2_26, ry2_27, ry2_28, ry2_29, ry2_30, ry2_31,
	ry2_32, ry2_33, ry2_34, ry2_35, ry2_36, ry2_37;

always @(posedge clk) begin
	ry1_1 <= row1[Sy1_pp2];
	ry1_2 <= row2[Sy1_pp2];
	ry1_3 <= row3[Sy1_pp2];
	ry1_4 <= row4[Sy1_pp2];
	ry1_5 <= row5[Sy1_pp2];
	ry1_6 <= row6[Sy1_pp2];
	ry1_7 <= row7[Sy1_pp2];
	ry1_8 <= row8[Sy1_pp2];
	ry1_9 <= row9[Sy1_pp2];
	ry1_10 <= row10[Sy1_pp2];
	ry1_11 <= row11[Sy1_pp2];
	ry1_12 <= row12[Sy1_pp2];
	ry1_13 <= row13[Sy1_pp2];
	ry1_14 <= row14[Sy1_pp2];
	ry1_15 <= row15[Sy1_pp2];
	ry1_16 <= row16[Sy1_pp2];
	ry1_17 <= row17[Sy1_pp2];
	ry1_18 <= row18[Sy1_pp2];
	ry1_19 <= row19[Sy1_pp2];
	ry1_20 <= row20[Sy1_pp2];
	ry1_21 <= row21[Sy1_pp2];
	ry1_22 <= row22[Sy1_pp2];
	ry1_23 <= row23[Sy1_pp2];
	ry1_24 <= row24[Sy1_pp2];
	ry1_25 <= row25[Sy1_pp2];
	ry1_26 <= row26[Sy1_pp2];
	ry1_27 <= row27[Sy1_pp2];
	ry1_28 <= row28[Sy1_pp2];
	ry1_29 <= row29[Sy1_pp2];
	ry1_30 <= row30[Sy1_pp2];
	ry1_31 <= row31[Sy1_pp2];
	ry1_32 <= row32[Sy1_pp2];
	ry1_33 <= row33[Sy1_pp2];
	ry1_34 <= row34[Sy1_pp2];
	ry1_35 <= row35[Sy1_pp2];
	ry1_36 <= row36[Sy1_pp2];
	ry1_37 <= row37[Sy1_pp2];
end

always @(posedge clk) begin
	ry2_1 <= row1[Sy2_pp2];
	ry2_2 <= row2[Sy2_pp2];
	ry2_3 <= row3[Sy2_pp2];
	ry2_4 <= row4[Sy2_pp2];
	ry2_5 <= row5[Sy2_pp2];
	ry2_6 <= row6[Sy2_pp2];
	ry2_7 <= row7[Sy2_pp2];
	ry2_8 <= row8[Sy2_pp2];
	ry2_9 <= row9[Sy2_pp2];
	ry2_10 <= row10[Sy2_pp2];
	ry2_11 <= row11[Sy2_pp2];
	ry2_12 <= row12[Sy2_pp2];
	ry2_13 <= row13[Sy2_pp2];
	ry2_14 <= row14[Sy2_pp2];
	ry2_15 <= row15[Sy2_pp2];
	ry2_16 <= row16[Sy2_pp2];
	ry2_17 <= row17[Sy2_pp2];
	ry2_18 <= row18[Sy2_pp2];
	ry2_19 <= row19[Sy2_pp2];
	ry2_20 <= row20[Sy2_pp2];
	ry2_21 <= row21[Sy2_pp2];
	ry2_22 <= row22[Sy2_pp2];
	ry2_23 <= row23[Sy2_pp2];
	ry2_24 <= row24[Sy2_pp2];
	ry2_25 <= row25[Sy2_pp2];
	ry2_26 <= row26[Sy2_pp2];
	ry2_27 <= row27[Sy2_pp2];
	ry2_28 <= row28[Sy2_pp2];
	ry2_29 <= row29[Sy2_pp2];
	ry2_30 <= row30[Sy2_pp2];
	ry2_31 <= row31[Sy2_pp2];
	ry2_32 <= row32[Sy2_pp2];
	ry2_33 <= row33[Sy2_pp2];
	ry2_34 <= row34[Sy2_pp2];
	ry2_35 <= row35[Sy2_pp2];
	ry2_36 <= row36[Sy2_pp2];
	ry2_37 <= row37[Sy2_pp2];
end
//=======================================================================================================
// Mux to resolve col_ry1, col_ry2 to each x


// Third stage: latch X coordinator for 2 samples
wire [BW_IN-1-1:0] Sx1_pp3, Sx2_pp3;

Delay_reg #(.WIDTH(6)) Sx1_Reg_pp3(clk, rst, isWorking, Sx1_pp2, Sx1_pp3);
Delay_reg #(.WIDTH(6)) Sx2_Reg_pp3(clk, rst, isWorking, Sx2_pp2, Sx2_pp3);

// Fetch 2 samples according to X coordinators(no stage) ===========================================================
reg [WIDTH_PIXEL-1:0] out1, out2;
always @(*) begin
    case(Sx1_pp3)
	6'b101100: out1 = ry1_1;
	6'b101101: out1 = ry1_1; // -19
	6'b101110: out1 = ry1_1;
	6'b101111: out1 = ry1_2;
	6'b110000: out1 = ry1_3;
	6'b110001: out1 = ry1_4;
	6'b110010: out1 = ry1_5;
	6'b110011: out1 = ry1_6;
	6'b110100: out1 = ry1_7;
	6'b110101: out1 = ry1_8;
	6'b110110: out1 = ry1_9;
	6'b110111: out1 = ry1_10;
	6'b111000: out1 = ry1_11;
	6'b111001: out1 = ry1_12;
	6'b111010: out1 = ry1_13;
	6'b111011: out1 = ry1_14;
	6'b111100: out1 = ry1_15;
	6'b111101: out1 = ry1_16;
	6'b111110: out1 = ry1_17;
	6'b111111: out1 = ry1_18;
	6'b000000: out1 = ry1_19;
	6'b000001: out1 = ry1_20;
	6'b000010: out1 = ry1_21;
	6'b000011: out1 = ry1_22;
	6'b000100: out1 = ry1_23;
	6'b000101: out1 = ry1_24;
	6'b000110: out1 = ry1_25;
	6'b000111: out1 = ry1_26;
	6'b001000: out1 = ry1_27;
	6'b001001: out1 = ry1_28;
	6'b001010: out1 = ry1_29;
	6'b001011: out1 = ry1_30;
	6'b001100: out1 = ry1_31;
	6'b001101: out1 = ry1_32;
	6'b001110: out1 = ry1_33;
	6'b001111: out1 = ry1_34;
	6'b010000: out1 = ry1_35;
	6'b010001: out1 = ry1_36;
	6'b010010: out1 = ry1_37;
	6'b010011: out1 = ry1_37; // 19
	6'b010100: out1 = ry1_37;
	default: out1 = 8'bxxxxxxxx;
    endcase
end
always @(*) begin
    case(Sx2_pp3)
	6'b101100: out2 = ry2_1;
	6'b101101: out2 = ry2_1;
	6'b101110: out2 = ry2_1;
	6'b101111: out2 = ry2_2;
	6'b110000: out2 = ry2_3;
	6'b110001: out2 = ry2_4;
	6'b110010: out2 = ry2_5;
	6'b110011: out2 = ry2_6;
	6'b110100: out2 = ry2_7;
	6'b110101: out2 = ry2_8;
	6'b110110: out2 = ry2_9;
	6'b110111: out2 = ry2_10;
	6'b111000: out2 = ry2_11;
	6'b111001: out2 = ry2_12;
	6'b111010: out2 = ry2_13;
	6'b111011: out2 = ry2_14;
	6'b111100: out2 = ry2_15;
	6'b111101: out2 = ry2_16;
	6'b111110: out2 = ry2_17;
	6'b111111: out2 = ry2_18;
	6'b000000: out2 = ry2_19;
	6'b000001: out2 = ry2_20;
	6'b000010: out2 = ry2_21;
	6'b000011: out2 = ry2_22;
	6'b000100: out2 = ry2_23;
	6'b000101: out2 = ry2_24;
	6'b000110: out2 = ry2_25;
	6'b000111: out2 = ry2_26;
	6'b001000: out2 = ry2_27;
	6'b001001: out2 = ry2_28;
	6'b001010: out2 = ry2_29;
	6'b001011: out2 = ry2_30;
	6'b001100: out2 = ry2_31;
	6'b001101: out2 = ry2_32;
	6'b001110: out2 = ry2_33;
	6'b001111: out2 = ry2_34;
	6'b010000: out2 = ry2_35;
	6'b010001: out2 = ry2_36;
	6'b010010: out2 = ry2_37;
	6'b010011: out2 = ry2_37;
	6'b010100: out2 = ry2_37;
	default: out2 = 8'bxxxxxxxx;
    endcase
end
// ========================================================================================================



// fourth stage: latch value of 2 samples for comparison ===================================================
reg [WIDTH_PIXEL-1:0] S1, S2;
always @(posedge clk) begin
    if (rst) begin
	S1 <= 0;
	S2 <= 0;
    end
    else begin
	S1 <= out1;
	S2 <= out2;
    end
end
// ========================================================================================================
wire description_bit = S1 < S2;


// Fifth step: Shift description ==========================================================================
reg [NUMBER_OF_DESCRIPTORS-1:0] descriptors;
always @(posedge clk) begin
    if(generating_shift) begin
        descriptors <= { description_bit, descriptors[255:1]};
    end
end
// =========================================================================================================

assign out = descriptors;

always @(posedge clk) begin
    if (rst) 						done <= 1'b0;
    else if ((generating_shift) && (~sample_shift_pp3)) done <= 1'b1;
    else						done <= 1'b0; 
end

endmodule