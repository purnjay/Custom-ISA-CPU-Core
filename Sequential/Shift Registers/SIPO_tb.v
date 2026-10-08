`timescale 1ns/1ps
`include "SIPO.v"

module SIPO_tb;

// inputs 
reg d;
reg clk = 0;
reg rst;

// set the clock
always #10 clk = ~clk;

//output, testing for 4 bit case
wire [3:0] q;
wire [3:0] shift_reg_out;

// Instantiate the SIPO module
SIPO #(4) sipo_inst(.d(d), .clk(clk), .rst(rst), .q(q));

initial begin

    //dump the waveform
    $dumpfile("SIPO.vcd");
    $dumpvars(0, SIPO_tb);

    $display("SIPO testbench");
    $monitor("d = %b, rst = %b, q = %b", d, rst, q);

    //test cases
    d = 0; rst = 1; #20;
    d = 0; rst = 0; #20;
    d = 0; #20;
    d = 1; #20;
    d = 0; #80;
    d = 0; #20;
    $finish;

end
endmodule