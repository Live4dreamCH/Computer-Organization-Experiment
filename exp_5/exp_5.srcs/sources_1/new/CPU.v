`timescale 1ns / 1ps
`include "Constants.vh"

//CPU 不含主存(但含MAR与MDR)的中央处理器
module CPU(clk, en, halt, mreq, rw, addr, data);
    //端口
    input clk, en;
    output halt, mreq, rw;
    output[`CPU_width-1 :0] addr;
    inout[`CPU_width-1 :0] data;

    tri clk, en;
    tri halt, mreq, rw;
    tri[`CPU_width-1 :0] addr;
    tri[`CPU_width-1 :0] data;

    //CU
    tri cu_clk;
    assign cu_clk = ~clk;

    tri PC_en, PC_we, PC_add4,
        MAR_en, MAR_we, MAR_mix,
        MDR_en,
        IR_en, IR_we, IR_is_rt, IR_imme,
        RF_en, RF_we,
        ALU_en, ALU_we;
    tri[1:0] PC_type, MDR_we;
    tri[`alu_op_width-1 :0] ALU_op;

    tri[`op_width-1 :0] IR_op;
    tri ALU_eq;

    CU cu(cu_clk, en, halt,
        PC_en, PC_we, PC_add4, PC_type,
        MAR_en, MAR_we, MAR_mix,
        mreq, rw,
        MDR_en, MDR_we,
        IR_en, IR_we, IR_is_rt, IR_imme,
        RF_en, RF_we,
        ALU_en, ALU_we, ALU_op,

        IR_op, ALU_eq
        );
    
    //PC
    tri[`J_imme-1 :0] J_imme;
    tri[`CPU_width-1 :0] PCo_MARi;
    PC pc(clk, PC_add4, PC_en, J_imme, PC_we, PCo_MARi, PC_type);

    //MAR
    tri[`CPU_width-1 :0] MDRo_ALUo_RFi_IRi, RFo1_ALUi1_MARir, RFo2_ALUi2_MDRi;
    tri[`I_imme-1 :0] I_imme;
    MAR mar(clk, MAR_en, MAR_mix, MAR_we, PCo_MARi, I_imme, addr, RFo1_ALUi1_MARir);

    //MDR
    MDR mdr(clk, MDR_en, MDR_we, data, RFo2_ALUi2_MDRi, MDRo_ALUo_RFi_IRi);

    //IR
    tri[`R_addr_width-1 :0] rs_addr, rt_rd_addr;
    IR ir(clk, IR_en, IR_we, MDRo_ALUo_RFi_IRi, IR_op, J_imme, I_imme, rs_addr, rt_rd_addr, rt_rd_addr, IR_is_rt, IR_imme);

    //RF
    //assign MDRo_ALUo_RFi_IRi = data;
    //assign PCo_MARi = RFo1_ALUi1_MARir;
    //assign data = RFo2_ALUi2_MDRi;
    //assign RFo2_ALUi2_MDRi = {16'b0, I_imme[`I_imme-1 :0]};
    RF rf(clk, RF_en, RF_we, rt_rd_addr, rs_addr, rt_rd_addr, MDRo_ALUo_RFi_IRi, RFo1_ALUi1_MARir, RFo2_ALUi2_MDRi);

    //ALU
    ALU alu(clk, ALU_en, ALU_we, ALU_op, RFo1_ALUi1_MARir, RFo2_ALUi2_MDRi, MDRo_ALUo_RFi_IRi, ALU_eq, I_imme);
endmodule
