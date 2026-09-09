`timescale 1ns/1ps
`include "priorityEn8_3.v"

module priority_tb;

// testcases for the 8-to-3 priority encoder
reg [7:0] in; // 8-bit input for the encoder
wire [2:0] out; // 3-bit output for the encoder

priorityEn8_3 p0(.in(in), .out(out)); // instantiate the priority encoder module

    initial begin
        $dumpfile("priority_tb.vcd"); // create a VCD file to store the simulation results
        $dumpvars(0, priority_tb); // dump all variables in the testbench
        
        $display("Starting the testbench for priority_encoder");
        $display("8 to 3 Priority Encoder Testbench");

        $monitor("Input: %b | Output: %b", in, out); // monitor the input and output values
        in = 8'b10000001; #5;
        in = 8'b00000010; #5;
        in = 8'b01000100; #5;
        in = 8'b00001010; #5;
        in = 8'b00010000; #5;
        in = 8'b00100000; #5;
        in = 8'b01000000; #5;
        in = 8'b00000000; #5;
    end
endmodule