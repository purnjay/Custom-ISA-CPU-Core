// PARALLEL IN PARALLEL OUT SHIFT REGISTER

module PIPO #(parameter N = 4) (
    input clk,
    input rst,
    input [N-1:0] d,
    output reg [N-1:0] q
);

always @(posedge clk) begin
    if(rst)
        q <= {N{1'b0}};
    else
        q <= d;
end

endmodule