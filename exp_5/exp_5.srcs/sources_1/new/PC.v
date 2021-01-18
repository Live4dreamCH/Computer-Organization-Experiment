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
    reg[`CPU_width-1 :0] inner_addr = `CPU_width'b0, back1, back2;
    reg[1:0] counter=2'b11;

    reg[`CPU_width-1 :0] temp;

    assign addr = (we==0 && en==1) ? inner_addr : `CPU_width'hzzzzzzzz;
    always @(posedge clk) begin
        if (counter) begin
            counter=counter-1;
        end else begin
            counter=2'b11;
        end
        if (counter==1) begin
            back2 = back1;
            back1 = inner_addr;
        end
        if (en) begin
            if(add4) begin
                inner_addr = inner_addr + 4;
            end
            if (we) begin
                case (type)
                    2'b00: inner_addr = {back1[`CPU_width-1 : `J_imme+2], imme[`J_imme-1 : 0], 2'b00};
                    2'b01:begin
                        temp = { {i_ext{imme[`I_imme-1]}}, imme[`I_imme-1:0], 2'b00 };
                        inner_addr = temp + back2;
                    end
                endcase
                
            end
        end
    end
endmodule
