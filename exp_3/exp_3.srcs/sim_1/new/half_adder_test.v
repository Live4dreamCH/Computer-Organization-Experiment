`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/14 22:34:13
// Design Name: 
// Module Name: half_adder_test
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


module half_adder_test();
    reg a = 0, b = 0;
    wire s, c;
    half_adder ha(.a(a), .b(b), .s(s), .c(c));
    always #10 begin
        {a, b} = {a, b} + 1;
    end
endmodule
