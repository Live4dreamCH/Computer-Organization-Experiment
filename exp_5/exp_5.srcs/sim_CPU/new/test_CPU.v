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
    
    integer i=0, n=9, base=32'hf0;

    CPU cpu(clk, en, halt, mreq, rw, addr, data);
    Memory memory(data, addr, mreq, rw, clk);

    initial begin
        $display("before:");
        for(i=0; i<n; i=i+1) begin
            $write("%h ", memory.memory_bank[base+i]);
        end
        $display("\n");
        wait(halt) begin
            #20
            $display("\ntime = ", $time, ", halt signal set!");
            $display("after:");
            for(i=0; i<n; i=i+1)begin
                $write("%h ", memory.memory_bank[base+i]);
            end
            $display("\n");
            $finish;
        end
    end

    initial begin
        forever #5 clk = ~clk;
    end
endmodule
