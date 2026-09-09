`include "demux_1to2.v"

`ifndef DMUX_1TO4_V
`define DMUX_1TO4_V

module dmux_1to4(
    input a, // input to the demux
    input [1:0] sel, // selection input
    output [3:0] out // outputs 0-3
);

wire carry0, carry1; // wires to connect the two 1 to 2 demuxes

// using 3, 1 to 2 demuxes to implement a 1 to 4 demux
dmux_1to2 d1(.a(a), .sel(sel[0]), .out0(carry0), .out1(carry1));
dmux_1to2 d2(.a(carry0), .sel(sel[1]), .out0(out[0]), .out1(out[1]));
dmux_1to2 d3(.a(carry1), .sel(sel[1]), .out0(out[2]), .out1(out[3]));  

endmodule
`endif