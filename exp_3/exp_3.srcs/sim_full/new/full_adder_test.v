`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/15 00:03:27
// Design Name: 
// Module Name: full_adder_test
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


module full_adder_test();
    reg a = 0, b = 0, c_in = 0;
    wire c_out, s;
    full_adder fa(.a(a), .b(b), .c_i(c_in), .c_o(c_out), .s(s));
    always #10 begin
        {a, b, c_in} = {a, b, c_in} + 1;
    end
endmodule
