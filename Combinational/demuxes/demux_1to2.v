`ifndef DMUX_1TO2_V
`define DMUX_1TO2_V
module dmux_1to2(
    input a, // input to the demux
    input sel, // selection input
    output reg out0, // output 0
    output reg out1 // output 1
);

always @(*) begin
    if(sel == 1'b0) begin
        out0 = a; // if sel is 0 then output 0 will be a
        out1 = 1'b0; // output 1 will be 0
    end else begin
        out0 = 1'b0; // output 0 will be 0
        out1 = a; // if sel is 1 then output 1 will be a
    end
end
endmodule
`endif