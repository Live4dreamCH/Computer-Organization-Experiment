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
    
    reg[31:0] rrr=0;
    wire[31:0] www;
    assign www=rrr;
    initial begin
        #0.1
        rrr=1;
        #0.1
        rrr=2;
    end

    always fork
        //是无符号数比�?
        #1 result = a<b;
        #11 result = a>b;
        //可行
        #3 forever begin 
            clk=~clk; 
            #5 ;
        end
    join
endmodule
