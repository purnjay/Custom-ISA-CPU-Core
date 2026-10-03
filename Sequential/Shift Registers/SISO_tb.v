`include "SISO.v"
`timescale 1ns/1ps

module SISO_tb;

//inputs
reg D;
reg clk = 0; //initial value for the clk
reg rst;
parameter N = 4; // 4 bit 

//output
wire q;

// clock pulse 
always #10 clk = ~clk;

// Instantiate a 4 bit SISO shift register
SISO #(.N(N)) s0(.d(D), .clk(clk), .rst(rst), .q(q));

initial begin
    
    //dumping waveform for debugging
    $dumpfile("SISO.vcd");
    $dumpvars(0, SISO_tb);

    $display("SISO testbench");
    $monitor("D=%b clk=%b rst=%b | shift=%b q=%b", D, clk, rst, s0.shift_reg, q);

    //test cases
    D = 0; rst = 1; #20;
    D = 0; rst = 0; #20;
    D = 0; #20;
    D = 1; #20;
    D = 0; #80;
    D = 0; #20;
    $finish;
end

endmodule