`timescale 1ns / 1ps
//`include "Constants.vh"

module test_PC();
    reg clk=0, add4=0, en=1, we=0;
    reg[`J_imme-1:0] imme=0;
    wire[`CPU_width-1:0] addr;
    reg[1:0] type=2'b00;
    PC pc(clk, add4, en, imme, we, addr, type);
    always fork
        #13 add4=1;
        #43 we=1; #43 imme=`J_imme'h21;
        #53 en=0;
        #63 we=0; #63 add4=0;
        #73 en=1;
        #93 add4=1;
        #113 add4=0; #113 we=1; #113 imme=`I_imme'hffff; #113 type=2'b01;
        #123 we=0;
        forever #5 clk = ~clk;
    join
endmodule
