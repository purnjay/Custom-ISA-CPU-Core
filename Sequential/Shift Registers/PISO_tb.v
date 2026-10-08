`timescale 1ns/1ps
`include "PISO.v"
module PISO_tb;

//inputs 
reg [3:0] d = 0; //intial value
reg clk = 0; 
reg SH_LD = 0;
reg rst = 0; 

//output 
wire q;

//clock generation
always #10 clk = ~clk;

//Instantiate the PISO module
PISO #(.N(4)) piso_inst(.d(d), .clk(clk), .SH_LD(SH_LD), .rst(rst), .q(q));

initial begin

    // Dumping the waveform
    $dumpfile("PISO.vcd");
    $dumpvars(0, PISO_tb);

    $display("PISO Testbench");
    $monitor("d = %b, clk = %b, SH_LD = %b, rst = %b, q = %b", d, clk, SH_LD, rst, q);

    rst = 0; #20 rst = 1; #20 rst = 0; #20 // The reset block
    // load
    d = 4'b1101; SH_LD = 0; #80 
    // shift
    SH_LD = 1; #80
    $finish;
end
    
endmodule