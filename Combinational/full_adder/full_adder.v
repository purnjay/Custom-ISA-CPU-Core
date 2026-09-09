`include "../half_adder/half_adder.v"
module full_adder(
    input a, 
    input b, 
    input cin, 
    output total_sum, 
    output cout
);

// Wires to hold the immediate values from the first half adder
wire sum1;
wire cout1;

// Wire to hold the c_out from the second half adder
wire cout2;

// Making a full adder out of half adders, whose output will be forwarded to the next half_adder 
half_adder ha1(.a(a), .b(b), .sum(sum1), .carry(cout1));

// Second Half Adder to combine the sum from the first half adder with the carry input
half_adder ha2(.a(cin), .b(sum1), .sum(total_sum), .carry(cout2));

// Assigning the final carry out for the full adder
assign cout = cout1 | cout2; 

endmodule