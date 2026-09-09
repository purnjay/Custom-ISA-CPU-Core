`timescale 1ns / 1ps
`include "n_decoder.v"

module n_decoder_tb;

// Instantiate the 2-4 decoder module
reg [1:0] in; // 2-bit input for the decoder
wire [3:0] out; // 4-bit output for the decoder

n_decoder #(.N(2)) d0(.in(in), .out(out)); // instantiate the decoder module

initial begin
    
    $dumpfile("n_decoder_tb.vcd"); // create a VCD file to store the simulation results
    $dumpvars(0, n_decoder_tb); // dump all variables in the testbench
    
    $display("Starting the testbench for n_decoder");
    $display("2 to 4 Decoder Testbench");

    // testcases for the 2-to-4 decoder
    $monitor("Input: %b | Output: %b", in, out); // monitor the input and output values
    in = 2'b00; #5;
    in = 2'b01; #5;
    in = 2'b10; #5;
    in = 2'b11; #5;
end
endmodule