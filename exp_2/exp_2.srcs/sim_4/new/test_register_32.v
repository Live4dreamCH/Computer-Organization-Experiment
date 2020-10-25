`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/25 14:38:42
// Design Name: 
// Module Name: test_register_32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_register_32(
    );
    //由于待测模块中有一个inout类型的端口, 测试比较复杂:
    //用wire型的data_bus连接待测模块的这个端口
    //用io的值选择data_bus在待测模块外面如何连接:
    //io=1, 此时应该向寄存器写入数据, 将data_bus_in连接到data_bus, 并在always中不断改变data_bus_in的值(所以data_bus_in是reg类型)
    //io=0, 此时应该从寄存器内读取数据, 则将data_bus连接到data_bus_out, 用以在波形中更好的展示输入输出结果
    wire [31:0] data_bus_out;
    wire [31:0] data_bus;
    reg [31:0] data_bus_in=0;
    reg en=1, clear=0, io=0, clk=0;
    register_32 r32(data_bus, en, clear, io, clk);

    assign data_bus = (io) ? data_bus_in : 32'bz;
    assign data_bus_out = !(io) ? data_bus : 32'bz;
    always begin
        #4
        clk = 1;
        #1
        clk = 0;
        #4
        data_bus_in = data_bus_in + 1;
        #1
        {en, clear, io} = {en, clear, io} + 1;
        // io = ~io;
    end
endmodule
