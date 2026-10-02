module jk_ff (
    //input variables
    input clk,
    input J,
    input K,
    input rst,

    //output variables
    output reg Q,
    output Qbar
);

// make it trigger on the positive edge of the clock, this is the synchronous version
always @(posedge clk) begin
    if(rst) begin
        Q <= 0;
    end else begin
        // all the cases for the JK flip-flop
        case ({J, K})
            2'b00: Q <= Q;
            2'b01: Q <= 0;
            2'b10: Q <= 1;
            2'b11: Q <= ~Q;
        endcase
end
end

assign Qbar = ~Q; // since they should be complementary

endmodule