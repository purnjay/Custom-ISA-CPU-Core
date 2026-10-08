// BI-DIRECTIONAL SHIFT REGISTER

module BDSR #(parameter N = 4) (
    input clk,
    input rst,
    input R_Lshift, // 0 for left and 1 for right
    input d,
    output q
);

// to hold in the values
reg [N-1:0] shift_reg;

always @(posedge clk) begin
    if(rst)
        shift_reg <= 0; // reset behaviour
    else if (!R_Lshift)
        shift_reg <= {shift_reg[N-2:0], d}; // left shift
    else
        shift_reg <= {d, shift_reg[N-1:1]}; // right shift  
end

//Assign the q value based on the shift direction
assign q = R_Lshift ? shift_reg[0] : shift_reg[N-1];

endmodule