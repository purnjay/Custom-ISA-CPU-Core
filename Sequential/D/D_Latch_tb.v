`timescale 1ns/1ps
`include "D_latch.v"

module d_latch_tb;

//Inputs
reg D;
reg en;

//Outputs
wire Q;

D_latch d0(.D(D), .enable(en), .Q(Q)); // Passing in the values 

initial begin

    //dump waveform
    $dumpfile("D_latch.vcd");
    $dumpvars(0, d_latch_tb);

    // Testing the module 
    $display("Testing the D Latch");
    $monitor("D:%b, EN:%b, Out:%d", D, en, Q);

    // test cases
    D = 1; en = 0; #5;
    D = 1; en = 1; #5;
    D = 0; en = 0; #5;
    D = 0; en = 1; #5;

end
endmodule