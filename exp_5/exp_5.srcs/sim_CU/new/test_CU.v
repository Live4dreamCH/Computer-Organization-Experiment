`timescale 1ns / 1ps
//`include "Constants.vh"

module test_CU();
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

    reg[`op_width-1 :0] IR_op=0;
    reg ALU_eq=0;

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
//$monitor("time = ", $time, ", uIR[0] = ", cu.uIR[0], ", uIR[1] = ", cu.uIR[1], ", uIR[2] = ", cu.uIR[2]);
// test1:
// #50
// IR_op=`op_lw;
// #40

// IR_op=`op_lw;
// #40

// IR_op=`op_lw;
// #40

// IR_op=`op_lw;
// #40

// IR_op=`op_lw;
// #40

// IR_op=`op_sub;
// #40

// IR_op=`op_addi;
// #40

// IR_op=`op_sw;
// #40

// IR_op=`op_sw;
// #40

// IR_op=`op_sw;
// #40

// IR_op=`op_sw;
// #40

// IR_op=`op_nop;
// #40

// IR_op=`op_nop;
// #40

// IR_op=`op_nop;
// #40

        #50
        IR_op=`op_lw;
        #40

        IR_op=`op_lw;
        #40

        IR_op=`op_nop;
        #40

        IR_op=`op_nop;
        #40

        IR_op=`op_lw;
        #40

        IR_op=`op_add;
        #40

        IR_op=`op_nop;
        #40

        IR_op=`op_and;
        #40

        IR_op=`op_less;
        #40

        IR_op=`op_addi;
        #40

        IR_op=`op_sw;
        #40

        IR_op=`op_sw;
        #40

        IR_op=`op_nop;
        #40

        IR_op=`op_nop;
        #40

        IR_op=`op_lw;
        #40

        IR_op=`op_lw;
        #40

        IR_op=`op_nop;
        #40

        IR_op=`op_nop;
        #40
        
        IR_op=`op_andi;
        #40
        
        IR_op=`op_beq;
        #40
        
        IR_op=`op_add;
        #10
        ALU_eq=1;
        #10
        ALU_eq=0;
        #20

        IR_op=`op_nop;
        #40
        
        IR_op=`op_sub;
        #40
        
        IR_op=`op_j;
        #40
        
        IR_op=`op_nop;
        #40
        
        IR_op=`op_nop;
        #40
        
        IR_op=`op_xor;
        #40
        
        IR_op=`op_sw;
        #40
        
        IR_op=`op_sw;
        #40
        
        IR_op=`op_nop;
        #40
        
        IR_op=`op_nop;
        #40
        
        IR_op=`op_sw;
        #40
        
        IR_op=`op_nop;
        #40
        //nop continue......
        
        wait(halt) begin
            $display($time, " halt signal set!");
            $finish;
        end
    end

    initial begin
        forever begin 
            #5 clk=~clk;
        end
    end
endmodule
