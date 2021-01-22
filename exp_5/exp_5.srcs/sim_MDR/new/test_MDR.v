`timescale 1ns / 1ps
//`include "Constants.vh"

module test_MDR();
    wire [31:0] mem_out, out_bus;
    wire [31:0] mem_bus;
    reg [31:0] mem_in=32'h21, in_bus=32'h86;
    reg en=1, clk=0;
    reg[1:0] we;
    MDR mdr(clk, en, we, mem_bus, in_bus, out_bus);

    assign mem_bus = (we==2) ? mem_in : 32'bz;
    assign mem_out = (we==0) ? mem_bus : 32'bz;
    initial begin
        #3 we=0;
        #10 we=1;
        
        #10 we=2;
        #10 we=0;
        #10 we=1;

        #10 we=3;
        #10 we=0;
        #10 we=1;
        #20 $finish;
    end

    initial begin
        forever #5 clk = ~clk;
    end
endmodule
