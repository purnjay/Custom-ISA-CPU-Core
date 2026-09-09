`timescale 1ps/1ps
`include "demux_1to2.v" // include the demux module
`include "demux_1to4.v" // include the demux module
`include "demux_1to8.v" // include the demux module

module demux_tb;

// variables for 1 to 2 demux
reg a; // input to the demux
reg sel; // selection input
wire [1:0] out; // outputs

//vairables for 1 to 4 demux
reg b; // input to the demux
reg [1:0] sel4; // selection input
wire [3:0] out4; // outputs

//variables for 1 to 8 demux
reg c; // input to the demux
reg [2:0] sel8; // selection input
wire [7:0] out8; // outputs

// instantiate the demuxs
dmux_1to2 d1(.a(a), .sel(sel), .out0(out[0]), .out1(out[1]));
dmux_1to4 d2(.a(b), .sel(sel4), .out(out4));
dmux_1to8 d3(.a(c), .sel(sel8), .out(out8));

initial begin
    // dump waveform for debugging
    $dumpfile("demux.vcd");
    $dumpvars(0, demux_tb);

    $display("Testing 1 to 2 demux");
    $monitor("a=%b sel=%b | out=%b", a, sel, out);
    a = 1'b0; sel = 1'b0; #5;
    a = 1'b1; sel = 1'b0; #5;
    a = 1'b0; sel = 1'b1; #5;
    a = 1'b1; sel = 1'b1; #5;

    $display("\nTesting 1 to 4 demux");
    $monitor("b=%b sel4=%b | out4=%b", b, sel4, out4);
    b = 1'b0; sel4 = 2'b00; #5;
    b = 1'b1; sel4 = 2'b00; #5;
    b = 1'b0; sel4 = 2'b01; #5;
    b = 1'b1; sel4 = 2'b01; #5;
    b = 1'b0; sel4 = 2'b10; #5;
    b = 1'b1; sel4 = 2'b10; #5;
    b = 1'b0; sel4 = 2'b11; #5;
    b = 1'b1; sel4 = 2'b11; #5;

    $display("\nTesting 1 to 8 demux");
    $monitor("c=%b sel8=%b | out8=%b", c, sel8, out8);
    c = 1'b0; sel8 = 3'b000; #5;
    c = 1'b1; sel8 = 3'b000; #5;
    c = 1'b0; sel8 = 3'b001; #5;
    c = 1'b1; sel8 = 3'b001; #5;
    c = 1'b0; sel8 = 3'b010; #5;
    c = 1'b1; sel8 = 3'b010; #5;
    c = 1'b0; sel8 = 3'b011; #5;
    c = 1'b1; sel8 = 3'b011; #5;
    c = 1'b0; sel8 = 3'b100; #5;
    c = 1'b1; sel8 = 3'b100; #5;
    c = 1'b0; sel8 = 3'b101; #5;
    c = 1'b1; sel8 = 3'b101; #5;
    c = 1'b0; sel8 = 3'b110; #5;
    c = 1'b1; sel8 = 3'b110; #5;
    c = 1'b0; sel8 = 3'b111; #5;
    c = 1'b1; sel8 = 3'b111; #5;

    $finish;
end

endmodule