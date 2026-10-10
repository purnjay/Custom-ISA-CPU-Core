// A REGISTER MODULE MADE FROM COMBINED LEARNING EXPERIENCES FROM SEQUENTIAL MODULES 
`include "../Register/n_bit_register.v"
`include "../../Combinational/decoders/n_decoder.v"


module REGISTER #(parameter WIDTH = 8, parameter noOfRegs = 8) (
    // clock and reset signals
    input clk,
    input rst,

    // Write control signals
    input write_en,
    input [WIDTH-1:0] data_in,
    input [$clog2(noOfRegs)-1:0] writeAddr, 

    // Output value and addr for read ports
    output [WIDTH-1:0] rDataA,
    input [$clog2(noOfRegs)-1:0] rAddrA,
    output [WIDTH-1:0] rDataB,
    input [$clog2(noOfRegs)-1:0] rAddrB
);

// signals to get which register should be enabled according to the address
wire [noOfRegs-1:0] write_en_signals;
wire [WIDTH-1:0] reg_out [noOfRegs-1:0]; // array to hold the output of each register

// decoder to generate write enable signals based on the write address and write enable input
wire [noOfRegs-1:0] decode;
n_decoder #($clog2(noOfRegs)) write_decoder(.in(writeAddr), .out(decode));
assign write_en_signals = decode & {noOfRegs{write_en}}; // write enable signals for each register gated by AND gates

genvar i;
generate 
    for (i = 0; i < noOfRegs; i = i + 1) begin : reg_block
        // connected the registers to the enable signals and the data
        n_bit_register #(WIDTH) regs(.clk(clk), .rst(rst), .en(write_en_signals[i]), .d(data_in), .q(reg_out[i]));
    end
endgenerate

//assign the read data outputs based on the read addresses
assign rDataA = (rAddrA == 0) ? {WIDTH{1'b0}} : reg_out[rAddrA];
assign rDataB = (rAddrB == 0) ? {WIDTH{1'b0}} : reg_out[rAddrB];

// the above statement handles x0 case also which means if the address is 0 for the read ports, the output will be 0 regardless of the register contents

endmodule