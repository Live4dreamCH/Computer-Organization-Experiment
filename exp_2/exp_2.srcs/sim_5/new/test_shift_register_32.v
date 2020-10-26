`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/26 17:48:53
// Design Name: 
// Module Name: test_shift_register_32
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


module test_shift_register_32(
    );
    //类似寄存器测试模块
    wire [31:0] data_bus_out;
    wire [31:0] data_bus;
    reg [31:0] data_bus_in=0;
    reg en=1, clear=0, io=0, clk=0, is_left=1'bx;
    wire carry_bit;
    shift_register_32 sr32(data_bus, en, clear, io, clk, is_left, carry_bit);

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
