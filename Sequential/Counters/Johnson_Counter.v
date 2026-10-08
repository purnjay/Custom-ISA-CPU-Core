`timescale 1ns / 1ps

module johnson_counter #(parameter N = 4)(
    input clk,
    input rst,
    output reg [N-1:0] q
);

always @(posedge clk) begin
    if (rst) 
        q <= 0;
    else
        q <= {q[N-2:0], ~q[N-1]}; 
end

endmodule