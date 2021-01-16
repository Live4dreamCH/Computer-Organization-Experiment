`timescale 1ns / 1ps
`include "Constants.vh"

//PC 程序计数器, 负责自增4, 或者J-type命令
//add4 自增信号,CU发出
//imme 从IR来的立即数
//we 读令, 1为读入, 0为输出
//addr 所输出的地址
//type 输入的数的类型,由CU提供
//0=j, 1=beq/bne
module PC(clk, add4, en, imme, we, addr, type);
    parameter i_ext = `CPU_width-`I_imme-2;
    input clk, add4, en, we;
    input[`J_imme-1 :0] imme;
    input[1:0] type;

    output[`CPU_width-1 :0] addr;
    reg[`CPU_width-1 :0] inner_addr = `CPU_width'h00000000;

    reg[`CPU_width-1 :0] temp;

    assign addr = (we==0 && en==1) ? inner_addr : `CPU_width'hzzzzzzzz;
    always @(posedge clk) begin
        if (en) begin
            if(add4) begin
                inner_addr = inner_addr + 4;
            end
            if (we) begin
                case (type)
                    2'b00: inner_addr = {inner_addr[`CPU_width-1 : `J_imme+2], imme[`J_imme-1 : 0], 2'b00};
                    2'b01:begin
                        temp = { {i_ext{imme[`I_imme-1]}}, imme[`I_imme-1:0], 2'b00 };
                        inner_addr = temp + inner_addr;
                    end
                endcase
                
            end
        end
    end
endmodule
