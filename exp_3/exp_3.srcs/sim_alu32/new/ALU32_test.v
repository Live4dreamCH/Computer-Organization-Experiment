`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/15 11:27:19
// Design Name: 
// Module Name: ALU32_test
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


module ALU32_test();
    parameter op_len = 4;
    reg clk = 0;
    reg[op_len-1:0] operation;
    reg[31:0] in1, in2;
    wire[31:0] out;

    ALU32 alu(clk, operation, in1, in2, out);
    
    initial fork
        #3 operation = 1;
        #3 in1=0; #3 in2=0;
        #13 in1=0; #13 in2=1;
        #23 in1=1; #23 in2=0;
        #33 in1=1; #33 in2=1;
        // #43 in1=32'hffffffff; #43 in2=0;
        #53 in1=32'hffffffff; #53 in2=1;
        // #63 in1=32'hffffffff; #63 in2=2;
        #73 in1=32'hffffffff; #73 in2=32'hffffffff;

        #83 operation =4'hz; #83 in1=32'hzzzzzzzz; #83 in2=32'hzzzzzzzz;

        #93 operation = 2;
        #93 in1=0; #93 in2=0;
        #103 in1=1; #103 in2=0;
        #113 in1=0; #113 in2=1;
        // #123 in1=32'h80000000; #123 in2=0;
        #133 in1=32'h80000000; #133 in2=1;
        // #143 in1=32'h7fffffff; #143 in2=1;
        #153 in1=32'h80000000; #153 in2=32'h7fffffff;
        #163 in1=32'h7fffffff; #163 in2=32'h80000000;
        #173 in1=32'hffffffff; #173 in2=32'h00000001;
        #183 in1=32'h00000000; #183 in2=32'hffffffff;
        #193 in1=0; #193 in2=-1;
        #203 in1=-1; #203 in2=0;

        #213 operation =4'hz; #213 in1=32'hzzzzzzzz; #213 in2=32'hzzzzzzzz;

        #223 operation = 3;
        #223 in1=0; #223 in2=0;
        #233 in1=1; #233 in2=0;
        #243 in1=1; #243 in2=1;
        #253 in1=2; #253 in2=3;
        #263 in1=1024; #263 in2=1024;
        #273 in1=32'h80000000; #273 in2=32'h80000000;
        #283 in1=-1; #283 in2=1;
        #293 in1=-2; #293 in2=3;
        #303 in1=-2; #303 in2=-3;

        #313 operation =4'hz; #313 in1=32'hzzzzzzzz; #313 in2=32'hzzzzzzzz;

        #323 operation = 4;
        #323 in1=0; #323 in2=0;
        #333 in1=1; #333 in2=0;
        #343 in1=1; #343 in2=1;
        #353 in1=2; #353 in2=3;
        #363 in1=3; #363 in2=2;
        #373 in1=12; #373 in2=4;
        #383 in1=1024; #383 in2=64;
        #393 in1=-1024; #393 in2=64;
        #403 in1=-1024; #403 in2=-64;

        #413 operation =4'hz; #413 in1=32'hzzzzzzzz; #413 in2=32'hzzzzzzzz;

        #423 operation = 5;
        #423 in1=0; #423 in2=0;
        #433 in1=1; #433 in2=0;
        #443 in1=1; #443 in2=1;
        #453 in1=2; #453 in2=3;
        #463 in1=3; #463 in2=2;
        #473 in1=12; #473 in2=4;
        #483 in1=16; #483 in2=3;
        #493 in1=-16; #493 in2=3;
        #503 in1=-16; #503 in2=-3;

        #513 operation =4'hz; #513 in1=32'hzzzzzzzz; #513 in2=32'hzzzzzzzz;

        #523 operation = 6;
        #523 in1=0;
        #533 in1=1;
        #543 in1=32'hffffffff;
        #553 in1=32'hfecd8086;

        #563 operation =4'hz; #563 in1=32'hzzzzzzzz; #563 in2=32'hzzzzzzzz;

        #573 operation = 7;
        #573 in1=1; #573 in2=0;
        #583 in1=1; #583 in2=1;
        #593 in1=32'h0000ffff; #593 in2=32'hffff0000;
        #603 in1=32'hfecd8086; #603 in2=32'h8086fecd;

        #613 operation =4'hz; #613 in1=32'hzzzzzzzz; #613 in2=32'hzzzzzzzz;

        #623 operation = 8;
        #623 in1=1; #623 in2=0;
        #633 in1=1; #633 in2=1;
        #643 in1=0; #643 in2=0;
        #653 in1=32'hfecd8086; #653 in2=32'h8086fecd;

        #663 operation =4'hz; #663 in1=32'hzzzzzzzz; #663 in2=32'hzzzzzzzz;

        #673 operation = 9;
        #673 in1=1; #673 in2=0;
        #683 in1=1; #683 in2=1;
        #693 in1=32'h0000ffff; #693 in2=32'h00ff00ff;
        #703 in1=32'hfecd8086; #703 in2=32'h8086fecd;

        #713 operation =4'hz; #713 in1=32'hzzzzzzzz; #713 in2=32'hzzzzzzzz;

        #723 operation = 10;
        #723 in1=1; #723 in2=0;
        #733 in1=1; #733 in2=1;
        #743 in1=32'h0000ffff; #743 in2=32'h00ff00ff;
        #753 in1=32'hfecd8086; #753 in2=32'h8086fecd;

        #763 operation =4'hz; #763 in1=32'hzzzzzzzz; #763 in2=32'hzzzzzzzz;

        #773 operation = 11;
        #773 in1=1; #773 in2=1;
        #783 in1=0; #783 in2=1;
        #793 in1=32'hffffffff; #793 in2=1;
        #803 in1=32'hffffffff; #803 in2=32;

        #813 operation =4'hz; #813 in1=32'hzzzzzzzz; #813 in2=32'hzzzzzzzz;

        #823 operation = 12;
        #823 in1=1; #823 in2=1;
        #833 in1=0; #833 in2=1;
        #843 in1=32'hffffffff; #843 in2=1;
        #853 in1=32'hffffffff; #853 in2=32;

        #863 operation =4'hz; #863 in1=32'hzzzzzzzz; #863 in2=32'hzzzzzzzz;

        #873 operation = 13;
        #873 in1=1; #873 in2=0;
        #883 in1=1; #883 in2=1;
        #893 in1=32'hfxxxxxxx; #893 in2=32'hefffffff;
        #903 in1=32'hxxxxffff; #903 in2=32'hffffxxxx;

        #913 operation =4'hz; #913 in1=32'hzzzzzzzz; #913 in2=32'hzzzzzzzz;

        #923 operation = 14;
        #923 in1=0; #923 in2=1;
        #933 in1=1; #933 in2=1;
        #943 in1=32'hefffffff; #943 in2=32'hfxxxxxxx;
        #953 in1=32'hxxxxffff; #953 in2=32'hffffxxxx;

        #963 operation =4'hz; #963 in1=32'hzzzzzzzz; #963 in2=32'hzzzzzzzz;

        #973 operation = 15;
        #973 in1=1; #973 in2=0;
        #983 in1=0; #983 in2=1;
        #993 in1=1; #993 in2=1;
        #1003 in1=32'hxxxxffff; #1003 in2=32'hffffxxxx;

        #1013 operation =4'hz; #1013 in1=32'hzzzzzzzz; #1013 in2=32'hzzzzzzzz;
        forever #5 clk = ~clk;
    join
endmodule
