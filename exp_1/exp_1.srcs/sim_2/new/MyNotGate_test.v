`timescale 1ns / 1ps

module MyNotGate_test(

    );
    reg in;
    wire out;
    initial begin
        in = 0;
        #10;
        in = 1;
    end
    MyNotGate n1(in, out);
endmodule
