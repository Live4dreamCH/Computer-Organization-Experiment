`timescale 1ns / 1ps
//`include "Constants.vh"

module test_MDR();
    wire [31:0] data_read;
    wire [31:0] data;
    reg [31:0] data_write=0;
    reg en=1, we=1, clk=0;
    MDR mdr(clk, en, we, data);

    assign data = (we) ? data_write : 32'bz;
    assign data_read = !(we) ? data : 32'bz;
    always fork
        #3 data_write=32'h21;
        #13 we=0;
        forever #5 clk = ~clk;
    join
endmodule
