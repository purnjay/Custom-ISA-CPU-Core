`timescale 1ns/1ps
`include "mag_comparator.v"

module mag_comp_tb();

//inputs to test the comparator
reg [3:0] a;  
reg [3:0] b;

wire [2:0] out; // outputs from the module

//instantiate the comparator as a 4 bit comparator
mag_comp_N #(.N(4)) c0(.a(a), .b(b), .result_less_than(out[0]), .result_equal_to(out[1]), .result_greater_than(out[2]));

// To test the conditions
initial begin
    $display("Testing the Comparator");

    $monitor("A:%d B:%d | A<B:%b A=B:%b A>B:%b", a, b, out[0], out[1], out[2]);
    
    // different test cases
    a = 4'b1010; b = 4'b1110; #5;
    a = 4'b1011; b = 4'b1100; #5;
    a = 4'b1010; b = 4'b1010; #5;
    a = 4'b1001; b = 4'b1100; #5;
    a = 4'b1111; b = 4'b1110; #5;
    a = 4'b1111; b = 4'b1100; #5;
end
endmodule