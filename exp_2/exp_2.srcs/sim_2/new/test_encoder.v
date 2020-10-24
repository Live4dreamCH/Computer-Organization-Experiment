`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/24 11:04:11
// Design Name: 
// Module Name: test_encoder
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


module test_encoder(
    );
    reg clk=0, en=1;
    reg [7:0] i=0;
    wire [2:0] o;

    encoder_8to3 e(i, en, clk, o);
    always begin
        #5
        clk = ~clk;
        #10
        clk = ~clk;
        #5
        if (i == 8'b10000000) begin
            en = ~en;
        end
        if (i == 0) begin
            i = 1;
        end
        i = i << 1;
    end
endmodule
