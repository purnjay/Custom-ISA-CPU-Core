//PARALLEL IN SERIAL OUT SHIFT REGISTER
`include "../Register/n_bit_register.v"

module PISO #(parameter N = 4)(
    input [N-1:0] d,
    input clk,
    input SH_LD, // Shift Load: 1 for shift, 0 for load
    input rst,

    output [N-1:0] shift_out,
    output q
);

// to carry the other D forward based on SH_LD
wire [N-2:0] d_in;

//Instantiate the the first d flip flop
n_bit_register #(1) dff0(.d(d[0] & ~SH_LD), .clk(clk), .rst(rst), .q(shift_out[0]), .en(1'b1));

genvar i;

// for loop to generate the remaining D flip-flops
generate
    for (i = 0; i < N - 1; i = i + 1) begin : gen_dff
        // Assign the input to the flip flops based on the shift / load signal
        assign d_in[i] = (shift_out[i] & SH_LD) | (d[i + 1] & ~SH_LD);
        // Instantiate the d flip flops and chain them together with the inputs 
        n_bit_register #(1) dff(.d(d_in[i]), .clk(clk), .rst(rst), .q(shift_out[i + 1]), .en(1'b1));
    end
endgenerate

// Assign the last shift register output to the q output
assign q = shift_out[N-1];

endmodule