`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/15 16:43:19
// Design Name: 
// Module Name: My4AndGate_test
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


module My4AndGate_test(

    );
    reg in1,in2,in3,in4;
    wire out;
    initial begin
        {in1,in2,in3,in4}=4'd0;
        # 10;
        {in1,in2,in3,in4}=4'd1;
        # 10;
        {in1,in2,in3,in4}=4'd2;
        # 10;
        {in1,in2,in3,in4}=4'd3;
        # 10;
        {in1,in2,in3,in4}=4'd4;
        # 10;
        {in1,in2,in3,in4}=4'd5;
        # 10;
        {in1,in2,in3,in4}=4'd6;
        # 10;
        {in1,in2,in3,in4}=4'd7;
        # 10;
        {in1,in2,in3,in4}=4'd8;
        # 10;
        {in1,in2,in3,in4}=4'd9;
        # 10;
        {in1,in2,in3,in4}=4'd10;
        # 10;
        {in1,in2,in3,in4}=4'd11;
        # 10;
        {in1,in2,in3,in4}=4'd12;
        # 10;
        {in1,in2,in3,in4}=4'd13;
        # 10;
        {in1,in2,in3,in4}=4'd14;
        # 10;
        {in1,in2,in3,in4}=4'd15;
        # 10;
    end
    My4AndGate g1(in1, in2, in3, in4, out);    
endmodule
