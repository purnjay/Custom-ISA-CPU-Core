
module n_bit_register #(parameter N = 4)
(
    input [N-1:0] d,
    input clk,
    input rst,
    input en,
    output reg [N-1:0] q
);

always @(posedge clk) begin
    if(rst)
        q <= 0;
    else if (en)
        q <= d;
end
endmodule