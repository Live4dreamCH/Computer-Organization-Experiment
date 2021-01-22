`timescale 1ns / 1ps
`include "Constants.vh"

//MAR 内存地址寄存器, 负责传递PC的值, 或者I-type指令lw sw的地址生成
//mix 是否将r_addr与符号扩展后的i_addr相加, 1则相加
//we 读令, 1为读入, 0为输出
//PC_addr 从寄存器来的值, 可能是PC也可能是RF
//i_addr 从IR来的立即数
//addr 所输出的地址
module MAR(clk, en, mix, we, PC_addr, i_addr, addr, RF_addr);
    parameter ext_width = `CPU_width-`I_imme;
    input clk, en, mix, we;
    input[`CPU_width-1 :0] PC_addr, RF_addr;
    input[`I_imme-1 :0] i_addr;

    output[`CPU_width-1:0] addr;
    reg[`CPU_width-1:0] inner_addr = `CPU_width'h00000000;

    reg[`CPU_width-1:0] ext;

    assign addr = (we==0 && en==1) ? inner_addr : `CPU_width'hzzzzzzzz;
    always @(posedge clk) begin
        if (en && we) begin
            if (mix) begin
                ext = { {ext_width{i_addr[`I_imme-1]}}, i_addr[`I_imme-1:0] };
                inner_addr = RF_addr + ext;
            end else begin
                inner_addr = PC_addr;
            end
        end
    end
endmodule
