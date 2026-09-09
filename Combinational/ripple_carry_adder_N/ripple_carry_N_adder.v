`include "../full_adder/full_adder.v" // include the full adder module

module rcN_adder #(parameter N = 4) // This parameter can be changed to implement an N-bit rippe carry adder
(
    input [N - 1:0] a, b, // Inputs are N bit wide 
    input cin, // The carry input is a single bit 
    output [N - 1:0] sum, // The sum output is also N bit Wide 
    output cout // The carry output is a single bit
);

wire [N:0] carry;
assign carry[0] = cin; // Assigning the carry input to the first carry wire

genvar i; //temporary variable I for the loop 
        
    generate // start the generate loop to create N instances of the full adder
            for (i = 0; i < N; i = i + 1) begin: adder // start of the loop
                full_adder fa (.a(a[i]), .b(b[i]), .cin(carry[i]), .total_sum(sum[i]), .cout(carry[i + 1])); // instantiation of the full adder module
            end
    endgenerate

assign cout = carry[N]; // Assigning the last carry wire to the carry output

endmodule
