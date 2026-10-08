// SERIAL IN PARALLEL OUT SHIFT REGISTER
`include "SISO.v"

module SIPO #(parameter N = 4)
(
    input d,
    input clk,
    input rst,
    output [N-1:0] q
);

// Instiantiate the SISO module
SISO #(N) siso_inst(.d(d), .clk(clk), .rst(rst), .shift_reg_out(q));

endmodule