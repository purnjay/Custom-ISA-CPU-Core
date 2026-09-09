`timescale 1ps/1ps
`include "add_sub.v"

module add_sub_tb;

// inputs for the add_sub unit
reg [7:0] a; // first operand
reg [7:0] b; // second operand
reg sel; // 0 for adding, 1 for subtracting

// outputs from the add_sub unit
wire signed [7:0] result; // the result of the operation
wire overflow; // signed overflow flag

// instantiate the add_sub unit
add_sub u0(.a(a), .b(b), .sel(sel), .result(result), .overflow(overflow));

initial begin
    // dump waveform for debugging
    $dumpfile("add_sub.vcd");
    $dumpvars(0, add_sub_tb);

    $display("Testing add_sub unit");
    $monitor("a=%d b=%d sel=%d | result=%0d overflow=%b", a, b, sel, result, overflow);

    // test cases
    a = 8'd6; b = 8'd3; sel = 0; #5; // 6 + 3 = 9
    a = 8'd6; b = 8'd3; sel = 1; #5; // 6 - 3 = 3
    a = 8'd3; b = 8'd6; sel = 1; #5; // 3 - 6 = -3
    a = 8'd127; b = 8'd1; sel = 0; #5; // 127 + 1 overflows to -128
    a = 8'd255; b = 8'd1; sel = 0; #5; // -1 + 1 = 0, no overflow

    $finish;
end

endmodule