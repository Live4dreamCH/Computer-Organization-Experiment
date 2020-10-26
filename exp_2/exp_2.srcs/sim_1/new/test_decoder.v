`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/22 16:10:15
// Design Name: 
// Module Name: test_decoder
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


module test_decoder(

    );
    reg clk=0, en=1;
    reg [2:0] i=0;
    wire [7:0] o;

    decoder_3to8 d(i, clk, en, o);
    always begin
        #5
        clk = ~clk;
        #10
        clk = ~clk;
        #5
        if (i == 7) begin
            en = ~en;
        end
        i = i + 1;
    end
endmodule
