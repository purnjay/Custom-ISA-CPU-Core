`include "../SR_Latch/SR_Latch.v"

// Modelling a D latch
module D_latch(
    input D,        //input variable 
    input enable,   // enable input for the latch
    output Qbar,    // output bar value
    output Q       // output value
);

//inputs that will go into a SR_latch
wire set = D & enable;
wire reset = ~D & enable; //This ensures that the S and R input are always opposite 

//instantiate the SR latch so we can connect it 
SR_Latch s0(.set(set), .reset(reset), .Q(Q), .Qn(Qbar));

endmodule