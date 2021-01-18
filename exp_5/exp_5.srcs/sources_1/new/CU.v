`timescale 1ns / 1ps
`include "Constants.vh"
`define uAddr_IRop 6'b000101
`define uAddr_ALUeq 6'b011001

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
    reg[3:0] nop_counter[0:2], nop_counter_backup[0:2];
    reg[`CM_addr_width-1 :0] nop_back_addr[0:2];
    reg[`CM_op_width-1 :0] reg_or, reg_and;
    reg[`CM_op_width+`CM_addr_width-1 :0] temp0, temp1, temp2;
    reg reg_halt, halt0=0, halt1=0, halt2=0;
    reg[1:0] in0, in1, in2;
    
    assign {ALU_op[`alu_op_width-1 :0], ALU_we, ALU_en, RF_we, RF_en, IR_imme, IR_is_rt, IR_we, IR_en, MDR_we, MDR_en, Mem_we, Mem_en, MAR_mix, MAR_we, MAR_en, PC_type[1:0], PC_add4, PC_we, PC_en}=
    (en) ? reg_or : `CM_op_width'b0;
    assign halt = (en) ? reg_halt : 1'bz;

    initial begin
        $readmemb("E:\\CPU\\exp_5\\exp_5.srcs\\sources_1\\new\\CM_op_addr.txt", CM);
        uIR[0]=1;
        uIR[1]=0;
        uIR[2]=0;
        nop_counter[0]=0;
        nop_counter[1]=3;
        nop_counter[2]=7;
        nop_counter_backup[0]=0;
        nop_counter_backup[1]=0;
        nop_counter_backup[2]=0;
        nop_back_addr[0]=1;
        nop_back_addr[1]=1;
        nop_back_addr[2]=1;
        reg_or=0;
        reg_and=0;
        temp0=0;
        temp1=0;
        temp2=0;
        reg_halt=0;
        in0=0;
        in1=0;
        in2=0;
    end

    always @(posedge clk) begin
        if (en) begin
            //接收输入
            if(in0==1)begin
                case (IR_op)
                    `op_nop:begin
                        
                    end 
                    default: 
                endcase
            end
            if(in0==2)begin
                ;
            end

            //下次就接收输入信号
            case (uIR[0])
                `uAddr_IRop: begin
                    in0=1;
                    nop_counter[0] = 2;
                end
                `uAddr_ALUeq: in0=2;
                default: in0=0;
            endcase

            //uOP的获取
            temp0=CM[uIR[0]];
            temp1=CM[uIR[1]];
            temp2=CM[uIR[2]];

            //uIR的改变
            if (!uIR[0]) begin
                if(nop_counter[0]) begin
                    nop_counter[0]=nop_counter[0]-1;
                end
                else begin
                    uIR[0]=nop_back_addr[0];
                    if(nop_counter_backup[0]!=0)begin
                        nop_counter[0]<=nop_counter_backup[0];
                        nop_counter_backup[0]<=0;
                        nop_back_addr[0]<=1;
                    end
                end
            end
            else begin
                uIR[0]=temp0[`CM_addr_width-1 :0];
            end
            // if (!uIR[1]) begin
            //     if(nop_counter[1]) begin
            //         nop_counter[1]=nop_counter[1]-1;
            //     end
            //     else begin
            //         uIR[1]=nop_back_addr[1];
            //         if(nop_counter_backup[1]!=0)begin
            //             nop_counter[1]<=nop_counter_backup[1];
            //             nop_counter_backup[1]<=0;
            //             nop_back_addr[1]<=1;
            //         end
            //     end
            // end
            // else begin
            //     uIR[1]=temp1[`CM_addr_width-1 :0];
            // end
            // if (!uIR[2]) begin
            //     if(nop_counter[2]) begin
            //         nop_counter[2]=nop_counter[2]-1;
            //     end
            //     else begin
            //         uIR[2]=nop_back_addr[2];
            //         if(nop_counter_backup[2]!=0)begin
            //             nop_counter[2]<=nop_counter_backup[2];
            //             nop_counter_backup[2]<=0;
            //             nop_back_addr[2]<=1;
            //         end
            //     end
            // end
            // else begin
            //     uIR[2]=temp2[`CM_addr_width-1 :0];
            // end

            //变换输出控制信号
            reg_and = temp0[`CM_op_width+`CM_addr_width-1 : `CM_addr_width] & temp1[`CM_op_width+`CM_addr_width-1 : `CM_addr_width] & temp0[`CM_op_width+`CM_addr_width-1 : `CM_addr_width];
            if(reg_and)begin
                $display("conflict appear at uOP!");
                $stop;
            end
            reg_or = temp0[`CM_op_width+`CM_addr_width-1 : `CM_addr_width] | temp1[`CM_op_width+`CM_addr_width-1 : `CM_addr_width] | temp0[`CM_op_width+`CM_addr_width-1 : `CM_addr_width];
        end
    end
endmodule
