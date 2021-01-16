`timescale 1ns / 1ps

module test_mem();
    //由于待测模块中有一个inout类型的端口, 测试比较复杂:
    //用wire型的data连接待测模块的这个端口
    //用io的值选择data在待测模块外面如何连接:
    //io=1, 此时应该向寄存器写入数据, 将data_write连接到data, 并在always中不断改变data_write的值(所以data_write是reg类型)
    //io=0, 此时应该从寄存器内读取数据, 则将data连接到data_read, 用以在波形中更好的展示输入输出结果
    wire [31:0] data_read;
    wire [31:0] data;
    reg [31:0] data_write=0;
    reg [7:0] addr=0;
    reg en=1, io=1, clk=0;
    memory mem(
    data,
    addr,
    en,
    io,
    clk
    );

    assign data = (io) ? data_write : 32'bz;
    assign data_read = !(io) ? data : 32'bz;
    always fork
        #3 addr=0; #3 data_write=32'h21;
        #13 addr=2; #13 data_write=32'h86;
        #23 addr=4; #23 data_write=32'h11;
        #33 addr=6; #33 data_write=32'h41;
        #43 addr=246; #43 data_write=32'h47;
        #53 io=0;
        #53 addr=0;
        #63 addr=2;
        #73 addr=4;
        #83 addr=6;
        #93 addr=246;
        forever #5 clk = ~clk;
    join

endmodule
