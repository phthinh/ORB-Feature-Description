module RowBuffer(clk, rst, ena, pixel, 
	e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16, e17, e18, e19, e20, e21, e22, e23,
	e24, e25, e26, e27, e28, e29, e30, e31, e32, e33, e34, e35, e36, e37);


parameter PIXEL_WIDTH = 8;
parameter WIDTH_BUFFER = 4096; // 8 * 512
parameter WIDTH_RX = 3072; // 6 * 512


input  clk, rst, ena;
input [PIXEL_WIDTH-1:0] pixel;


// e is feed into BRIEF to calculate the centroid
output [PIXEL_WIDTH-1:0] e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16, e17, e18, e19, e20,
			e21, e22, e23, e24, e25, e26, e27, e28, e29, e30, e31, e32, e33, e34, e35, e36, e37;

wire [PIXEL_WIDTH-1:0] row1_1;
wire [PIXEL_WIDTH-1:0] row1_2;
wire [PIXEL_WIDTH-1:0] row2_1;
wire [PIXEL_WIDTH-1:0] row2_2;
wire [PIXEL_WIDTH-1:0] row3_1;
wire [PIXEL_WIDTH-1:0] row3_2;
wire [PIXEL_WIDTH-1:0] row4_1;
wire [PIXEL_WIDTH-1:0] row4_2;
wire [PIXEL_WIDTH-1:0] row5_1;
wire [PIXEL_WIDTH-1:0] row5_2;
wire [PIXEL_WIDTH-1:0] row6_1;
wire [PIXEL_WIDTH-1:0] row6_2;
wire [PIXEL_WIDTH-1:0] row7_1;
wire [PIXEL_WIDTH-1:0] row7_2;
wire [PIXEL_WIDTH-1:0] row8_1;
wire [PIXEL_WIDTH-1:0] row8_2;
wire [PIXEL_WIDTH-1:0] row9_1;
wire [PIXEL_WIDTH-1:0] row9_2;

wire [PIXEL_WIDTH-1:0] row10_1;
wire [PIXEL_WIDTH-1:0] row10_2;
wire [PIXEL_WIDTH-1:0] row11_1;
wire [PIXEL_WIDTH-1:0] row11_2;
wire [PIXEL_WIDTH-1:0] row12_1;
wire [PIXEL_WIDTH-1:0] row12_2;
wire [PIXEL_WIDTH-1:0] row13_1;
wire [PIXEL_WIDTH-1:0] row13_2;
wire [PIXEL_WIDTH-1:0] row14_1;
wire [PIXEL_WIDTH-1:0] row14_2;
wire [PIXEL_WIDTH-1:0] row15_1;
wire [PIXEL_WIDTH-1:0] row15_2;
wire [PIXEL_WIDTH-1:0] row16_1;
wire [PIXEL_WIDTH-1:0] row16_2;
wire [PIXEL_WIDTH-1:0] row17_1;
wire [PIXEL_WIDTH-1:0] row17_2;
wire [PIXEL_WIDTH-1:0] row18_1;
wire [PIXEL_WIDTH-1:0] row18_2;
wire [PIXEL_WIDTH-1:0] row19_1;
wire [PIXEL_WIDTH-1:0] row19_2;

wire [PIXEL_WIDTH-1:0] row20_1;
wire [PIXEL_WIDTH-1:0] row20_2;
wire [PIXEL_WIDTH-1:0] row21_1;
wire [PIXEL_WIDTH-1:0] row21_2;
wire [PIXEL_WIDTH-1:0] row22_1;
wire [PIXEL_WIDTH-1:0] row22_2;
wire [PIXEL_WIDTH-1:0] row23_1;
wire [PIXEL_WIDTH-1:0] row23_2;
wire [PIXEL_WIDTH-1:0] row24_1;
wire [PIXEL_WIDTH-1:0] row24_2;
wire [PIXEL_WIDTH-1:0] row25_1;
wire [PIXEL_WIDTH-1:0] row25_2;
wire [PIXEL_WIDTH-1:0] row26_1;
wire [PIXEL_WIDTH-1:0] row26_2;
wire [PIXEL_WIDTH-1:0] row27_1;
wire [PIXEL_WIDTH-1:0] row27_2;
wire [PIXEL_WIDTH-1:0] row28_1;
wire [PIXEL_WIDTH-1:0] row28_2;
wire [PIXEL_WIDTH-1:0] row29_1;
wire [PIXEL_WIDTH-1:0] row29_2;

