`timescale 1ns / 1ps
`include "Constants.vh"

module Memory(data, addr, en, we, clk);
    //256*32b存储器, 时序电路, 并行输入输出, 同步输入,异步输出
    //data占据了32个引脚, 对其进行复用
    //we=1(且上升沿+使能)时向内存里输入(CPU写数据), we=0时内存向外输出(CPU读数据)
    //addr地址线, 32位, 输入类型
    //复用data使用了inout类型的端口(总线端口), 它要求不能同时进行输入和输出操作, 故下文对读写进行了隔离
    //en高电平使能, clk上升沿触发
    //强制进行内存4-Byte对齐
    inout [31:0] data;
    input en, we, clk;
    input [31:0] addr;
    
    reg [31:0] memory_bank[0:255];
    wire[31:0] bank_addr;

    initial begin
        $readmemh("E:\\CPU\\exp_5\\exp_5.srcs\\sources_1\\new\\CodeAndData_Hex.txt", memory_bank);
    end

    assign bank_addr = {2'b00, addr[31:2]};
    assign data = (we==0 && en==1) ? memory_bank[bank_addr] : 32'bz;    //读出
    always @(posedge clk) begin
        if (en && we) begin
            memory_bank[bank_addr] = data;  //写入
        end
    end
endmodule
