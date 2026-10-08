`timescale 1ns / 1ps
`include "Ring_counter.v"

module ring_counter_tb;

parameter N = 4;

//inputs
reg preset = 0;
reg clk = 0;
reg rst = 0;

// output
wire [N-1:0] q;

// clock generation
always #10 clk = ~clk;

// Now we instantiate the ring counter
ring_counter #(N) rc0(.preset(preset), .clk(clk), .rst(rst), .q(q));

initial begin

    // Dump waveform
    $dumpfile("ring_counter_tb.vcd");
    $dumpvars(0, ring_counter_tb);

    // Log
    $display("Ring Counter Testbench");
    $monitor("Ring Counter Output: q=%b, preset=%b, rst=%b", q, preset, rst);
    rst = 1; #20;
    rst = 0; #20;

    preset = 1; #20;
    preset = 0; #100;
    
    $finish;
end

endmodule