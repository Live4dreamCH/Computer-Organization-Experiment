`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/14 21:39:38
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    a, b, c_i, c_o, s
    );
    input a, b, c_i;
    output c_o, s;
    wire c_t1, c_t2, s_t;
    half_adder  h1(.a(a), .b(b), .s(s_t), .c(c_t1)),
                h2(.a(s_t), .b(c_i), .s(s), .c(c_t2));
    or (c_o, c_t1, c_t2);
endmodule
