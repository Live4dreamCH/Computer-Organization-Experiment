`timescale 1ns / 1ps
`include "Constants.vh"

//RF 双端口输出, 单端口写入的寄存器组
//由于输出的rt与I-imme可能在ALU的in2端口发生碰撞, 所以追加了以下机制:
//若输入的地址数为z, 则对应的输出也为z
//此时,再利用IR的is_rt=0, 就可使rt(out2)的输出值为z
module RF(clk, en, we, in_addr, out1_addr, out2_addr, in, out1, out2);
    input clk, en, we;
    input[`R_addr_width-1 :0] in_addr, out1_addr, out2_addr;
    input[`CPU_width-1 :0] in;

    output[`CPU_width-1 :0] out1, out2;

    reg[`CPU_width-1 :0] registers[0: `RF_num-1];

    assign out1 = (we==0 && en==1 && out1_addr!==`R_addr_width'bz) ? registers[out1_addr] : `CPU_width'bz;
    assign out2 = (we==0 && en==1 && out2_addr!==`R_addr_width'bz) ? registers[out2_addr] : `CPU_width'bz;

    initial begin
        $readmemh("E:\\CPU\\exp_5\\exp_5.srcs\\sources_1\\new\\RF_zeroh.txt", registers);
    end

    always @(posedge clk) begin
        if (en && we) begin
            registers[in_addr] = in;  //写入
        end
    end
endmodule
