`timescale 1ns / 1ps
`include "Constants.vh"

module Memory(
    data,
    addr,
    en,
    we,
    clk
    );
    //256*32位存储器, 同步电路, 并行输入输出
    //data占据了32个引脚, 对其进行复用:we=1(且上升沿+使能)时向里输入(写数据), we=0时向外输出(读数据)
    //addr地址线, 8位, 输入类型
    //复用data使用了inout类型的端口(总线端口), 它要求不能同时进行输入和输出操作, 故下文38行和45行对读写进行了隔离
    //en高电平使能, clk上升沿触发
    inout [31:0] data;
    input en, we, clk;
    input [31:0] addr;
    reg [31:0] memory_bank[0:255];

    assign data = (we==0 && en==1) ? memory_bank[addr] : 32'bz;    //读出
    always @(posedge clk) begin
        if (en && we) begin
            memory_bank[addr] = data;  //写入
        end
    end
endmodule
