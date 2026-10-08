`timescale 1ns / 1ps
`include "up_down_counter.v"

module counter_tb;

//inputs 
reg clk = 0;
reg rst;
reg dir;

//outputs
wire [3:0] q; // for a 4 bit example

always #5 clk = ~clk; // Clock generation

//instantiate the counter
counter_up_down uut (.clk(clk), .rst(rst), .dir(dir), .q(q));

initial begin
    // Dump waveform
    $dumpfile("counter_tb.vcd");
    $dumpvars(0, counter_tb);

    //Testcases
    $display("Up - Down Counter test cases");
    $monitor("rst = %b, dir = %b, q = %d, q = %b", rst, dir, q, q);

    // clear the output 
    rst = 1; #10 rst = 0;
    dir = 1;
    #100;
    $display("\n============================================\n"); //switch to down direction
    dir = 0;
    #100;
    $finish;
end

endmodule