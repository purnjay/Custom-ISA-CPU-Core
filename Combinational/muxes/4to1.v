// Implementing a 4 to 1 mux 
module mux_4to1(
    input [3:0] a, // normal inputs
    input [1:0] sel, // the selection input is a 2 bit wide input
    output reg out // output 
);

always @(*) begin
    case(sel)
        2'b00 : out = a[0]; // if sel is 00 then output will be a[0]
        2'b01 : out = a[1]; // if sel is 01 then output will be a[1]
        2'b10 : out = a[2]; // if sel is 10 then output will be a[2]
        2'b11 : out = a[3]; // if sel is 11 then output will be a[3]
    endcase
end
endmodule