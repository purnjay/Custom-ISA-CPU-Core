module half_adder(
    input a, // The input A
    input b, // The input B
    output sum, // The output in which the sum will be calculated
    output carry // The carry bit 
);

// Now we implement the half adder logic
assign sum = a ^ b; // The Sum is the exclusive OR of the inputs, 
assign carry = a & b; // The carry is the and of the inputs

endmodule
