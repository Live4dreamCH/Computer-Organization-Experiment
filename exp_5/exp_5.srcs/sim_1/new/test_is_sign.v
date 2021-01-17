`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/17 09:41:49
// Design Name: 
// Module Name: test_is_sign
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


module test_is_sign(

    );
    reg[31:0] result=32'bz;
    reg[31:0] a=1, b=-1;
    reg clk=0;
    always fork
        #1 result = a<b;
        #11 result = a>b;
        #3 forever begin 
            clk=~clk; 
            #5 ;
        end
    join
endmodule
