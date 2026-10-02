`timescale 1ns/1ps
`include "T_Flip_Flop.v"

module tff_tb;

// Inputs
reg T;
reg rst;

//Outputs
wire Q;
wire Qbar;

//intial value for clk
reg clk = 0;

//Instantiate the tflip flop
t_flip_flop tff0(.T(T), .clk(clk), .Q(Q), .Qbar(Qbar), .rst(rst));

always #10 clk = ~clk;

initial begin

    //dump the waveforms for debugging 
    $dumpfile("t_ff.vcd");
    $dumpvars(0, tff_tb);

    $display("Testing the T Flip Flop");
    $monitor("T:%b, Q:%b", T, Q);

    rst = 1; T = 1'b0; #20; // to reset the intial x state 
    rst = 0; 
    
    T = 1; #20;
    T = 0; #20;
    T = 1; #20;
    T = 0; #20;
    $finish;
end

endmodule