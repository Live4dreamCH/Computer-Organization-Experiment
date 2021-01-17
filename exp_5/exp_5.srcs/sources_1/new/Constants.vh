//各种宽度
`define J_imme 26
`define CPU_width 32
`define I_imme 16
    //CPU内操作码宽度
`define op_width 5
    //RF寄存器数量, 及地址宽度
`define RF_num 32
`define R_addr_width 5
    //R-type中的func码宽度
`define func_width 6
`define alu_op_width 4

//MIPS中的OP
`define OP_Rtype 6'b000000
`define OP_addi 6'b001000
`define OP_andi 6'b001100
`define OP_ori 6'b001101
`define OP_lw 6'b100011
`define OP_sw 6'b101011
`define OP_beq 6'b000100
`define OP_bne 6'b000101
`define OP_j 6'b000010

//MIPS R-type中的func
`define func_add 6'b100000
`define func_sub 6'b100010
`define func_and 6'b100100
`define func_or 6'b100101
`define func_xor 6'b100110

//CPU内部op
    //空指令
`define op_nop 5'd0

    //R-type
`define op_add 5'd1
`define op_sub 5'd2
`define op_and 5'd3
`define op_or 5'd4
`define op_xor 5'd5

    //I-type
`define op_addi 5'd20
`define op_andi 5'd21
`define op_ori 5'd22
`define op_lw 5'd23
`define op_sw 5'd24
`define op_beq 5'd25
`define op_bne 5'd26

    //J-type
`define op_j 5'd29

//控制ALU的alu_op
`define alu_l 4'd0
`define alu_r 4'd1

`define alu_add 4'd2
`define alu_sub 4'd3

`define alu_and 4'd4
`define alu_or 4'd5
`define alu_xor 4'd6

`define alu_less 4'd7
