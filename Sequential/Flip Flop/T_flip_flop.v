`include "D_Flip_Flop.v"

module t_flip_flop(
    input T,        // the toggle input
    input clk,      // the clock signal
    input rst,
    output Q,       // the Q signal
    output Qbar     // the Qbar signal
);

wire D;             // carrying the combined XOR 

assign D = (T ^ Q) & ~rst; // Just need to add an XOR gate with synchronous reset so Q isn't stuck in x

// Instantiate a d flip flop 
d_flip_flop dff0(.D(D), .clk(clk), .Q(Q), .Qbar(Qbar));

endmodule