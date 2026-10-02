`timescale 1ns/1ps
`include "JK_ff.v"

module jkff_tb;

//inputs 
reg J;
reg K;
reg rst;
reg clk = 0;

//output variables
wire Q;
wire Qbar;

always #10 clk = ~clk;

jk_ff j0(.J(J), .K(K), .rst(rst), .clk(clk), .Q(Q), .Qbar(Qbar));

initial begin
    // dump the waveforms for debugging
    $dumpfile("jk_ff.vcd");
    $dumpvars(0, jkff_tb);

    $display("Testing the JK Flip-Flop");
    $monitor("J = %b, K = %b, rst = %b, clk = %b, Q = %b, Qbar = %b", J, K, rst, clk, Q, Qbar);
    //test cases
    
    J = 0; K = 0; rst = 0; #20;
    J = 0; K = 0; rst = 1; #20;
    J = 0; K = 0; rst = 0; #20;
    J = 0; K = 0; rst = 0; #20;
    J = 0; K = 1; rst = 0; #20;
    J = 1; K = 0; rst = 0; #20;
    J = 1; K = 1; rst = 0; #20;

    $finish;
end

endmodule