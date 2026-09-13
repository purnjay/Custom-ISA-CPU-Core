`timescale 1ns/1ps
`include "SR_Latch.v"

module sr_latch_tb;
    reg s, r; // inputs for set and reset
    wire q, qbar; //outputs for q and qbar

    // Instantiate the module
    SR_Latch dut (.set(s), .reset(r), .Q(q), .Qn(qbar));

    initial begin

        // dump vcd for debugging 
        $dumpfile("sr_latch.vcd");
        $dumpvars(0, sr_latch_tb);

        // prints the values on every change 
        $monitor("s=%b r=%b | q=%b qbar=%b", s, r, q, qbar);

        s=1; r=0; #5;   // SET   -> q should go 1
        s=0; r=0; #5;   // HOLD  -> q should stay 1  
        s=0; r=1; #5;   // RESET -> q should go 0
        s=0; r=0; #5;   // HOLD  -> q should stay 0 

        $finish;
    end
endmodule