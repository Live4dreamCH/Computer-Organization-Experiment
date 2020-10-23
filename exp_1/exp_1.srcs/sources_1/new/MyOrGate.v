`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/23 21:10:43
// Design Name: 
// Module Name: MyOrGate
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


module MyOrGate(
    i1,
    i2,
    o
    );
    input i1, i2;
    output o;
    wire ni1, ni2, temp;
    MyNotGate n1(i1, ni1);
    MyNotGate n2(i2, ni2);
    MyAndGate a1(ni1, ni2, temp);
    MyNotGate n3(temp, o);
endmodule
