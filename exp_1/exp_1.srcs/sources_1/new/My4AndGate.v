`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/15 16:36:58
// Design Name: 
// Module Name: My4AndGate
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


module My4AndGate(
    input i1,
    input i2,
    input i3,
    input i4,
    output out
    );
    wire temp1, temp2;
    MyAndGate g1(i1, i2, temp1);
    MyAndGate g2(i3, i4, temp2);
    MyAndGate g3(temp1, temp2, out);
endmodule
