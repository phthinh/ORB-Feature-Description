module Delay_Corner_Signal(clk, rst, ena, inCorner, delayCorner);

parameter DELAY = 11502; // 11502 - latency
parameter WIDTH_DELAY_ADDRESS = 14;

input clk;
input rst;
input ena;


input inCorner;
output delayCorner;

// Hear explaining how many register needs to put in the middle of inCorner and delayCorner
// First, find the size of window. In this case, it is 37*37.
// Second, the middle one, will sit at column 19 and row 19
// Third, to find the offset, calculate the middle to the first element in 37*37, position (1,1)
// for example
// ***** 1 2 3 5 6 ***
// ***** 2 5 8 9 7 ***
// ***** 1 4 0 8 9 ***
// ***** 1 4 7 8 5 ***
// ***** 5 8 7 4 1 ***
// As we can see, 0 is the middle. Calculate the offset from 0 to 1 - (1,1) at the top left.
// From 0, we run to 8->9->*->*->*->*->*->*->7->9->8->5->2->*->*->*->*->*->*->*->*->*->*->*1
// So total 24.
// Final step is take 24 minus to the latency of the HarrisCorner.(latency is defined as how much
// time to determine one pixel at the input is corner or non-corner)

// So in this paper, we use 640 shift, so the total offset is counted as follow:
// 17*640 + 640-19+1 = 11502
// So you just need get 11502 - latency = delay 


Delay_D #(.WIDTH(1), .D(DELAY), .B(WIDTH_DELAY_ADDRESS)) Delay_D1(clk, rst, ena, inCorner, delayCorner);

endmodule


