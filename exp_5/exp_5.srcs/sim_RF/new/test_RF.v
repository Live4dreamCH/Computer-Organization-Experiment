`timescale 1ns / 1ps
//`include "Constants.vh"

module test_RF();
    reg clk=0, en=1, we=0;
    reg[`R_addr_width-1 :0] in_addr, out1_addr, out2_addr;
    reg[`CPU_width-1 :0] in;

    wire[`CPU_width-1 :0] out1, out2;

    RF rf(clk, en, we, in_addr, out1_addr, out2_addr, in, out1, out2);

    initial begin
        #3
        out1_addr=1;
        out2_addr=2;
        #10
        out1_addr=3;
        out2_addr=4;
        #10
        we=1;
        in_addr=3;
        in=`CPU_width'h21861141;
        #10
        we=0;
        #10
        $finish;
    end

    initial begin
        forever #5 clk = ~clk;
    end
endmodule
