`timescale 1ns/1ps
`include "n_bit_register.v"
module n_bit_register_tb;

parameter N = 4;

reg [N-1:0] D = 0;
reg clk = 0;
reg en = 0;
reg rst = 0;

wire [N-1:0] q;

always #10 clk = ~clk;

n_bit_register #(.N(N)) n0(.d(D), .clk(clk), .rst(rst), .en(en), .q(q));

initial begin
    $display("N-Bit Register Testbench");
    $monitor("D = %b, clk = %b, q = %b, en = %b, rst = %b", D, clk, q, en, rst);
    
    #20;
    D = 4'b1010; en = 1;
    #20;
    D = 4'b0101; en = 1; rst = 1;
    #20;
    rst = 0; D = 4'b1111; en = 1;
    #20;
    D = 4'b0011; en = 0;
    #20;
    D = 4'b0100; en = 0;
    #20;
    $finish;
end

endmodule