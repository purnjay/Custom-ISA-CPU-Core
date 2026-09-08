module barrel_shifter(
    input [7:0] in, // 8 bit input for the shifter
    input [2:0] shifting, // shift amount 

    output [7:0] out_shifted // shifted output 
);

wire [7:0] out0, out1; // wires to carry the value through

assign out0 = shifting[0] ? {in[6:0], 1'b0} : in; // we shift this by 1
assign out1 = shifting[1] ? {out0[5:0], 2'b00} : out0; // we shift this by 2 
assign out_shifted = shifting[2] ? {out1[4:0], 4'b0000} : out1; // we shift this by 4

endmodule