wire [PIXEL_WIDTH-1:0] row30_1;
wire [PIXEL_WIDTH-1:0] row30_2;
wire [PIXEL_WIDTH-1:0] row31_1;
wire [PIXEL_WIDTH-1:0] row31_2;
wire [PIXEL_WIDTH-1:0] row32_1;
wire [PIXEL_WIDTH-1:0] row32_2;
wire [PIXEL_WIDTH-1:0] row33_1;
wire [PIXEL_WIDTH-1:0] row33_2;
wire [PIXEL_WIDTH-1:0] row34_1;
wire [PIXEL_WIDTH-1:0] row34_2;
wire [PIXEL_WIDTH-1:0] row35_1;
wire [PIXEL_WIDTH-1:0] row35_2;
wire [PIXEL_WIDTH-1:0] row36_1;
wire [PIXEL_WIDTH-1:0] row36_2;
wire [PIXEL_WIDTH-1:0] row37_1;
//wire [PIXEL_WIDTH-1:0] row37_2;


Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg1(clk, rst, ena, pixel, row1_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r1(clk, rst, ena, row1_1, row1_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg2(clk, rst, ena, row1_2, row2_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r2(clk, rst, ena, row2_1, row2_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg3(clk, rst, ena, row2_2, row3_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r3(clk, rst, ena, row3_1, row3_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg4(clk, rst, ena, row3_2, row4_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r4(clk, rst, ena, row4_1, row4_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg5(clk, rst, ena, row4_2, row5_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r5(clk, rst, ena, row5_1, row5_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg6(clk, rst, ena, row5_2, row6_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r6(clk, rst, ena, row6_1, row6_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg7(clk, rst, ena, row6_2, row7_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r7(clk, rst, ena, row7_1, row7_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg8(clk, rst, ena, row7_2, row8_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r8(clk, rst, ena, row8_1, row8_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg9(clk, rst, ena, row8_2, row9_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r9(clk, rst, ena, row9_1, row9_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg10(clk, rst, ena, row9_2, row10_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r10(clk, rst, ena, row10_1, row10_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg11(clk, rst, ena, row10_2, row11_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r11(clk, rst, ena, row11_1, row11_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg12(clk, rst, ena, row11_2, row12_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r12(clk, rst, ena, row12_1, row12_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg13(clk, rst, ena, row12_2, row13_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r13(clk, rst, ena, row13_1, row13_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg14(clk, rst, ena, row13_2, row14_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r14(clk, rst, ena, row14_1, row14_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg15(clk, rst, ena, row14_2, row15_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r15(clk, rst, ena, row15_1, row15_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg16(clk, rst, ena, row15_2, row16_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r16(clk, rst, ena, row16_1, row16_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg17(clk, rst, ena, row16_2, row17_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r17(clk, rst, ena, row17_1, row17_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg18(clk, rst, ena, row17_2, row18_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r18(clk, rst, ena, row18_1, row18_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg19(clk, rst, ena, row18_2, row19_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r19(clk, rst, ena, row19_1, row19_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg20(clk, rst, ena, row19_2, row20_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r20(clk, rst, ena, row20_1, row20_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg21(clk, rst, ena, row20_2, row21_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r21(clk, rst, ena, row21_1, row21_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg22(clk, rst, ena, row21_2, row22_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r22(clk, rst, ena, row22_1, row22_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg23(clk, rst, ena, row22_2, row23_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r23(clk, rst, ena, row23_1, row23_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg24(clk, rst, ena, row23_2, row24_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r24(clk, rst, ena, row24_1, row24_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg25(clk, rst, ena, row24_2, row25_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r25(clk, rst, ena, row25_1, row25_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg26(clk, rst, ena, row25_2, row26_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r26(clk, rst, ena, row26_1, row26_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg27(clk, rst, ena, row26_2, row27_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r27(clk, rst, ena, row27_1, row27_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg28(clk, rst, ena, row27_2, row28_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r28(clk, rst, ena, row28_1, row28_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg29(clk, rst, ena, row28_2, row29_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r29(clk, rst, ena, row29_1, row29_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg30(clk, rst, ena, row29_2, row30_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r30(clk, rst, ena, row30_1, row30_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg31(clk, rst, ena, row30_2, row31_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r31(clk, rst, ena, row31_1, row31_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg32(clk, rst, ena, row31_2, row32_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r32(clk, rst, ena, row32_1, row32_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg33(clk, rst, ena, row32_2, row33_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r33(clk, rst, ena, row33_1, row33_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg34(clk, rst, ena, row33_2, row34_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r34(clk, rst, ena, row34_1, row34_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg35(clk, rst, ena, row34_2, row35_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r35(clk, rst, ena, row35_1, row35_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg36(clk, rst, ena, row35_2, row36_1);
Delay_D #(.WIDTH(PIXEL_WIDTH), .D(639)) Delay_D_r36(clk, rst, ena, row36_1, row36_2);

Delay_reg #(.WIDTH(PIXEL_WIDTH)) Delay_reg37(clk, rst, ena, row36_2, row37_1);

assign e37 = row1_1;
assign e36 = row2_1;
assign e35 = row3_1;
assign e34 = row4_1;
assign e33 = row5_1;
assign e32 = row6_1;
assign e31 = row7_1;
assign e30 = row8_1;
assign e29 = row9_1;
assign e28 = row10_1;
assign e27 = row11_1;
assign e26 = row12_1;
assign e25 = row13_1;
assign e24 = row14_1;
assign e23 = row15_1;
assign e22 = row16_1;
assign e21 = row17_1;
assign e20 = row18_1;
assign e19 = row19_1;
assign e18 = row20_1;
assign e17 = row21_1;
assign e16 = row22_1;
assign e15 = row23_1;
assign e14 = row24_1;
assign e13 = row25_1;
assign e12 = row26_1;
assign e11 = row27_1;
assign e10 = row28_1;
assign e9 = row29_1;
assign e8 = row30_1;
assign e7 = row31_1;
assign e6 = row32_1;
assign e5 = row33_1;
assign e4 = row34_1;
assign e3 = row35_1;
assign e2 = row36_1;
assign e1 = row37_1;

endmodule