`timescale 1ns/1ps
`include "half_adder.v"

module half_adder_tb;
    reg a, b; // register for inputs A and B 
    wire sum, carry; // wire for outputs sum and carry

    //Instatiate the half adder module
    half_adder u0 (.a(a), .b(b), .sum(sum), .carry(carry)); // Instantiation of the half adder module
   
   // Testbench loop to verify correct operation of the half adder
    initial begin

        // Dump waveform for debugging
        $dumpfile("half_adder.vcd");
        $dumpvars(0, u0);

        //Testbench parameters being set, with varying inputs
        a = 0; b = 0;
        #10
        $display("Sum: %b, Carry: %b", sum, carry); // display the output
        a = 0; b = 1;
        #10
        $display("Sum: %b, Carry: %b", sum, carry); // display the output
        a = 1; b = 0;
        #10
        $display("Sum: %b, Carry: %b", sum, carry); // display the output
        a = 1; b = 1;
        #10
        $display("Sum: %b, Carry: %b", sum, carry); // display the output
        $finish; // stop the simulation
    end
endmodule