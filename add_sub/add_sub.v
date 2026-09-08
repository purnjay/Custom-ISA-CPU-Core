`include "../ripple_carry_adder_N/ripple_carry_N_adder.v"


module add_sub(

    // inputs for the add_sub unit
    input [7:0] a,
    input [7:0] b,
    input sel, // we use 0 for adding, 1 for subtracting 

    // output the result
    output [7:0] result,
    output overflow
);

// wire to cary xor'ed b input 
wire [7:0] b_sub = b ^ {8{sel}};

// carry bits for the last and the second last 
wire carry0, carry1; 

// instantiate the ripple carry adder as 8 bit
rcN_adder #(.N(8)) r0(.a(a), .b(b_sub), .cin(sel), .sum(result), .cout(carry1));

// second last carry = carry into the top bit, derived from the sign bits
assign carry0 = a[7] ^ b_sub[7] ^ result[7];

// the overflow is calculated by xoring the second last carry and last carry 
assign overflow = carry0 ^ carry1;

endmodule