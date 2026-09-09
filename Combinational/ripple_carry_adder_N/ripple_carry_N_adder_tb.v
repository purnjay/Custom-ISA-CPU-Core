`timescale 1ns / 1ps
`include "../ripple_carry_adder_N/ripple_carry_N_adder.v" // include the N bit ripple carry adder module

module rcn_adder_tb;
reg [3:0] a, b; // Inputs are N bit wide
reg cin; // The carry input is a single bit
wire [3:0] sum; // The sum output is also N bit Wide
wire cout; // The carry output is a single bit

rcN_adder ripple_adder(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout)); // instantiate the N bit ripple carry adder with N=4
    
    initial begin

        // dump waveform for debugging
        $dumpfile("RCN.vcd");
        $dumpvars(0, rcn_adder_tb);

        // test case of 10 + 5 with carry in 0
        a = 4'b1010; b = 4'b0101; cin = 1'b0;  
        #10;
        $display("A=%d B=%d Cin=%d | Sum=%d Cout=%d", a, b, cin, sum, cout);
        $display("A=%b B=%b Cin=%b | Sum=%b Cout=%b", a, b, cin, sum, cout);
        $finish;
    end
endmodule