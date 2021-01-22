`timescale 1ns / 1ps
`include "Constants.vh"

//MDR 内存数据寄存器, 暂存与内存交换的数据(代码)
//mem_bus 双向总线, 与内存相连
//in_bus 输入总线, 与RFo2相连
//out_bus 输出总线, 与ALUo分时使用, 与RFi IR相连
//we 扩展的读写控制: 
//=0时mem_bus向外输出, =1时out_bus向外输出, =2时mem_bus向内输入, =3时in_bus向内输入
module MDR(clk, en, we, mem_bus, in_bus, out_bus);
    inout [`CPU_width-1 :0] mem_bus;
    input [`CPU_width-1 :0] in_bus;
    output[`CPU_width-1 :0] out_bus;
    input en, clk;
    input[1:0] we;
    reg [`CPU_width-1:0] inner_data = `CPU_width'h00000000;

    assign mem_bus = (we==0 && en==1) ? inner_data : `CPU_width'bz;    //读出
    assign out_bus = (we==1 && en==1) ? inner_data : `CPU_width'bz;    //读出
    always @(posedge clk) begin
        if (en) begin
            case (we)
                2: inner_data <= mem_bus;  //写入
                3: inner_data <= in_bus;  //写入
            endcase
        end
    end
endmodule
