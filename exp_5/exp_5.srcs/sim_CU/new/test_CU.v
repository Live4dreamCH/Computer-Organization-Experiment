`timescale 1ns / 1ps
//`include "Constants.vh"

module test_ALU();
    reg clk=0, en=1;
    wire halt;

    wire PC_en, PC_we, PC_add4,
    MAR_en, MAR_we, MAR_mix,
    Mem_en, Mem_we,
    MDR_en, MDR_we,
    IR_en, IR_we, IR_is_rt, IR_imme,
    RF_en, RF_we,
    ALU_en, ALU_we;
    wire[1:0] PC_type;
    wire[`alu_op_width-1 :0] ALU_op;

    reg[`op_width-1 :0] IR_op;
    reg ALU_eq;

    CU cu(clk, en, halt,
        PC_en, PC_we, PC_add4, PC_type,
        MAR_en, MAR_we, MAR_mix,
        Mem_en, Mem_we,
        MDR_en, MDR_we,
        IR_en, IR_we, IR_is_rt, IR_imme,
        RF_en, RF_we,
        ALU_en, ALU_we, ALU_op,

        IR_op, ALU_eq
        );
    
    initial begin
        // #3

        // in1=32'h00002186;
        // in2=32'hffffffff;
        // we=1;
        // alu_op = `alu_add;
        // #10
        // we=0;
        // #10

        // we=1;
        // alu_op = `alu_sub;
        // #10
        // we=0;
        // #10

        // we=1;
        // alu_op = `alu_less;
        // #10
        // we=0;
        // #10

        // in2=32'h00002186;
        // in1=32'hffffffff;
        // we=1;
        // alu_op = `alu_less;
        // #10
        // we=0;
        // #10

        // in1=32'h21861141;
        // in2=32'h21861141;
        // we=1;
        // alu_op = `alu_sub;
        // #10
        // we=0;
        // #10
        
        #100
        $finish;
    end

    initial begin
        #3 forever begin 
            clk=~clk; 
            #5 ;
        end
    end
endmodule
