`timescale 1ns / 1ps
`include "Constants.vh"

//ALU 一个简单的算术逻辑单元,其中eq表示运算结果是否为0, 是则eq=1
module ALU(clk, en, we, alu_op, in1, in2, out, eq);
    input clk, en, we;
    input[`alu_op_width-1 :0] alu_op;
    input[`CPU_width-1 :0] in1, in2;

    output[`CPU_width-1 :0] out;
    output eq;

    reg[`CPU_width-1 :0] result;
    wire is_zero;

    assign out = (en && !we) ? result : `CPU_width'bz;
    assign eq = (en && !we) ? is_zero : 1'bz;
    assign is_zero = (!result) ? 1'b1 : 1'b0;

    always @(posedge clk) begin
        if (en && we) begin
            case (alu_op)
                `alu_l: result = in1; 
                `alu_r: result = in2; 
                `alu_add: result = in1 + in2; 
                `alu_sub: result = in1 - in2; 
                `alu_and: result = in1 & in2; 
                `alu_or: result = in1 | in2; 
                `alu_xor: result = in1 ^ in2; 
                `alu_less: result = in1 < in2; 
                //default: 
            endcase
        end
    end
endmodule
