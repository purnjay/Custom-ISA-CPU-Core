module n_decoder #(parameter N=1)(
    input [N-1:0] in,
    output reg [2**N-1:0] out
);

// always block to implement the decoder logic
always @(*) begin
    out = 0; // initialize output to 0

    // we bit shift 1 using the input value to set the output 
    // this means that when the input is 0 -> the output is 0001
    // and when the input is 1 then the output is 0010 and vice versa
    out = 1 << in;
end


/* example truth table for a 2-to-4 decoder that I used to understand how decoders work
bits | y3 | y2 | y1 | y0
  00 | 0  | 0  | 0  | 1
  01 | 0  | 0  | 1  | 0
  10 | 0  | 1  | 0  | 0
  11 | 1  | 0  | 0  | 0
*/

endmodule