`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/22 15:40:55
// Design Name: 
// Module Name: D_flip_flop
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module D_flip_flop(
    D,
    en,     //en是高电平有效的使能
    clk,    //clk是上升沿触发的时钟信号
    clear,  //clear,set->Q;
    set,    //1,1->x; 1,0->0; 0,1->1; 0,0->D;
    Q,
    NQ      //Q与NQ是一对互反的输出, Q跟随D
    );
    //D触发器    
    input D, en, clk, clear, set;
    output Q, NQ;
    reg Q, NQ;

    always @(posedge clk) begin
        if (en) begin
            case ({clear, set})
                2'b11: Q = 1'bx;
                2'b10: Q = 1'b0;
                2'b01: Q = 1'b1;
                default: Q = D;
            endcase
            NQ = ~Q;
        end
    end
endmodule
