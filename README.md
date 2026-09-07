# Learning FPGA Dev

RTL building blocks I am writing from scratch in Verilog, on the way to a single cycle processor
core running a custom ISA. Each folder is one piece of the datapath with its design file, a
testbench for it, and usually a waveform dump.

Everything is simulated with Icarus Verilog and viewed in GTKWave out of the OSS CAD Suite. Once
the core is together the plan is to take it through logic synthesis and place and route with
Yosys and nextpnr.

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

## What is built so far

In the order I did them, since most of them build on the one before it.

| Folder | Module | Testbench | What it does |
| --- | --- | --- | --- |
| half_adder | `half_adder` | `half_adder_tb.v` | Sum is a XOR b, carry is a AND b. Simplest place to start. |
| full_adder | `full_adder` | `full_adder_tb.v` | Two half adders with the two carries OR'd together. First time I made a module out of smaller modules instead of writing all the logic directly. |
| ripple_carry_adder_N | `rcN_adder` | `ripple_carry_N_adder_tb.v` | N bit adder, change the parameter to change the width. A generate loop makes N full adders and the carry chain runs through a wire [N:0] connecting each one to the next. Tested at N = 4. The ALU add path gets built on this. |
| muxes | `mux_2to1`, `mux_4to1`, `mux_8to1` | `muxstb.v` | 2 to 1 is just a ternary in an assign, the 4 to 1 and 8 to 1 use a case inside always @(*). These are what select between ALU results and pick register file read ports later on. |
| demuxes | `dmux_1to2`, `dmux_1to4`, `dmux_1to8` | `demux_tb.v` | Built these out of each other. The 1 to 4 is three 1 to 2 demuxes, and the 1 to 8 is a 1 to 2 feeding two 1 to 4s. Had to add ifndef include guards so the shared files don't get included twice. |
| decoders | `n_decoder` | `n_decoder_tb.v` | N to 2^N decoder. Instead of writing out the whole truth table the output is just 1 << in, which gives the one hot output. Tested as a 2 to 4. The register file write port and instruction decode both need this. |
| encoders | `_encoder8to3` | `encoder_tb.v` | Plain 8 to 3 encoder, just OR gates on the input bits. Only works if the input is one hot, it can't tell an input of 0 from an input of 1 because both come out as 000. |
| encoders | `priorityEn8_3` | `priority_tb.v` | Priority encoder I did after, to fix that. casez with ? wildcards grabs the highest set bit, so an input with several bits set still gives a sensible answer. |
| comparator | `mag_comp_N` | `mag_comp_tb.v` | N bit magnitude comparator with three outputs for a < b, a == b and a > b. Tested at N = 4. The branch conditions in the ISA come off of this. |

## Notes to self

The testbenches don't check themselves. They print with $monitor or $display and I compare it to
the truth table by eye. Most of them dump a vcd too so I can open it in GTKWave and confirm it
there instead of only trusting the terminal. Once the blocks get bigger than a truth table I want
to move the checking into cocotb so the tests actually pass or fail on their own.

Where the width is the interesting part (adder, decoder, comparator) the module is written with a
parameter N and the testbench picks the actual width when it instantiates it. Keeping them
parameterized means I can pull the same modules into the 8 bit datapath without rewriting them.

## What is next

Rest of the datapath first. Subtractor off the adder using twos complement, then the 8 bit ALU,
then sequential logic so flip flops and registers and from there the register file, and a barrel
shifter for the shift instructions.

After that the core itself. A minimal custom ISA of about 8 to 10 instructions, then a single
cycle implementation wiring the datapath to a control unit built on the decoder. cocotb
testbenches to verify it properly, then Yosys and nextpnr to get it synthesized and placed and
routed.
