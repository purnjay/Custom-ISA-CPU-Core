`timescale 1ns / 1ps
`include "../muxes/2to1.v" // include the 2 to 1 mux module
`include "../muxes/4to1.v" // include the 4 to 1 mux module
`include "../muxes/8to1.v" // include the 8 to 1 mux module

module muxtb;

reg [1:0] a = 2'b01; // input for 2 to 1 mux 
reg sel; //selection input for 2 to 1 mux

reg [3:0] b = 4'b0101; // input for 4 to 1 mux
reg [1:0] sel4; //selection input for 4 to 1 mux


reg [7:0] c = 8'b01010101; // input for 8 to 1 mux
reg [2:0] sel8; //selection input for 8 to 1 mux

wire out1, out2, out3; // output bit for muxes

mux_2to1 m0(.a(a[0]), .b(a[1]), .sel(sel), .out(out1)); // instantiate the 2 to 1 mux

mux_4to1 m1(.a(b), .sel(sel4), .out(out2)); // instantiate the 4 to 1 mux

mux_8to1 m2(.a(c), .sel(sel8), .out(out3)); // instantiate the 8 to 1 mux


initial begin 

    $dumpfile("muxes.vcd");
    $dumpvars(0, muxtb);
    
    $display("Testing 2 to 1 mux");
    sel = 1'b0; 
    #5; // select a[0]
    $display("sel=%b === out=%b", sel, out1);
    sel = 1'b1;
    #5; // select a[1]
    $display("sel=%b === out=%b", sel, out1);

    $display("\nTesting 4 to 1 mux");
    sel4 = 2'b00; 
    #5; // select b[0]
    $display("sel=%b === out=%b", sel4, out2);
    sel4 = 2'b01; 
    #5; // select b[1]
    $display("sel=%b === out=%b", sel4, out2);
    sel4 = 2'b10; 
    #5; // select b[2]
    $display("sel=%b === out=%b", sel4, out2);
    sel4 = 2'b11; 
    #5; // select b[3]
    $display("sel=%b === out=%b", sel4, out2);


    $display("\nTesting 8 to 1 mux");
    sel8 = 3'b000;
    #5; // select c[0]
    $display("sel=%b === out=%b", sel8, out3);

    sel8 = 3'b001;
    #5; // select c[1]
    $display("sel=%b === out=%b", sel8, out3);

    sel8 = 3'b010;
    #5; // select c[2]
    $display("sel=%b === out=%b", sel8, out3);

    sel8 = 3'b011;
    #5; // select c[3]
    $display("sel=%b === out=%b", sel8, out3);

    sel8 = 3'b100;
    #5; // select c[4]
    $display("sel=%b === out=%b", sel8, out3);

    sel8 = 3'b101;
    #5; // select c[5]
    $display("sel=%b === out=%b", sel8, out3);
    
    sel8 = 3'b110;
    #5; // select c[6]
    $display("sel=%b === out=%b", sel8, out3);

    sel8 = 3'b111;
    #5; // select c[7]
    $display("sel=%b === out=%b", sel8, out3);
end 
endmodule