# Learning FPGA Dev

This is me learning digital design in Verilog from the ground up. Each folder is one building
block, with the design file, a testbench for it, and usually a waveform dump.

Everything is simulated with Icarus Verilog and viewed in GTKWave. No FPGA board yet. Right now
I just want the logic to be correct and to actually see it working on a waveform.

## Running a testbench

The testbenches include the design files with relative paths, so cd into the folder first, then
compile and run it:

```
cd decoders
iverilog -o n_decoder_tb.out n_decoder_tb.v
vvp n_decoder_tb.out
gtkwave n_decoder_tb.vcd
```

You only pass the testbench to iverilog, it already includes the design file it needs. Same thing
for every other folder, just swap in that testbench name.

The .v.out and .vcd files sitting in the folders are just compiler and simulation output, the
commands above make them again.

## What I have built so far

In the order I did them, since most of them build on the one before it.

**half_adder** (half_adder_tb.v)
Sum is a XOR b, carry is a AND b. Simplest place to start.

**full_adder** (full_adder_tb.v)
Two half adders with the two carries OR'd together. First time I made a module out of smaller
modules instead of writing all the logic directly.

**ripple_carry_adder_N** (ripple_carry_N_adder_tb.v)
N bit adder, change the parameter to change the width. A generate loop makes N full adders and
the carry chain runs through a wire [N:0] connecting each one to the next. Testbench runs it at
N = 4.

**muxes** (muxstb.v)
2 to 1 is just a ternary in an assign. The 4 to 1 and 8 to 1 use a case inside always @(*).

**demuxes** (demux_tb.v)
Built these out of each other. The 1 to 4 is three 1 to 2 demuxes, and the 1 to 8 is a 1 to 2
feeding two 1 to 4s. Had to add ifndef include guards so the shared files don't get included
twice.

**decoders** (n_decoder_tb.v)
N to 2^N decoder. Instead of writing out the whole truth table the output is just 1 << in, which
gives you the one hot output. Testbench runs it as a 2 to 4.

**encoders** (encoder_tb.v and priority_tb.v)
The plain 8 to 3 encoder is OR gates on the input bits. It only works if the input is one hot,
it can't tell an input of 0 from an input of 1 because both come out as 000. That is why I did
the priority encoder after, it uses casez with ? wildcards to grab the highest set bit, so an
input with multiple bits set still gives a sensible answer.

**comparator** (mag_comp_tb.v)
N bit magnitude comparator with three outputs for a < b, a == b and a > b. Tested at N = 4.

## Notes to self

The testbenches don't check themselves. They print with $monitor or $display and I compare it to
the truth table by eye. Most of them dump a vcd too so I can open it in GTKWave and confirm it
there instead of only trusting the terminal.

Where the width is the interesting part (adder, decoder, comparator) the module is written with
a parameter N and the testbench picks the actual width when it instantiates it.

## Next

Done with combinational logic for the most part. Next is sequential, so flip flops, registers,
counters and state machines. After that I want to get something onto real hardware with an
actual synthesis flow and pin constraints.
