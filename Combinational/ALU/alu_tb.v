`timescale 1ps/1ps
`include "ALU.v"

module alu_tb;

reg [7:0] a;
reg [7:0] b;
reg [2:0] opcode;

wire [7:0] result;

wire o, z_, n, c;

ALU a0(.a(a), .b(b), .op(opcode), .result(result), .overflow(o), .zero(z_), .negative(n), .carry(c));

initial begin
    $display("Testing the ALU");
    $monitor("A: %d B: %d OPCODE:%b Result:%d | Overflow:%b Zero:%b Neg:%b Cout:%b", a, b, opcode, result, o, z_, n, c);

    a=8'b01010000; b=8'b00100010; opcode=3'b000; #5;   // ADD
    a=8'b01010100; b=8'b00110010; opcode=3'b001; #5;   // SUB
   
    // SUB to zero for checking zero flag
    a=8'd42; b=8'd42; opcode=3'b001; #5;   // 42-42 = 0, zero=1

    // AND
    a=8'b11110000; b=8'b10101010; opcode=3'b010; #5;   //  should be 10100000

    // OR
    a=8'b11110000; b=8'b00001111; opcode=3'b011; #5;   // should be = 11111111

    // XOR
    a=8'b11111111; b=8'b10101010; opcode=3'b100; #5;   // should be = 01010101

    // NOT
    a=8'b00001111; b=8'd0;        opcode=3'b101; #5;   //  should be = 11110000

    // overflow case: 127+1
    a=8'd127; b=8'd1; opcode=3'b000; #5;   //  should be overflow = 1, neg = 1


end
endmodule