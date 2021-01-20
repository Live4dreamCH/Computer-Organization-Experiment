`timescale 1ns / 1ps
`include "Constants.vh"
`define uAddr_IRop 6'b000101
`define uAddr_ALUeq 6'b011001
`define uAddr_beq 6'b011010
`define uAddr_j 6'b011011
`define uAddr_lw 6'b010001
`define uAddr_sw 6'b010101

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
    //所以设置3个halts寄存器, 用于三者的同步(类似多线程同步结束)
    reg reg_halt, halts[0:2];
    //CU向IR发送译码控制信号后, 或在Beq/ne中向ALU发送-信号后, 需要在下一上升沿才能读取输入值
    //所以用这三个寄存器"记忆"这一需求至下一上升沿
    reg[1:0] in[0:2];
    //beq/bne的控制微指令完全一致, 但执行结果有刚好相反
    //为节省CM空间, 在此处设计寄存器, 暂存二者的不同. 规定beq=1, bne=0
    reg is_beq[0:2];
    
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
        halts[0]=0;
        halts[1]=0;
        halts[2]=0;
        in[0]=0;
        in[1]=0;
        in[2]=0;
        is_beq[0]=0;
        is_beq[1]=0;
        is_beq[2]=0;
    end

    always @(posedge clk) begin
        if (en) begin
            //接收输入, 改变状态
            //接收IR_op, 设置nop_counter_backup, nop_back_addr, inx
            if(in[0]==1)begin
                case (IR_op)
                    //译码没有得到结果, 应停机
                    //设置halts寄存器, 让微指令陷入nop死循环(令nop_back_addr=0)
                    //等待其它指令"执行完毕"后停机
                    `op_nop: begin
                        halts[0]<=1;
                        nop_counter_backup[0]<=0;
                        nop_back_addr[0]<=0;
                        $display($time, " pipeline 0: nop from IR, halt!");
                    end
                    //R-type
                    `op_add: begin
                        nop_counter_backup[0]<=1;
                        nop_back_addr[0]<=`CM_addr_width'b000110;
                    end
                    `op_sub: begin
                        nop_counter_backup[0]<=1;
                        nop_back_addr[0]<=`CM_addr_width'b001000;
                    end
                    `op_and: begin
                        nop_counter_backup[0]<=1;
                        nop_back_addr[0]<=`CM_addr_width'b001001;
                    end
                    `op_or: begin
                        nop_counter_backup[0]<=1;
                        nop_back_addr[0]<=`CM_addr_width'b001010;
                    end
                    `op_xor: begin
                        nop_counter_backup[0]<=1;
                        nop_back_addr[0]<=`CM_addr_width'b001011;
                    end
                    `op_less: begin
                        nop_counter_backup[0]<=1;
                        nop_back_addr[0]<=`CM_addr_width'b001100;
                    end
                    //I-type
                    `op_addi: begin
                        nop_counter_backup[0]<=1;
                        nop_back_addr[0]<=`CM_addr_width'b001101;
                    end
                    `op_andi: begin
                        nop_counter_backup[0]<=1;
                        nop_back_addr[0]<=`CM_addr_width'b001111;
                    end
                    `op_ori: begin
                        nop_counter_backup[0]<=1;
                        nop_back_addr[0]<=`CM_addr_width'b010000;
                    end
                    `op_lw: begin
                        nop_counter_backup[0]<=0;
                        nop_back_addr[0]<=`CM_addr_width'b010001;
                    end
                    `op_sw: begin
                        //计数机制略有问题, 无法在第二段nop中, 空一个时钟周期
                        //不过由于sw需要在第三级进行冒险排除, 到时再设置nop_counter则没有这个问题
                        //此时暂设置nop_counter_backup为0
                        nop_counter_backup[0]<=0;
                        nop_back_addr[0]<=`CM_addr_width'b010101;
                    end
                    `op_beq: begin
                        is_beq[0]<=1;
                        nop_counter_backup[0]<=1;
                        nop_back_addr[0]<=`CM_addr_width'b011000;
                    end
                    `op_bne: begin
                        is_beq[0]<=0;
                        nop_counter_backup[0]<=1;
                        nop_back_addr[0]<=`CM_addr_width'b011000;
                    end
                    //J-type, 此处需要冲刷第一级, 复制时需注意下标问题
                    `op_j: begin
                        //冲刷第一级, uIR nop_counter nop_counter_backup nop_back_addr
                        if (!halts[1]) begin
                            uIR[1]<=0;
                            nop_counter[1]<=10;
                            nop_counter_backup[1]<=0;
                            nop_back_addr[1]<=1;
                        end
                        //本指令的微指令设置
                        nop_counter_backup[0]<=2;
                        nop_back_addr[0]<=`CM_addr_width'b011011;
                    end
                    //译码失败, 开始挂机
                    default: begin
                        halts[0]<=1;
                        nop_counter_backup[0]<=0;
                        nop_back_addr[0]<=0;
                        //假如提供的汇编指令中间有一句出错了, 会因此废掉3条流水线中的一条
                        //所以在此输出, 方便调试
                        $display($time, " pipeline 0: wrong op from IR, halt!");
                    end
                endcase
                in[0]<=0;
            end
            if(in[1]==1)begin
                case (IR_op)
                    //译码没有得到结果, 应停机
                    //设置halts寄存器, 让微指令陷入nop死循环(令nop_back_addr=0)
                    //等待其它指令"执行完毕"后停机
                    `op_nop: begin
                        halts[1]<=1;
                        nop_counter_backup[1]<=0;
                        nop_back_addr[1]<=0;
                        $display($time, " pipeline 1: nop from IR, halt!");
                    end
                    //R-type
                    `op_add: begin
                        nop_counter_backup[1]<=1;
                        nop_back_addr[1]<=`CM_addr_width'b000110;
                    end
                    `op_sub: begin
                        nop_counter_backup[1]<=1;
                        nop_back_addr[1]<=`CM_addr_width'b001000;
                    end
                    `op_and: begin
                        nop_counter_backup[1]<=1;
                        nop_back_addr[1]<=`CM_addr_width'b001001;
                    end
                    `op_or: begin
                        nop_counter_backup[1]<=1;
                        nop_back_addr[1]<=`CM_addr_width'b001010;
                    end
                    `op_xor: begin
                        nop_counter_backup[1]<=1;
                        nop_back_addr[1]<=`CM_addr_width'b001011;
                    end
                    `op_less: begin
                        nop_counter_backup[1]<=1;
                        nop_back_addr[1]<=`CM_addr_width'b001100;
                    end
                    //I-type
                    `op_addi: begin
                        nop_counter_backup[1]<=1;
                        nop_back_addr[1]<=`CM_addr_width'b001101;
                    end
                    `op_andi: begin
                        nop_counter_backup[1]<=1;
                        nop_back_addr[1]<=`CM_addr_width'b001111;
                    end
                    `op_ori: begin
                        nop_counter_backup[1]<=1;
                        nop_back_addr[1]<=`CM_addr_width'b010000;
                    end
                    `op_lw: begin
                        nop_counter_backup[1]<=0;
                        nop_back_addr[1]<=`CM_addr_width'b010001;
                    end
                    `op_sw: begin
                        //计数机制略有问题, 无法在第二段nop中, 空一个时钟周期
                        //不过由于sw需要在第三级进行冒险排除, 到时再设置nop_counter则没有这个问题
                        //此时暂设置nop_counter_backup为0
                        nop_counter_backup[1]<=0;
                        nop_back_addr[1]<=`CM_addr_width'b010101;
                    end
                    `op_beq: begin
                        is_beq[1]<=1;
                        nop_counter_backup[1]<=1;
                        nop_back_addr[1]<=`CM_addr_width'b011000;
                    end
                    `op_bne: begin
                        is_beq[1]<=0;
                        nop_counter_backup[1]<=1;
                        nop_back_addr[1]<=`CM_addr_width'b011000;
                    end
                    //J-type, 此处需要冲刷第一级, 复制时需注意下标问题
                    `op_j: begin
                        //冲刷第一级, uIR nop_counter nop_counter_backup nop_back_addr
                        if (!halts[2]) begin
                            uIR[2]<=0;
                            nop_counter[2]<=10;
                            nop_counter_backup[2]<=0;
                            nop_back_addr[2]<=1;
                        end
                        //本指令的微指令设置
                        nop_counter_backup[1]<=2;
                        nop_back_addr[1]<=`CM_addr_width'b011011;
                    end
                    //译码失败, 开始挂机
                    default: begin
                        halts[1]<=1;
                        nop_counter_backup[1]<=0;
                        nop_back_addr[1]<=0;
                        //假如提供的汇编指令中间有一句出错了, 会因此废掉3条流水线中的一条
                        //所以在此输出, 方便调试
                        $display($time, " pipeline 1: wrong op from IR, halt!");
                    end
                endcase
                in[1]<=0;
            end
            if(in[2]==1)begin
                case (IR_op)
                    //译码没有得到结果, 应停机
                    //设置halts寄存器, 让微指令陷入nop死循环(令nop_back_addr=0)
                    //等待其它指令"执行完毕"后停机
                    `op_nop: begin
                        halts[2]<=1;
                        nop_counter_backup[2]<=0;
                        nop_back_addr[2]<=0;
                        $display($time, " pipeline 2: nop from IR, halt!");
                    end
                    //R-type
                    `op_add: begin
                        nop_counter_backup[2]<=1;
                        nop_back_addr[2]<=`CM_addr_width'b000110;
                    end
                    `op_sub: begin
                        nop_counter_backup[2]<=1;
                        nop_back_addr[2]<=`CM_addr_width'b001000;
                    end
                    `op_and: begin
                        nop_counter_backup[2]<=1;
                        nop_back_addr[2]<=`CM_addr_width'b001001;
                    end
                    `op_or: begin
                        nop_counter_backup[2]<=1;
                        nop_back_addr[2]<=`CM_addr_width'b001010;
                    end
                    `op_xor: begin
                        nop_counter_backup[2]<=1;
                        nop_back_addr[2]<=`CM_addr_width'b001011;
                    end
                    `op_less: begin
                        nop_counter_backup[2]<=1;
                        nop_back_addr[2]<=`CM_addr_width'b001100;
                    end
                    //I-type
                    `op_addi: begin
                        nop_counter_backup[2]<=1;
                        nop_back_addr[2]<=`CM_addr_width'b001101;
                    end
                    `op_andi: begin
                        nop_counter_backup[2]<=1;
                        nop_back_addr[2]<=`CM_addr_width'b001111;
                    end
                    `op_ori: begin
                        nop_counter_backup[2]<=1;
                        nop_back_addr[2]<=`CM_addr_width'b010000;
                    end
                    `op_lw: begin
                        nop_counter_backup[2]<=0;
                        nop_back_addr[2]<=`CM_addr_width'b010001;
                    end
                    `op_sw: begin
                        //计数机制略有问题, 无法在第二段nop中, 空一个时钟周期
                        //不过由于sw需要在第三级进行冒险排除, 到时再设置nop_counter则没有这个问题
                        //此时暂设置nop_counter_backup为0
                        nop_counter_backup[2]<=0;
                        nop_back_addr[2]<=`CM_addr_width'b010101;
                    end
                    `op_beq: begin
                        is_beq[2]<=1;
                        nop_counter_backup[2]<=1;
                        nop_back_addr[2]<=`CM_addr_width'b011000;
                    end
                    `op_bne: begin
                        is_beq[2]<=0;
                        nop_counter_backup[2]<=1;
                        nop_back_addr[2]<=`CM_addr_width'b011000;
                    end
                    //J-type, 此处需要冲刷第一级, 复制时需注意下标问题
                    `op_j: begin
                        //冲刷第一级, uIR nop_counter nop_counter_backup nop_back_addr
                        if (!halts[0]) begin
                            uIR[0]<=0;
                            nop_counter[0]<=10;
                            nop_counter_backup[0]<=0;
                            nop_back_addr[0]<=1;
                        end
                        //本指令的微指令设置
                        nop_counter_backup[2]<=2;
                        nop_back_addr[2]<=`CM_addr_width'b011011;
                    end
                    //译码失败, 开始挂机
                    default: begin
                        halts[2]<=1;
                        nop_counter_backup[2]<=0;
                        nop_back_addr[2]<=0;
                        //假如提供的汇编指令中间有一句出错了, 会因此废掉3条流水线中的一条
                        //所以在此输出, 方便调试
                        $display($time, " pipeline 2: wrong op from IR, halt!");
                    end
                endcase
                in[2]<=0;
            end

            //接收ALU_eq, 设置uIR, nop_counter, inx
            if(in[0]==2)begin
                //需要跳转; 并冲刷前两级, 注意下标和冲刷时长
                if (is_beq[0]==ALU_eq) begin
                    //跳转
                    uIR[0]<=`uAddr_beq;
                    nop_counter[0] <= 0;
                    //冲刷
                    if (!halts[1]) begin
                        in[1]<=0;
                        uIR[1]<=0;
                        nop_counter[1]<=5;
                        nop_counter_backup[1]<=0;
                        nop_back_addr[1]<=1;
                    end
                    if (!halts[2]) begin
                        uIR[2]<=0;
                        nop_counter[2]<=9;
                        nop_counter_backup[2]<=0;
                        nop_back_addr[2]<=1;
                    end
                end
                in[0]=0;
            end
            if(in[1]==2)begin
                //需要跳转; 并冲刷前两级, 注意下标和冲刷时长
                if (is_beq[1]==ALU_eq) begin
                    //跳转
                    uIR[1]<=`uAddr_beq;
                    nop_counter[1] <= 0;
                    //冲刷
                    if (!halts[2]) begin
                        in[2]<=0;
                        uIR[2]<=0;
                        nop_counter[2]<=5;
                        nop_counter_backup[2]<=0;
                        nop_back_addr[2]<=1;
                    end
                    if (!halts[0]) begin
                        uIR[0]<=0;
                        nop_counter[0]<=9;
                        nop_counter_backup[0]<=0;
                        nop_back_addr[0]<=1;
                    end
                end
                in[1]=0;
            end
            if(in[2]==2)begin
                //需要跳转; 并冲刷前两级, 注意下标和冲刷时长
                if (is_beq[2]==ALU_eq) begin
                    //跳转
                    uIR[2]<=`uAddr_beq;
                    nop_counter[2] <= 0;
                    //冲刷
                    if (!halts[0]) begin
                        in[0]<=0;
                        uIR[0]<=0;
                        nop_counter[0]<=5;
                        nop_counter_backup[0]<=0;
                        nop_back_addr[0]<=1;
                    end
                    if (!halts[1]) begin
                        uIR[1]<=0;
                        nop_counter[1]<=9;
                        nop_counter_backup[1]<=0;
                        nop_back_addr[1]<=1;
                    end
                end
                in[2]=0;
            end

            //运行到特定微指令时做的事, 如处理输入 跳转到指定命令 冲刷
            case (uIR[0])
                //准备下一个上升沿, 处理IR_op的输入
                `uAddr_IRop: begin
                    in[0]<=1;
                    nop_counter[0] <= 2;
                    //没有设置uIR=0, 因为下方会用此时的uIR得到uOP并输出
                    //并且可以根据addr, 自动跳转到nop执行
                end
                //准备下一个上升沿, 处理ALU_eq的输入
                `uAddr_ALUeq: begin
                    in[0]<=2;
                    nop_counter[0] <= 1;
                    nop_counter_backup[0]<=0;
                    nop_back_addr[0] <= 1;
                    //以上为默认的"不跳转"设置
                end
                //在j执行到第三级时, 再次冲刷第一级, 注意下标
                `uAddr_j: begin
                    if (!halts[2]) begin
                        uIR[2]<=0;
                        nop_counter[2]<=11;
                        nop_counter_backup[2]<=0;
                        nop_back_addr[2]<=1;
                    end
                end
                //在lw/sw开始运行到第三级时, 冲刷第一级的取指, 避免内存争用, 注意下标
                `uAddr_lw: begin
                    if (!halts[2]) begin
                        uIR[2]<=0;
                        nop_counter[2]<=11;
                        nop_counter_backup[2]<=0;
                        nop_back_addr[2]<=1;
                    end
                end
                `uAddr_sw: begin
                    nop_counter[0] <= 0;
                    nop_back_addr[0]<=1;
                    if (!halts[2]) begin
                        uIR[2]<=0;
                        nop_counter[2]<=11;
                        nop_counter_backup[2]<=0;
                        nop_back_addr[2]<=1;
                    end
                end
                default: in[0]=0;
            endcase
            case (uIR[1])
                //准备下一个上升沿, 处理IR_op的输入
                `uAddr_IRop: begin
                    in[1]<=1;
                    nop_counter[1] <= 2;
                    //没有设置uIR=0, 因为下方会用此时的uIR得到uOP并输出
                    //并且可以根据addr, 自动跳转到nop执行
                end
                //准备下一个上升沿, 处理ALU_eq的输入
                `uAddr_ALUeq: begin
                    in[1]<=2;
                    nop_counter[1] <= 1;
                    nop_counter_backup[1]<=0;
                    nop_back_addr[1] <= 1;
                    //以上为默认的"不跳转"设置
                end
                //在j执行到第三级时, 再次冲刷第一级, 注意下标
                `uAddr_j: begin
                    if (!halts[0]) begin
                        uIR[0]<=0;
                        nop_counter[0]<=11;
                        nop_counter_backup[0]<=0;
                        nop_back_addr[0]<=1;
                    end
                end
                //在lw/sw开始运行到第三级时, 冲刷第一级的取指, 避免内存争用, 注意下标
                `uAddr_lw: begin
                    if (!halts[0]) begin
                        uIR[0]<=0;
                        nop_counter[0]<=11;
                        nop_counter_backup[0]<=0;
                        nop_back_addr[0]<=1;
                    end
                end
                `uAddr_sw: begin
                    nop_counter[1] <= 0;
                    nop_back_addr[1]<=1;
                    if (!halts[0]) begin
                        uIR[0]<=0;
                        nop_counter[0]<=11;
                        nop_counter_backup[0]<=0;
                        nop_back_addr[0]<=1;
                    end
                end
                default: in[1]=0;
            endcase
            case (uIR[2])
                //准备下一个上升沿, 处理IR_op的输入
                `uAddr_IRop: begin
                    in[2]<=1;
                    nop_counter[2] <= 2;
                    //没有设置uIR=0, 因为下方会用此时的uIR得到uOP并输出
                    //并且可以根据addr, 自动跳转到nop执行
                end
                //准备下一个上升沿, 处理ALU_eq的输入
                `uAddr_ALUeq: begin
                    in[2]<=2;
                    nop_counter[2] <= 1;
                    nop_counter_backup[2]<=0;
                    nop_back_addr[2] <= 1;
                    //以上为默认的"不跳转"设置
                end
                //在j执行到第三级时, 再次冲刷第一级, 注意下标
                `uAddr_j: begin
                    if (!halts[1]) begin
                        uIR[1]<=0;
                        nop_counter[1]<=11;
                        nop_counter_backup[1]<=0;
                        nop_back_addr[1]<=1;
                    end
                end
                //在lw/sw开始运行到第三级时, 冲刷第一级的取指, 避免内存争用, 注意下标
                `uAddr_lw: begin
                    if (!halts[1]) begin
                        uIR[1]<=0;
                        nop_counter[1]<=11;
                        nop_counter_backup[1]<=0;
                        nop_back_addr[1]<=1;
                    end
                end
                `uAddr_sw: begin
                    nop_counter[2] <= 0;
                    nop_back_addr[2]<=1;
                    if (!halts[1]) begin
                        uIR[1]<=0;
                        nop_counter[1]<=11;
                        nop_counter_backup[1]<=0;
                        nop_back_addr[1]<=1;
                    end
                end
                default: in[2]=0;
            endcase

            //uOP的获取
            temp0=CM[uIR[0]];
            temp1=CM[uIR[1]];
            temp2=CM[uIR[2]];
            $display("time = ", $time, ", addr0 = ", uIR[0], ", addr1 = ", uIR[1], ", addr2 = ", uIR[2]);

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
            if (!uIR[1]) begin
                if(nop_counter[1]) begin
                    nop_counter[1]=nop_counter[1]-1;
                end
                else begin
                    uIR[1]=nop_back_addr[1];
                    if(nop_counter_backup[1]!=0)begin
                        nop_counter[1]<=nop_counter_backup[1];
                        nop_counter_backup[1]<=0;
                        nop_back_addr[1]<=1;
                    end
                end
            end
            else begin
                uIR[1]=temp1[`CM_addr_width-1 :0];
            end
            if (!uIR[2]) begin
                if(nop_counter[2]) begin
                    nop_counter[2]=nop_counter[2]-1;
                end
                else begin
                    uIR[2]=nop_back_addr[2];
                    if(nop_counter_backup[2]!=0)begin
                        nop_counter[2]<=nop_counter_backup[2];
                        nop_counter_backup[2]<=0;
                        nop_back_addr[2]<=1;
                    end
                end
            end
            else begin
                uIR[2]=temp2[`CM_addr_width-1 :0];
            end

            //变换输出控制信号
            reg_halt = halts[0] & halts[1] & halts[2];
            //reg_and仅供调试
            reg_and = temp0[`CM_op_width+`CM_addr_width-1 : `CM_addr_width] & temp1[`CM_op_width+`CM_addr_width-1 : `CM_addr_width] & temp0[`CM_op_width+`CM_addr_width-1 : `CM_addr_width];
            if(reg_and)begin
                $display("time = ", $time, ", conflict appear at uOP! reg_and = %b", reg_and);
                $display("");
                //$stop;
            end
            reg_or = temp0[`CM_op_width+`CM_addr_width-1 : `CM_addr_width] | temp1[`CM_op_width+`CM_addr_width-1 : `CM_addr_width] | temp0[`CM_op_width+`CM_addr_width-1 : `CM_addr_width];
        end
    end
endmodule
