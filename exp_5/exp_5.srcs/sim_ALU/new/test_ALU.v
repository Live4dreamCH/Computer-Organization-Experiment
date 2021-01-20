`timescale 1ns / 1ps
//`include "Constants.vh"

module test_ALU();
    reg clk=0, en=1, we=0;
    reg[`alu_op_width-1 :0] alu_op;
    reg[`CPU_width-1 :0] in1, in2;
    reg[`I_imme-1 :0] in_imme;

    wire[`CPU_width-1 :0] out;
    wire eq;

    ALU alu(clk, en, we, alu_op, in1, in2, out, eq, in_imme);
    initial begin
        #3

        in1=32'h21861141;
        in2=32'hffffffff;
        in_imme=16'hfffe;

        we=1;
        alu_op = `alu_add;
        #10
        we=0;
        #10

        we=1;
        alu_op = `alu_addi;
        #10
        we=0;
        #10

        we=1;
        alu_op = `alu_sub;
        #10
        we=0;
        #10

        we=1;
        alu_op = `alu_and;
        #10
        we=0;
        #10

        we=1;
        alu_op = `alu_andi;
        #10
        we=0;
        #10

        we=1;
        alu_op = `alu_less;
        #10
        we=0;
        #10

        in2=32'h00002186;
        in1=32'hffffffff;
        we=1;
        alu_op = `alu_less;
        #10
        we=0;
        #10

        in1=32'h21861141;
        in2=32'h21861141;
        we=1;
        alu_op = `alu_sub;
        #10
        we=0;
        #10
        
        $finish;
    end

    initial begin
        forever #5 clk = ~clk;
    end
endmodule
