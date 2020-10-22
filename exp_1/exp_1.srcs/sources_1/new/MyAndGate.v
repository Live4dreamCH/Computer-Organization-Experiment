`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/15 15:17:17
// Design Name: 
// Module Name: MyAndGate
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


module MyAndGate(
    i1,
    i2,
    o
    );
    input i1;
    input i2;
    output o;
    assign o = i1 & i2;
endmodule
