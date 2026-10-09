`timescale 1ns / 1ps
`include "Mod_N_counter.v"

module modn_tb;

//inputs
localparam N = 4;
reg clk = 0;
reg rst;

//output
wire [$clog2(N)-1:0] count; // Assuming N = 8 for this testbench

//clock
always #10 clk = ~clk;

//Instantiate the module
mod_n_counter #(.N(N)) mod0 (.clk(clk), .rst(rst), .count(count));

initial begin
    //Dump the waveform for simulation
    $dumpfile("modn_tb.vcd");
    $dumpvars(0, modn_tb);

    //Log
    $display("Mod N Counter Testbench");
    $monitor("count = %d, clk = %b", count, clk);

    //Test Cases
    rst = 1; #20;
    rst = 0; #100;
    $finish;

end

endmodule