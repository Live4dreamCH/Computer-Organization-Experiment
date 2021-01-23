`timescale 1ns / 1ps
//`include "Constants.vh"

module test_CPU();
    //CU的第一个上升沿在#5, 数据通路的第一个上升沿在#0, 全无使能
    reg clk=0, en=1;
    //clk初值为0也没关系:
    //#5时数据通路上升沿
    //#0时CU第一个上升沿

    tri[`CPU_width-1 :0] addr, data;
    tri halt, mreq, rw;
    
    integer i=0, n=9, base=32'hf0;

    CPU cpu(clk, en, halt, mreq, rw, addr, data);
    Memory memory(data, addr, mreq, rw, clk);

    wire[`CPU_width-1 :0] R_cmd, I_cmd;
    reg[4:0] rs=0, rt=0, rd=0, shamt=0;
    reg[5:0] op=0, func=0;
    reg[15:0] imme=0;
    assign R_cmd = {op[5:0], rs[4:0], rt[4:0], rd[4:0], shamt[4:0], func[5:0]};
    assign I_cmd = {op[5:0], rs[4:0], rt[4:0], imme[15:0]};
    initial begin
        op=`OP_lw;      rs=0;   rt=31;  imme=16'h0380;  #0.1;
        memory.memory_bank[0] = I_cmd;

        op=`OP_addi;    rs=0;   rt=30;  imme=16'h03c0;  #0.1;
        memory.memory_bank[1] = I_cmd;

        op=`OP_Rtype;   rs=30;  rt=31;  rd=29;  func=`func_add; #0.1;
        memory.memory_bank[2] = R_cmd;

        op=`OP_Rtype;   rs=0;   rt=30;  rd=28;  func=`func_add; #0.1;
        memory.memory_bank[3] = R_cmd;

        op=`OP_addi;    rs=0;   rt=25;  imme=16'd4;     #0.1;
        memory.memory_bank[4] = I_cmd;

        op=`OP_Rtype;   rs=29;  rt=25;  rd=24;  func=`func_sub; #0.1;
        memory.memory_bank[5] = R_cmd;

        op=`OP_Rtype;   rs=0;   rt=28;  rd=26;  func=`func_add; #0.1;
        memory.memory_bank[6] = R_cmd;

        op=`OP_lw;      rs=28;  rt=1;   imme=16'd0;     #0.1;
        memory.memory_bank[7] = I_cmd;

        op=`OP_Rtype;   rs=0;   rt=1;  rd=4;  func=`func_add; #0.1;
        memory.memory_bank[8] = R_cmd;

        op=`OP_addi;    rs=28;   rt=27;  imme=16'd4;     #0.1;
        memory.memory_bank[9] = I_cmd;

        op=`OP_lw;      rs=27;  rt=2;   imme=16'd0;     #0.1;
        memory.memory_bank[10] = I_cmd;

        op=`OP_Rtype;   rs=2;   rt=1;  rd=3;  func=`func_sltu; #0.1;
        memory.memory_bank[11] = R_cmd;

        op=`OP_beq;     rs=0;  rt=3;   imme=16'd2;     #0.1;
        memory.memory_bank[12] = I_cmd;

        op=`OP_Rtype;   rs=0;   rt=27;  rd=26;  func=`func_add; #0.1;
        memory.memory_bank[13] = R_cmd;

        op=`OP_Rtype;   rs=0;   rt=2;  rd=1;  func=`func_add; #0.1;
        memory.memory_bank[14] = R_cmd;

        op=`OP_addi;    rs=27;   rt=27;  imme=16'd4;     #0.1;
        memory.memory_bank[15] = I_cmd;

        op=`OP_bne;     rs=27;  rt=29;   imme=-7;     #0.1;
        memory.memory_bank[16] = I_cmd;

        op=`OP_beq;     rs=26;  rt=28;   imme=16'd2;     #0.1;
        memory.memory_bank[17] = I_cmd;

        op=`OP_sw;      rs=26;  rt=4;   imme=16'd0;     #0.1;
        memory.memory_bank[18] = I_cmd;

        op=`OP_sw;      rs=28;  rt=1;   imme=16'd0;     #0.1;
        memory.memory_bank[19] = I_cmd;

        op=`OP_addi;    rs=28;   rt=28;  imme=16'd4;     #0.1;
        memory.memory_bank[20] = I_cmd;

        op=`OP_bne;     rs=28;  rt=24;   imme=-16;     #0.1;
        memory.memory_bank[21] = I_cmd;

        memory.memory_bank[22] = 0;
        memory.memory_bank[23] = 0;
        memory.memory_bank[24] = 0;
        memory.memory_bank[25] = 0;

    end

    initial begin
        $display("before:");
        for(i=0; i<n; i=i+1) begin
            $write("%h ", memory.memory_bank[base+i]);
        end
        $display("\n");
        wait(halt) begin
            #20
            $display("\ntime = ", $time, ", halt signal set!");
            $display("after:");
            for(i=0; i<n; i=i+1)begin
                $write("%h ", memory.memory_bank[base+i]);
            end
            $display("\n");
            $finish;
        end
    end

    initial begin
        forever #5 clk = ~clk;
    end
endmodule
