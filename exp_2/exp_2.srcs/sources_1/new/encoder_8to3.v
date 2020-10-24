`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/22 15:40:55
// Design Name: 
// Module Name: 8to3_encoder
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


module encoder_8to3(
    i_8,
    en,
    clk,
    o_3
    );
    //8-3编码器
    //上升沿触发, 高电平使能
    //输入输出均高电平有效; 若输入不符合格式, 则输出不确定
    input [7:0] i_8;
    input en;
    input clk;
    output [2:0] o_3;
    reg [2:0] o_3;

    always @(posedge clk) begin
        if(en) begin
            case (i_8)
                8'b00000001: o_3 = 3'b000;
                8'b00000010: o_3 = 3'b001;
                8'b00000100: o_3 = 3'b010;
                8'b00001000: o_3 = 3'b011;
                8'b00010000: o_3 = 3'b100;
                8'b00100000: o_3 = 3'b101;
                8'b01000000: o_3 = 3'b110;
                8'b10000000: o_3 = 3'b111;
                default: o_3 = 3'bxxx;
            endcase
        end
    end
endmodule
