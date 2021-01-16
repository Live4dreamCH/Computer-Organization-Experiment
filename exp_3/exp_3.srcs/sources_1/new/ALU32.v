`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/15 11:25:54
// Design Name: 
// Module Name: ALU32
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

// operation:
// 1: out = in1 + in2
// 2: out = in1 - in2
// 3: out = in1 * in2
// 4: out = in1 / in2
// 5: out = in1 % in2

// 6: out = not in1
// 7: out = in1 and in2
// 8: out = in1 or in2
// 9: out = in1 xor in2
// 10: out = in1 nxor in2

// 11: out = in1 << in2
// 12: out = in1 >> in2

// 13: out = in1 > in2
// 14: out = in1 < in2
// 15: out = in1 === in2
module ALU32(
    clk,
    operation,
    in1,
    in2,
    out
    );
    parameter op_len = 4;

    input clk;
    input[op_len-1:0] operation;
    input[31:0] in1, in2;

    output[31:0] out;
    reg[31:0] out;

    wire[31:0] sum;
    wire carry;
    FullAdder32 fa32(in1, in2, carry, sum);
    always @(posedge clk) begin
        case (operation)
            1: out = sum;
            2: out = in1 - in2;
            3: out = in1 * in2;
            4: out = in1 / in2;
            5: out = in1 % in2;

            6: out = ~ in1;
            7: out = in1 & in2;
            8: out = in1 | in2;
            9: out = in1 ^ in2;
            10: out = in1 ~^ in2;

            11: out = in1 << in2;
            12: out = in1 >> in2;

            13: out = in1 > in2;
            14: out = in1 < in2;
            15: out = in1 === in2;

            default: out = 32'bz;
        endcase
    end
endmodule
