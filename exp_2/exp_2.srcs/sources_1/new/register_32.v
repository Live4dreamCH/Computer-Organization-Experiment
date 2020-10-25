`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/22 15:40:55
// Design Name: 
// Module Name: register_32
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


module register_32(
    data_bus,
    en,
    clear,
    io,
    clk
    );
    //32位寄存器, 同步电路, 并行输入输出
    //data占据了32个引脚, 对其进行复用:io=1(且上升沿+使能)时向里输入(写数据), io=0时向外输出(读数据)
    //复用data使用了inout类型的端口(总线端口), 它要求不能同时进行输入和输出操作, 故下文38行和45行对读写进行了隔离
    //en高电平使能, clear高电平时, 对内部数据归零(无视当前io的值), clk上升沿触发
    inout [31:0] data_bus;
    input en, clear, io, clk;
    reg [31:0] inner_data;

    assign data_bus = (io==0) ? inner_data : 32'bz;
    always @(posedge clk) begin
        if (en) begin
            if (clear) begin
                inner_data = 32'b0;
            end else begin
                if (io) begin
                    inner_data = data_bus;
                end
            end
        end
    end
endmodule
