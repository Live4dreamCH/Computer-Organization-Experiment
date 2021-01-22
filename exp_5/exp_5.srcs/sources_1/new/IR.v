`timescale 1ns / 1ps
`include "Constants.vh"

//IR 指令寄存器
//将MIPS指令中的op与func译码成内部op,提交给CU, 并提供数据给RF ALU等
//instr 32位的指令,从MDR来
//op 输出CPU片内操作码至CU, 5位
//J, I, rs, rt, rd 立即数及寄存器地址, 供数据通路下游使用
//is_rt 因为rt与rd都需要连至RF输入端, 所以需要选择一路信号通过. =1则选择rt
//imme 输出的J与I可能与RF的输出冲突, 故仅当imme=1时才输出J,I
module IR(clk, en, we, instr, op, J, I, rs, rt, rd, is_rt, imme);
    input clk, en, we, is_rt, imme;
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
    reg[1:0] counter=2'b11; //延迟发送

    //输出
    assign op = (we==0 && en==1) ? reg_op : `op_width'bz;
    assign J = (we==0 && en==1 && imme==1) ? reg_J : `J_imme'bz;
    assign I = (we==0 && en==1 && imme==1) ? reg_I : `I_imme'bz;
    assign rs = (we==0 && en==1) ? reg_rs : `R_addr_width'bz;
    assign rt = (we==0 && en==1 && is_rt==1) ? reg_rt : `R_addr_width'bz;
    assign rd = (we==0 && en==1 && is_rt==0) ? reg_rd : `R_addr_width'bz;

    always @(posedge clk) begin
        if (counter==0) begin
            //数值备份转移
            reg_J = reg_instr[`J_imme-1 :0];
            reg_I = reg_instr[`I_imme-1 :0];
            reg_rs = reg_instr[`J_imme-1 : `J_imme-5];
            reg_rt = reg_instr[`J_imme-6 : `J_imme-10];
            reg_rd = reg_instr[`J_imme-11 : `J_imme-15];
        end
        if (counter) begin
            counter=counter-1;
        end else begin
            counter=2'b11;
        end
        if(en && we) begin
            //译码生成op
            case (instr[`CPU_width-1 : `J_imme])
                `OP_Rtype: begin
                    case (instr[`func_width-1 : 0])
                        `func_add: reg_op = `op_add;
                        `func_sub: reg_op = `op_sub;
                        `func_and: reg_op = `op_and;
                        `func_or: reg_op = `op_or;
                        `func_xor: reg_op = `op_xor;
                        `func_nop: reg_op = `op_nop;
                        `func_sltu: reg_op = `op_less;
                        default: reg_op = `op_nop;
                    endcase
                end
                `OP_addi: reg_op = `op_addi;
                `OP_andi: reg_op = `op_andi;
                `OP_ori: reg_op = `op_ori;
                `OP_lw: reg_op = `op_lw;
                `OP_sw: reg_op = `op_sw;
                `OP_beq: reg_op = `op_beq;
                `OP_bne: reg_op = `op_bne;
                `OP_j: reg_op = `op_bne;
                default: reg_op = `op_nop;
            endcase

            //MAR->IR, 写入新指令
            reg_instr = instr;
        end
    end
endmodule
