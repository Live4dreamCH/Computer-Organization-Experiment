`timescale 1ns / 1ps
`include "Constants.vh"

//CU 控制单元
module CU(clk, en, halt,
    PC_en, PC_we, PC_add4, PC_type,
    MAR_en, MAR_we, MAR_mix,
    Mem_en, Mem_we,
    MDR_en, MDR_we,
    IR_en, IR_we, IR_is_rt, IR_imme,
    RF_en, RF_we,
    ALU_en, ALU_we, ALU_op,

    IR_op, ALU_eq
    );
    input clk, en;
    output halt;

    output PC_en, PC_we, PC_add4,
    MAR_en, MAR_we, MAR_mix,
    Mem_en, Mem_we,
    MDR_en, MDR_we,
    IR_en, IR_we, IR_is_rt, IR_imme,
    RF_en, RF_we,
    ALU_en, ALU_we;
    output[1:0] PC_type;
    output[`alu_op_width-1 :0] ALU_op;

    input[`op_width-1 :0] IR_op;
    input ALU_eq;

    reg[`CM_op_width+`CM_addr_width-1 :0] CM[0: `CM_length-1];
    reg[`CM_addr_width-1 :0] uIR[0:2];
    reg[3:0] nop_counter[0:2];
    reg[`CM_addr_width-1 :0] nop_back_addr[0:2];
    reg[`CM_op_width-1 :0] reg_out;
    
    assign {ALU_op[`alu_op_width-1 :0], ALU_we, ALU_en, RF_we, RF_en, IR_imme, IR_is_rt, IR_we, IR_en, MDR_we, MDR_en, Mem_we, Mem_en, MAR_mix, MAR_we, MAR_en, PC_type[1:0], PC_add4, PC_we, PC_en}=
    (en) ? reg_out : `CM_op_width'b0;

    initial begin
        $readmemb("E:\\CPU\\exp_5\\exp_5.srcs\\sources_1\\new\\CM_op_addr.txt", CM);
        uIR[0]=0;
        uIR[1]=0;
        uIR[2]=0;
        nop_counter[0]=0;
        nop_counter[1]=0;
        nop_counter[2]=0;
        nop_back_addr[0]=0;
        nop_back_addr[1]=0;
        nop_back_addr[2]=0;
        reg_out=0;
    end

    always @(posedge clk) begin
        ;
    end
endmodule
