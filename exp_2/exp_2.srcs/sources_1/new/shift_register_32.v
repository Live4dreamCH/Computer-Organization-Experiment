`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/22 15:40:55
// Design Name: 
// Module Name: shift_register_32
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


module shift_register_32(
    data_bus,
    en,
    clear,
    io,
    clk,
    is_left,    //是否左移,左移为1,右移为0,不移动为z(位31在最左而位0在最右,与代码一致)
    carry_bit   //循环移位时, 将移位暂时溢出的一位通过carry_bit输出(并回送到另一端)
    );
    //双向32位循环移位寄存器, 循环移位时可输出溢出位
    //除循环移位功能外, 其余与一般寄存器一致
    //上升沿有可能同时发生输入(或复位,属于输入的特例)与移位两个操作,规定先输入,再对输入的值进行移位
    //使能后,操作优先级:io=0(输出) >= clear > io=1(输入) > is_left!=z(移位)
    //carry_bit会被复位为0; 只要en使能,carry_bit就会持续输出,否则输出不定
    inout [31:0] data_bus;
    input en, clear, io, clk, is_left;
    output carry_bit;
    reg [31:0] inner_data;
    reg carry_reg;

    assign data_bus = (io==0 && en==1) ? inner_data : 32'bz;    //输出data
    assign carry_bit = en ? carry_reg : 1'bx;                   //输出carry_bit
    always @(posedge clk) begin
        if (en) begin
            if (clear) begin
                inner_data = 32'b0; //复位
                carry_reg = 1'b0;
            end else begin
                if (io) begin
                    inner_data = data_bus;  //输入
                end
            end
            if (is_left==1) begin
                {carry_reg, inner_data} = inner_data << 1;
                inner_data[0] = carry_reg;
            end
            if (is_left==0) begin
                carry_reg = inner_data[0];
                inner_data = inner_data >> 1;
                inner_data[31] = carry_reg;
            end
        end
    end
endmodule
