//SERIAL IN SERIAL OUT SHIFT REGISTER

module SISO #(parameter N = 1)(
    input d,
    input clk,
    input rst,
    output q
);

reg [N-1:0] shift_reg;

always @(posedge clk) begin
    if(rst)
        shift_reg <= 0; // reset behaviour
    else if (N==1)
        shift_reg <= d; // if N == 1 then make it a simple D flip flop 
    else
        shift_reg <= {shift_reg[N-2:0], d}; // shift the values ahead 
end

assign q = shift_reg[N-1]; // assign the q as the value of the last shift reg

endmodule
