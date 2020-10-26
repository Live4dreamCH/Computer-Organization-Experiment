`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/26 18:35:43
// Design Name: 
// Module Name: ano_test_shift_register_32
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


module ano_test_shift_register_32(
    );
    //测试移位功能
    wire [31:0] data_bus_out;
    wire [31:0] data_bus;
    reg [31:0] data_bus_in=32'b10110010111000101111000010111110;
    reg en=1, clear=0, io=1, clk=0, is_left=1'bx;
    wire carry_bit;
    shift_register_32 sr32(data_bus, en, clear, io, clk, is_left, carry_bit);

    assign data_bus = (io) ? data_bus_in : 32'bz;
    assign data_bus_out = !(io) ? data_bus : 32'bz;
    initial fork
        #10 io = 0;
        #10 is_left = 1;
        #330 is_left = 0;
        forever #5 clk = ~clk;
    join
endmodule
