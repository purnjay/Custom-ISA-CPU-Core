`include "./add_sub/add_sub.v"

//------------------------
// ARTHEMATIC LOGIC UNIT
//------------------------

// This is the culmination of my phase 1 of verilog building blocks

module ALU(

    input [7:0] a,              // input a
    input [7:0] b,              // input b 
    input [2:0] op,             // OP codes for selecting certain operations

    output reg [7:0] result,    // the output from the ALU

    output overflow,            // the output to show any overflow
    output zero,                // if the result is all 0
    output negative,            // if the result is negative
    output carry                // if the result has any carry out from the add/sub
);

// OPCODE MAPPING
/*
    CODE    |   OPERATION
    000     |      ADD
    001     |      SUB
    010     |      AND
    011     |      OR
    100     |      XOR
    101     |      NOT
    110     |      Unused
    111     |      Unused
*/

// the output variable to capture the value for add_sub
wire [7:0] add_sub_result;

wire o; //for storing overflow
wire cout; // for storing cout

wire sel = (op == 3'b001); //only will be 1 if it matches, 0 otherwise

//add sub module to be instantiated 
add_sub a0(.a(a), .b(b), .sel(sel), .result(add_sub_result), .overflow(o), .cout(cout));


always @(*) begin

    case(op)

        //ADD
        3'b000: 
        result = add_sub_result;

        //SUB
        3'b001: 
        result = add_sub_result;

        //AND
        3'b010:
        result = a & b; 

        //OR
        3'b011:
        result = a | b; 

        //XOR
        3'b100:
        result = a ^ b;

        //NOT
        3'b101:
        result = ~a;

        // default case
        default: 
        result = 8'b0;
    endcase
end

    assign carry = cout; // get the carry out from the end of the ripple carry adder
    assign overflow = o; // get if the number overflowed into signed territory
    assign negative = result[7]; // by taking the MSB

    // this basically or's every bit in the result and then nots it 
    assign zero = ~|result; // oring would mean 0 if every result element is 0 or 1, if it's 0 and not would make it 1 

endmodule