// Register testbench for the REGISTER module

`timescale 1ns / 1ps
`include "REGISTER.v"

module register_tb;

// Parameters for the REGISTER module
parameter WIDTH = 32;        // Width of the registers
parameter noOfRegs = 32;     // Number of registers

// Clock and reset signals
reg clk = 0; 
reg rst = 0;

// Write signals
reg write_en = 0;               // 0 for Read and 1 for Write
reg [WIDTH-1:0] write_data = 0; // Data to be written to the register
reg [4:0] write_addr = 0;       // Address of the register to write to

//Read signals 
reg [4:0] read_addrA = 0;       // First register address 
reg [4:0] read_addrB = 0;       // Second register address 

// Read data outputs
wire [WIDTH-1:0] read_dataA;    // Read data from the first register
wire [WIDTH-1:0] read_dataB;    // Read data from the second register

// clock generation
always #10 clk = ~clk;

// Instantiate the register module
REGISTER #(WIDTH, noOfRegs) r0(.clk(clk), .rst(rst), .write_en(write_en),
    .data_in(write_data), .writeAddr(write_addr), .rDataA(read_dataA),
    .rAddrA(read_addrA), .rDataB(read_dataB), .rAddrB(read_addrB)
);

initial begin

    // Dump the waveforms
    $dumpfile("register_tb.vcd");
    $dumpvars(0, register_tb);

    // Logs
    $display("-------Register Testbench-------");
    $monitor("Write_en: %b | write_addr: %h | write_data: %h | read_addrA: %d | read_dataA: %h | read_addrB: %d | read_dataB: %h",
    write_en, write_addr, write_data, read_addrA, read_dataA, read_addrB, read_dataB);

    // Now we do reset
    rst = 1; #20;
    rst = 0; #20;

    // Now we read the registers to see x0 condition
    write_en = 0; // read mode
    read_addrA = 5'ha; read_addrB = 5'h0; #20;

    // Now check another register to see
    read_addrA = 5'hb; read_addrB = 5'hd; #20;

    // Now we write to a random address
    write_en = 1; // write mode 
    #5; // let the value settle before writing
    write_addr = 5'hc; write_data = 32'h12345678; #20; // write to register c

    $display("----- AFTER WRITE -----");
    // Now read back the value to verify the write
    write_en = 0; // read mode
    read_addrA = 5'hc; read_addrB = 5'h0; #20;
    
    $display("----- AFTER READ BACK -----");
    // write to register c AND read from a/b in the same cycle
    write_en = 1; write_addr = 5'hc; write_data = 32'hAAAA_BBBB;
    read_addrA = 5'h5; read_addrB = 5'h7; #20;

    $finish;

end

endmodule