`timescale 1ns / 1ps
//`include "Constants.vh"

module test_CPU();
    reg clk=0, en=1;

    tri[`CPU_width-1 :0] addr, data;
    tri halt, mreq, rw;

    CPU cpu(clk, en, halt, mreq, rw, addr, data);
    Memory memory(data, addr, mreq, rw, clk);
    initial begin
        // #3

        // in1=32'h00002186;
        // in2=32'hffffffff;
        // we=1;
        // alu_op = `alu_add;
        // #10
        // we=0;
        // #10

        // we=1;
        // alu_op = `alu_sub;
        // #10
        // we=0;
        // #10

        // we=1;
        // alu_op = `alu_less;
        // #10
        // we=0;
        // #10

        // in2=32'h00002186;
        // in1=32'hffffffff;
        // we=1;
        // alu_op = `alu_less;
        // #10
        // we=0;
        // #10

        // in1=32'h21861141;
        // in2=32'h21861141;
        // we=1;
        // alu_op = `alu_sub;
        // #10
        // we=0;
        // #10
        
        #100
        $finish;
    end

    initial begin
        forever #5 clk = ~clk;
    end
    
    always @(posedge halt) begin
        $finish;
    end
endmodule
