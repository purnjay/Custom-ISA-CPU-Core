
module counter_up_down #(parameter N = 4) (
    input clk,
    input rst,
    input dir, // direction: 1 for up, 0 for down
    output reg [N-1:0] q
);

always @(posedge clk) begin
    if (rst)
        q <= 0;
    else if(dir)
        q <= q + 1; // increment by one
    else
        q <= q - 1; // decrement by one
        
        
end

endmodule