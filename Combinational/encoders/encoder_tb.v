`timescale 1ns / 1ps
`include "_encoder8to3.v"

module encoder_tb;

reg [7:0] in; // 8 bit input for the encoder
wire [2:0] out; // 3 bit output for the encoder

_encoder8to3 e0(.in(in), .out(out)); // instantiate the encoder module

initial begin
    $dumpfile("encoder_tb.vcd"); // create a VCD file to store the simulation results
    $dumpvars(0, encoder_tb); // dump all variables in the testbench
    
    $display("Starting the testbench for _encoder8to3");
    $display("8 to 3 Encoder Testbench");

    // testcases for the 8-to-3 encoder
    $monitor("Input: %b | Output: %b", in, out); // monitor the input and output values
    in = 8'b00000001; #5;
    in = 8'b00000010; #5;
    in = 8'b00000100; #5;
    in = 8'b00001000; #5;
    in = 8'b00010000; #5;
    in = 8'b00100000; #5;
    in = 8'b01000000; #5;
    in = 8'b10000000; #5;
end
endmodule