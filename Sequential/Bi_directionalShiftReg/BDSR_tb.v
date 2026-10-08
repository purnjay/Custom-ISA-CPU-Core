// BI-DIRECTIONAL SHIFT REGISTER 
`timescale 1ns / 1ps
`include "BDSR.v"

module BDSR_tb;

// inputs 
reg clk = 0;
reg rst;
reg dir;
reg d;

//outputs
wire q;

always #10 clk = ~clk; // toggle clock every 10 time units

// now we instantiate 
BDSR bdsr0(.clk(clk), .rst(rst), .R_Lshift(dir), .d(d), .q(q));

initial begin

    // Dumping waveform
    $dumpfile("BDSR_tb.vcd");
    $dumpvars(0, BDSR_tb);

    // logs
    $display("BDSR Testbench");
    $monitor("rst=%b dir=%b d=%b q=%b", rst, dir, d, q);

    // Test cases
    rst = 1; dir =  0; d = 1;
    #20;
    rst = 0; dir =  0; d = 0;
    #20;
    rst = 0; dir =  1; d = 1;
    #20;
    rst = 0; dir =  1; d = 0;
    #80;
    rst = 0; dir =  0; d = 1;
    #20;
    rst = 0; dir =  1; d = 1;
    #20;
    $finish;
end
endmodule