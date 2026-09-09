module mag_comp_N #(parameter N=1)(

    //Inputs that will go into the comparator 
    input [N-1:0] a,
    input [N-1:0] b,

    // Multiple outputs for results
    output result_less_than,
    output result_equal_to,
    output result_greater_than
);

assign result_less_than = a < b; //compute if a is less than b
assign result_equal_to = a == b; // compute if a is equal to b
assign result_greater_than = a > b; // compute if a is greater than b 

endmodule