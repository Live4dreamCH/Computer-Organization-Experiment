`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/14 21:44:02
// Design Name: 
// Module Name: FullAdder32
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


module FullAdder32(
    a, b, c_o, s
    );
    input[31:0] a, b;
    output c_o;
    output[31:0] s;
    wire[30:0] c_t;
    half_adder  ha0(.a(a[0]), .b(b[0]), .s(s[0]), .c(c_t[0]));
    full_adder  fa1(a[1], b[1], c_t[0], c_t[1], s[1]),
                fa2(a[2], b[2], c_t[1], c_t[2], s[2]), 
                fa3(a[3], b[3], c_t[2], c_t[3], s[3]), 
                fa4(a[4], b[4], c_t[3], c_t[4], s[4]), 
                fa5(a[5], b[5], c_t[4], c_t[5], s[5]), 
                fa6(a[6], b[6], c_t[5], c_t[6], s[6]), 
                fa7(a[7], b[7], c_t[6], c_t[7], s[7]), 
                fa8(a[8], b[8], c_t[7], c_t[8], s[8]),
                fa9(a[9], b[9], c_t[8], c_t[9], s[9]),
                fa10(a[10], b[10], c_t[9], c_t[10], s[10]),
                fa11(a[11], b[11], c_t[10], c_t[11], s[11]),
                fa12(a[12], b[12], c_t[11], c_t[12], s[12]),
                fa13(a[13], b[13], c_t[12], c_t[13], s[13]),
                fa14(a[14], b[14], c_t[13], c_t[14], s[14]),
                fa15(a[15], b[15], c_t[14], c_t[15], s[15]),
                fa16(a[16], b[16], c_t[15], c_t[16], s[16]),
                fa17(a[17], b[17], c_t[16], c_t[17], s[17]),
                fa18(a[18], b[18], c_t[17], c_t[18], s[18]),
                fa19(a[19], b[19], c_t[18], c_t[19], s[19]),
                fa20(a[20], b[20], c_t[19], c_t[20], s[20]),
                fa21(a[21], b[21], c_t[20], c_t[21], s[21]),
                fa22(a[22], b[22], c_t[21], c_t[22], s[22]),
                fa23(a[23], b[23], c_t[22], c_t[23], s[23]),
                fa24(a[24], b[24], c_t[23], c_t[24], s[24]),
                fa25(a[25], b[25], c_t[24], c_t[25], s[25]),
                fa26(a[26], b[26], c_t[25], c_t[26], s[26]),
                fa27(a[27], b[27], c_t[26], c_t[27], s[27]),
                fa28(a[28], b[28], c_t[27], c_t[28], s[28]),
                fa29(a[29], b[29], c_t[28], c_t[29], s[29]),
                fa30(a[30], b[30], c_t[29], c_t[30], s[30]),
                fa31(a[31], b[31], c_t[30], c_o, s[31]);
endmodule
