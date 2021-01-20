`timescale 1ns / 1ps
//`include "Constants.vh"

module test_CPU();
    //CU的第一个上升沿在#5, 数据通路的第一个上升沿在#10
    reg clk=1, en=1;
    //clk初值为0也没关系, 只是:
    //#5时数据通路上升沿但全无使能
    //#10时CU第一个上升沿
    //#15时数据通路在CU的控制下开始第一次正常工作
    //仅此而已, 效果一样, 略微浪费仿真时间(#5)

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
