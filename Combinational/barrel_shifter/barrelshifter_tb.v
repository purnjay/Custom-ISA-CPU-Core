`timescale 1ps/1ps
`include "barrel_shifter.v"

module barrelshifter_tb;

    reg [7:0] in; // 8 bit input for the shifter 
    reg [2:0] shift_amt; // amount to shift by 
    
    wire [7:0] result; // the shifted output 

    integer i; // index variable for the for loop

    //instantiate the barrel shifter module
    barrel_shifter b0(.in(in), .shifting(shift_amt), .out_shifted(result));

    initial begin 
        
        // Generating VCDD for testbench and debugging 
        $dumpfile("barrel.vcd");
        $dumpvars(0, barrelshifter_tb);

        // a testcase 8 bit number 
        in = 8'b00000001;
        $display("in = %b", in);

        // for loop for running the verification
        for (i = 0; i < 8; i = i + 1) begin
            shift_amt = i; 
            #5;

            // This will display the shift to verify against the expected shift
            $display("shift=%0d | out=%b  (expected %b)", i, result, (8'b00000001 << i));
        end

        // a second pattern, to see the bits that will get discarded 
        in = 8'b10110010; shift_amt = 3'd3; 
        #5;
        
        $display("\nin=%b shift=3 | out=%b  (expected %b)", in, result, (8'b10110010 << 3));

        $finish;
    end
endmodule