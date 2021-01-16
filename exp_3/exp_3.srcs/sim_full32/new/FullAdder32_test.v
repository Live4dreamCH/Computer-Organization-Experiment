`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/15 11:01:21
// Design Name: 
// Module Name: FullAdder32_test
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


module FullAdder32_test();
    reg[31:0] a, b;
    wire[31:0] s;
    wire c;
    FullAdder32 fa32(a, b, c, s);
    initial begin
        #10 a=0;b=0;
        #10 a=0;b=1;
        #10 a=1;b=0;
        #10 a=1;b=1;
        #10 a=32'hffffffff;b=0;
        #10 a=32'hffffffff;b=1;
        #10 a=32'hffffffff;b=2;
        #10 a=32'hffffffff;b=32'hffffffff;
    end
endmodule
