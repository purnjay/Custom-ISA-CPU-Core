`include "demux_1to4.v"

`ifndef DMUX_1TO8_V
`define DMUX_1TO8_V

module dmux_1to8(
    input a, // input to the demux
    input [2:0] sel, // selection input
    output [7:0] out // outputs 0-7
);

wire carry1, carry2; // wires to connect the 1 to 4 demuxes

// using 3, 1 to 4 demuxes to implement a 1 to 8 demux
dmux_1to2 d1(.a(a), .sel(sel[2]), .out0(carry1), .out1(carry2));
dmux_1to4 d2(.a(carry1), .sel(sel[1:0]), .out(out[3:0]));
dmux_1to4 d3(.a(carry2), .sel(sel[1:0]), .out(out[7:4]));

endmodule
`endif