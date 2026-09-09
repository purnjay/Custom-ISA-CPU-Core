// Implementing a 8 to 1 mux 
module mux_8to1(
    input [7:0] a, // normal inputs
    input [2:0] sel, // the selection input is a 3 bit wide input
    output reg out // output 
);

// always block for the 8 to 1 mux, it will check the value of sel and assign the corresponding input to the output
always @(*) begin
    case(sel)
        3'b000 : out = a[0]; 
        3'b001 : out = a[1]; 
        3'b010 : out = a[2]; 
        3'b011 : out = a[3]; 
        3'b100 : out = a[4]; 
        3'b101 : out = a[5]; 
        3'b110 : out = a[6]; 
        3'b111 : out = a[7]; 
    endcase
end
endmodule