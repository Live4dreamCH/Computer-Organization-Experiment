`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/15 15:49:01
// Design Name: 
// Module Name: MyAndGate_test
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


module MyAndGate_test(

    );
    reg in1,in2;
    wire out;
    initial begin
        in1=0;
        in2=0;
        #10;
        in2=1;
        #10;
        in1=1;
        #10;
        in2=0;
    end
    MyAndGate a1(in1, in2, out);
endmodule
