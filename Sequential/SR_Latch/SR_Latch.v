`timescale 1ps/1ps
module SR_Latch(
    input set, // the set input for the latch
    input reset, // the reset input for the latch 
    
    output Q,    // the output value for the latch
    output Qn    // the output value for the latch
);

nor(Q, reset, Qn); // Q here is the result of NOR of reset and Qbar
nor(Qn, set, Q); // Qn here is the result of NOR of set and Q


endmodule