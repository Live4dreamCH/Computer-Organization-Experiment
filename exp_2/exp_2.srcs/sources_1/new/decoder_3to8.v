`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/22 15:40:55
// Design Name: 
// Module Name: 3to8_decoder
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


module decoder_3to8(
    i_3,
    clk,
    en,
    o_8
    );
    //3-8译码器
    //上升沿触发, 高电平使能
    //输入输出均高电平有效; 若输入不确定, 则输出也不确定
    input [2:0] i_3;
    input clk;
    input en;

    output [7:0] o_8;
    reg [7:0] o_8;
    
    always @(posedge clk) begin
        if(en) begin
            case (i_3)
                3'd0: o_8 = 8'b00000001;
                3'd1: o_8 = 8'b00000010;
                3'd2: o_8 = 8'b00000100;
                3'd3: o_8 = 8'b00001000;
                3'd4: o_8 = 8'b00010000;
                3'd5: o_8 = 8'b00100000;
                3'd6: o_8 = 8'b01000000;
                3'd7: o_8 = 8'b10000000;
                default: o_8 = 8'bxxxxxxxx;
            endcase
        end
    end
endmodule
