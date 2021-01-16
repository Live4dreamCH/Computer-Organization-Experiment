`timescale 1ns / 1ps
//`include "Constants.vh"

module test_MAR();
    reg clk=0, en=1, mix=0, we=0;
    reg[`CPU_width-1:0] r_addr;
    reg[`I_imme-1:0] i_addr;

    wire[`CPU_width-1:0] addr;

    MAR mar(clk, en, mix, we, r_addr, i_addr, addr);

    always fork
        #3 we=1; #3 r_addr=`CPU_width'h21;
        #13 we=0;
        #23 we=1; #23 r_addr=`CPU_width'h21; #23 i_addr=`I_imme'h33; #23 mix=1;
        #33 we=0;
        #43 we=1; #43 i_addr=`I_imme'hffff; #43 mix=1;
        #53 we=0;
        forever #5 clk = ~clk;
    join
endmodule
