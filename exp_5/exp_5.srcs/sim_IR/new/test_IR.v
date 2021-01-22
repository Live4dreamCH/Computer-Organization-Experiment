`timescale 1ns / 1ps
//`include "Constants.vh"

module test_IR();
    reg clk=0, en=0, we=0, is_rt=1, imme=1;
    reg[`CPU_width-1:0] instr=`CPU_width'bx;

    wire[`op_width-1 :0] op;
    wire[`J_imme-1 :0] J;
    wire[`I_imme-1 :0] I;
    wire[`R_addr_width-1 :0] rs, rt, rd;

    IR ir(clk, en, we, instr, op, J, I, rs, rt, rd, is_rt, imme);

    initial begin
        #35
        en=1;
        we=1;
        instr = {`OP_Rtype, 5'd2, 5'd3, 5'd1, 5'd0, `func_add};
        #10
        we=0;
        #10
        is_rt = 0;
        #20

        we=1;
        en=0;
        instr = {`OP_Rtype, 5'd5, 5'd6, 5'd4, 5'd0, `func_xor};
        #10
        en=1;
        we=0;
        is_rt = 1;
        #10
        is_rt = 0;
        #20

        we=1;
        instr = {`OP_lw, 5'd1, 5'd7, 16'd12};
        #10
        we=0;
        is_rt = 1;
        #30
        
        we=1;
        instr = 32'd0;
        #10
        we=0;
        is_rt = 1;
        #10
        is_rt = 0;
        #20

        we=1;
        instr = 32'd0;
        #10
        we=0;
        is_rt = 1;
        #10
        is_rt = 0;
        #20

        imme=0;
        #40
        $finish;
    end

    initial begin
        forever #5 clk = ~clk;
    end

    // $finish
    // always fork
    //     #3 we=1; #3 instr=`CPU_width'h21;
    //     #13 we=0;
    //     #23 we=1; #23 r_addr=`CPU_width'h21; #23 i_addr=`I_imme'h33; #23 mix=1;
    //     #33 we=0;
    //     #43 we=1; #43 i_addr=`I_imme'hffff; #43 mix=1;
    //     #53 we=0;
    //     forever #5 clk = ~clk;
    // join
endmodule
