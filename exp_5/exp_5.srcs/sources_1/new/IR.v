`timescale 1ns / 1ps
`include "Constants.vh"

//IR 指令寄存器
//将MIPS指令中的op与func译码成内部op,提交给CU, 并提供数据给RF ALU等
module IR(clk, en, we, instr, op, J, I, rs, rt, rd);
    input clk, en, we;
    input[`CPU_width-1 :0] instr;

    output[`op_width-1 :0] op;
    output[`J_imme-1 :0] J;
    output[`I_imme-1 :0] I;
    output[`R_addr_width-1 :0] rs, rt, rd;

    reg[`CPU_width-1 :0] reg_instr;

    reg[`op_width-1 :0] reg_op;
    reg[`J_imme-1 :0] reg_J;
    reg[`I_imme-1 :0] reg_I;
    reg[`R_addr_width-1 :0] reg_rs, reg_rt, reg_rd;

    //输出
    assign op = (we==0 && en==1) ? reg_op : `op_width'bz;
    assign J = (we==0 && en==1) ? reg_J : `J_imme'bz;
    assign I = (we==0 && en==1) ? reg_I : `I_imme'bz;
    assign rs = (we==0 && en==1) ? reg_rs : `R_addr_width'bz;
    assign rt = (we==0 && en==1) ? reg_rt : `R_addr_width'bz;
    assign rd = (we==0 && en==1) ? reg_rd : `R_addr_width'bz;

    always @(posedge clk) begin
        if(en && we) begin
            //译码生成op
            case (instr[`CPU_width-1 : `J_imme])
                `OP_Rtype: begin
                    case (instr[`func_width-1 : 0])
                        `func_add: reg_op = 
                        default: 
                    endcase
                end
            endcase

            //数值备份转移
            reg_J = reg_instr[`J_imme-1 :0];
            reg_I = reg_instr[`I_imme-1 :0];
            reg_rs = reg_instr[`J_imme-1 : `J_imme-5];
            reg_rt = reg_instr[`J_imme-6 : `J_imme-10];
            reg_rd = reg_instr[`J_imme-11 : `J_imme-15];

            //MAR->IR, 写入新指令
            reg_instr = instr;
        end
    end
endmodule
