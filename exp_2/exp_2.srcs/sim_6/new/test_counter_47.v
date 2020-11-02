`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/27 17:41:25
// Design Name: 
// Module Name: test_counter_47
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_counter_47(
    );
    reg clk=0, en=1, clear=0, set=0, add=1;
    reg [5:0] num_i = 1;
    wire [5:0] num_o;
    counter_47 c47(clk, en, clear, set, add, num_i, num_o);

    initial fork
        #23 clear = 1;
        #33 clear = 0;
        #43 en = 0;
        #53 en = 1;
        #103 set = 1;
        #103 num_i = 16;
        #113 num_i = 44;
        #123 num_i = 0;
        #123 set = 0;
        #173 add = 0;
        #223 add = 1;
        forever #5 clk = ~clk;
    join
endmodule
