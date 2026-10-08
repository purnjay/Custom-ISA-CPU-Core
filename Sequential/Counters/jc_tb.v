`timescale 1ns / 1ps
`include "Johnson_Counter.v"

module johnson_counter_tb;

parameter N = 4;

// inputs 
reg clk = 0;
reg rst = 0;

// outputs 
wire [N-1:0] q;

// clock generation
always #10 clk = ~clk;

// instantiate the Johnson counter
johnson_counter #(.N(N)) jc0(.clk(clk), .rst(rst), .q(q));

initial begin
    
    //dump the waveform
    $dumpfile("jc_tb.vcd");
    $dumpvars(0, johnson_counter_tb);
    
    // Log
    $display("Johnson Counter Testbench");
    $monitor("q = %b, rst=%b", q, rst);

    rst = 1; #20;
    rst = 0; #200;

    $finish;
end

endmodule