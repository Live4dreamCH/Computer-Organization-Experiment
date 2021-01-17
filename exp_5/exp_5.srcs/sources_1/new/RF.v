`timescale 1ns / 1ps
`include "Constants.vh"

//RF 双端口输出, 单端口写入的寄存器组
module RF(clk, en, we, in_addr, out1_addr, out2_addr, in, out1, out2);
    input clk, en, we;
    input[`R_addr_width-1 :0] in_addr, out1_addr, out2_addr;
    input[`CPU_width-1 :0] in;

    output[`CPU_width-1 :0] out1, out2;

    reg[`CPU_width-1 :0] registers[0: `RF_num-1];

    assign out1 = (we==0 && en==1) ? registers[out1_addr] : `CPU_width'bz;
    assign out2 = (we==0 && en==1) ? registers[out2_addr] : `CPU_width'bz;

    initial begin
        $readmemh("E:\\CPU\\exp_5\\exp_5.srcs\\sources_1\\new\\RF_zeroh.txt", registers);
    end

    always @(posedge clk) begin
        if (en && we) begin
            registers[in_addr] = in;  //写入
        end
    end
endmodule
