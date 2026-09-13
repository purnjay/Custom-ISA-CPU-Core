`timescale 1ns/1ps
`include "D_Flip_Flop.v"

module d_ff_tb;

//inputs 
reg D;
reg clk = 0; //intial condition for the clock

//outputs
wire Q;
wire Qbar;

//Instantiate the D flip flop
d_flip_flop dff0(.D(D), .clk(clk), .Q(Q), .Qbar(Qbar));

always #10 clk = ~clk;

initial begin
    

    //Getting the waveforms
    $dumpfile("d_ff.vcd");
    $dumpvars(0, d_ff_tb);

    // Debugging the dff
    $display("Testing the D Flip Flop");
    $monitor("D:%b, CLK:%b | Q:%b, ~Q:%b", D, clk, Q, Qbar);
    
    // Testcases
    D = 0; #20;
    D = 1; #20;
    D = 0; #20;
    D = 1; #20;

    $finish;
end

endmodule