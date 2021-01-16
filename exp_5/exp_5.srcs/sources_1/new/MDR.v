`timescale 1ns / 1ps
`include "Constants.vh"

//MDR 一个普通的寄存器, 暂存内存读写的数值
module MDR(clk, en, we, data);
    inout [`CPU_width-1 :0] data;
    input en, we, clk;
    reg [`CPU_width-1:0] inner_data = `CPU_width'h00000000;

    assign data = (we==0 && en==1) ? inner_data : `CPU_width'bz;    //读出
    always @(posedge clk) begin
        if (en && we) begin
            inner_data = data;  //写入
        end
    end

endmodule
