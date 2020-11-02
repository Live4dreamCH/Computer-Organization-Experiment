`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/22 15:40:55
// Design Name: 
// Module Name: counter_47
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


module counter_47(
    clk,    //上升沿触发
    en,     //1使能
    clear,  //1置零
    set,    //1预置
    add,    //1自增,0自减,x/z默认自增
    num_i,  //输入预置数
    num_o   //输出
    );
    //同步可复位可预置可逆模47计数器
    input clk, en, clear, set, add;
    input [5:0] num_i;
    output [5:0] num_o;
    reg [5:0] num_o = 6'b0;

    always @(posedge clk) begin
        if (en) begin
            if (clear) begin
                num_o = 6'b0;
            end 
            else begin
                if (set) begin
                    if (num_i < 47) begin
                        num_o = num_i;
                    end
                end 
                else begin
                    if (add !== 0) begin
                        num_o = (num_o < 46) ? (num_o + 6'b1) : 6'b0;
                    end 
                    else begin
                        num_o = (num_o > 0) ? (num_o - 6'b1) : 6'd46;
                    end
                end
            end
        end
    end
endmodule
