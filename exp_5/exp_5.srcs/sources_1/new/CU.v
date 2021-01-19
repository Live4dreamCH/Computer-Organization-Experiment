`timescale 1ns / 1ps
`include "Constants.vh"
`define uAddr_IRop 6'b000101
`define uAddr_ALUeq 6'b011001
`define uAddr_Beq 6'b011010

//CU 控制单元
//使用微指令方式(时序电路)
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

    //控制存储器, 其格式为op_addr
    //op为控制信号所组成的向量, addr指向下一条微指令在CM中的地址
    reg[`CM_op_width+`CM_addr_width-1 :0] CM[0: `CM_length-1];
    //3个地址寄存器, 保存下一条要执行的微指令的地址
    reg[`CM_addr_width-1 :0] uIR[0:2];
    //由于微指令nop的addr指向它自己, 是死循环, 要退出必然要添加计数器
    //在译码后,有三个周期的空闲;之后跳转到译码所得的指令执行;执行后又有长度不一的空闲
    //所以需要两组计数寄存器,分别存储这两个计数
    reg[3:0] nop_counter[0:2], nop_counter_backup[0:2];
    //nop计数完毕后需要跳转到预设好的指令, 此寄存器组即保存跳转地址
    reg[`CM_addr_width-1 :0] nop_back_addr[0:2];
    //3个微指令同时执行, CU发出的控制信号应当"或"后发出, 即reg_or;
    //若流水无冲突, "与"操作后应该为全0, reg_and用于检测部件争用
    reg[`CM_op_width-1 :0] reg_or, reg_and;
    //由于verilog语法中不允许对寄存器组中的某一字做位操作, 故使用3个字来暂存CM内容
    reg[`CM_op_width+`CM_addr_width-1 :0] temp0, temp1, temp2;
    //CPU执行所有指令完毕后, 应当能够停机, reg_halt向外输出停机信号
    //由于流水, 最先的流水执行完成所有指令后, 还有2条指令未完全执行, 需"等待"它们完成
    //所以设置3个halt寄存器, 用于三者的同步(类似多线程同步结束)
    reg reg_halt, halt0=0, halt1=0, halt2=0;
    //CU向IR发送译码控制信号后, 或在Beq/ne中向ALU发送-信号后, 需要在下一上升沿才能读取输入值
    //所以用这三个寄存器"记忆"这一需求至下一上升沿
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
            //接收输入, 改变状态, 若发生冒险,有权修改其它流水的寄存器
            //接收IR_op, 设置nop_counter_backup, nop_back_addr, inx
            if(in0==1)begin
                case (IR_op)
                    `op_nop:begin
                        //译码没有得到结果, 应停机
                        //设置halt寄存器, 设置一个较大的nop计数器, 等待其它指令"执行完毕"后停机
                    end 
                    default: ;
                endcase
                in0=0;
            end
            //接收ALU_eq, 设置uIR, nop_counter, inx
            if(in0==2)begin
                ;
            end

            //下次就接收输入信号
            case (uIR[0])
                `uAddr_IRop: begin
                    in0=1;
                    nop_counter[0] = 2;
                    //没有设置uIR=0, 因为下方会用此时的uIR得到uOP并输出
                    //并且可以根据addr, 自动跳转到nop执行
                end
                `uAddr_ALUeq: begin
                    in0=2;
                    nop_counter[0] = 1;
                    nop_back_addr[0] = 1;
                end
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
