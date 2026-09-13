// to build off of D Latch
`include "../D/D_latch.v"

module d_flip_flop(
    input D,        // input data
    input clk,      // the clock
    output Q,       // the output
    output Qbar     // the opposite of output 
);

wire Q_carry; // this will carry the Q from Master D latch to slave d latch

D_latch d0(.D(D), .enable(~clk), .Q(Q_carry)); // Master D latch

D_latch d1(.D(Q_carry), .enable(clk), .Q(Q), .Qbar(Qbar)); // Slave D latch

endmodule