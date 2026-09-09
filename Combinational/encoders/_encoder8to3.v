module _encoder8to3 (
    input [7:0] in, // 8-bit input for the encoder
    output reg [2:0] out // 3-bit output for the encoder
);

// always block to implement the encoder logic
always @(*) begin
    out = 0;
    out[0] = in[7] | in[5] | in[3] | in[1]; // LSB
    out[1] = in[7] | in[6] | in[3] | in[2]; // middle bit
    out[2] = in[7] | in[6] | in[5] | in[4]; // MSB
end

endmodule