`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/24 16:58:21
// Design Name: 
// Module Name: test_D_flip_flop
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


module test_D_flip_flop(
    );
    reg D = 0, en = 0, clk = 0, clear = 0, set = 0;
    wire Q, NQ;
    D_flip_flop dff(D, en, clk, clear, set, Q, NQ);

    always begin
        #5
        clk = 1;
        #10
        clk = 0;
        #5
        {en, clear, set, D} = {en, clear, set, D} + 1;
    end
endmodule
