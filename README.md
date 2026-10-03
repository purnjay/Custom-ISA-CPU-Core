# Learning FPGA Dev

RTL building blocks I am writing from scratch in Verilog, on the way to a single cycle processor
core running a custom ISA. Combinational/ has the blocks that are just logic and Sequential/ has
the ones that hold state. Each folder inside them is one piece of the datapath with its design
file, a testbench for it, and usually a waveform dump.

Everything is simulated with Icarus Verilog and viewed in GTKWave out of the OSS CAD Suite. Once
the core is together the plan is to take it through logic synthesis and place and route with
Yosys and nextpnr.

Phase 1 is done. All the combinational blocks are built, they come together in the ALU, and the
ALU has a testbench of its own. Phase 2 is sequential and it has started, the latches, the D, JK
and T flip flops, and an N bit register are done so far.

## Running a testbench

The testbenches include the design files with relative paths, so cd into the folder first, then
compile and run it:

```
cd Combinational/decoders
iverilog -o n_decoder_tb.out n_decoder_tb.v
vvp n_decoder_tb.out
gtkwave n_decoder_tb.vcd
```

You only pass the testbench to iverilog, it already includes the design file it needs. Same thing
for every other folder, just swap in that testbench name. The Flip Flop folder has a space in it,
so put quotes around it when you cd in.

Every module sits at the same depth on purpose, so the .. in the includes always points at the
folder holding all of them and the same two commands work everywhere, ALU included.

The .v.out and .vcd files sitting in the folders are just compiler and simulation output, the
commands above make them again.

## The ALU

`Combinational/ALU/ALU.v`, 8 bits wide, and this is where phase 1 ends up. A 3 bit op picks the
operation, add and sub go through the add_sub unit and the logic ops are done right there in the
case.

| op | operation |
| --- | --- |
| 000 | ADD |
| 001 | SUB |
| 010 | AND |
| 011 | OR |
| 100 | XOR |
| 101 | NOT a |
| 110, 111 | unused, result is 0 |

Four flags come out with the result:

| flag | how it is worked out |
| --- | --- |
| zero | `~\|result`, or every bit in the result and then inverted |
| negative | just the MSB of the result |
| carry | the carry out of the top of the ripple carry adder |
| overflow | from add_sub, signed overflow |

carry and overflow both come off the add_sub path, so they only really mean anything on ADD and
SUB. The logic ops leave whatever the adder happened to produce sitting on them.

## Combinational blocks

All of these live in Combinational/. In the order I did them, since most of them build on the
one before it.

| Folder | Module | Testbench | What it does |
| --- | --- | --- | --- |
| half_adder | `half_adder` | `half_adder_tb.v` | Sum is a XOR b, carry is a AND b. Simplest place to start. |
| full_adder | `full_adder` | `full_adder_tb.v` | Two half adders with the two carries OR'd together. First time I made a module out of smaller modules instead of writing all the logic directly. |
| ripple_carry_adder_N | `rcN_adder` | `ripple_carry_N_adder_tb.v` | N bit adder, change the parameter to change the width. A generate loop makes N full adders and the carry chain runs through a wire [N:0] connecting each one to the next. Tested at N = 4, and the ALU runs it at N = 8. |
| muxes | `mux_2to1`, `mux_4to1`, `mux_8to1` | `muxstb.v` | 2 to 1 is just a ternary in an assign, the 4 to 1 and 8 to 1 use a case inside always @(*). These are what pick register file read ports later on. |
| demuxes | `dmux_1to2`, `dmux_1to4`, `dmux_1to8` | `demux_tb.v` | Built these out of each other. The 1 to 4 is three 1 to 2 demuxes, and the 1 to 8 is a 1 to 2 feeding two 1 to 4s. Had to add ifndef include guards so the shared files don't get included twice. |
| decoders | `n_decoder` | `n_decoder_tb.v` | N to 2^N decoder. Instead of writing out the whole truth table the output is just 1 << in, which gives the one hot output. Tested as a 2 to 4. The register file write port and instruction decode both need this. |
| encoders | `_encoder8to3` | `encoder_tb.v` | Plain 8 to 3 encoder, just OR gates on the input bits. Only works if the input is one hot, it can't tell an input of 0 from an input of 1 because both come out as 000. |
| encoders | `priorityEn8_3` | `priority_tb.v` | Priority encoder I did after, to fix that. casez with ? wildcards grabs the highest set bit, so an input with several bits set still gives a sensible answer. |
| comparator | `mag_comp_N` | `mag_comp_tb.v` | N bit magnitude comparator with three outputs for a < b, a == b and a > b. Tested at N = 4. The branch conditions in the ISA come off of this. |
| add_sub | `add_sub` | `add_sub_tb.v` | 8 bit add and subtract in one unit, sel picks which (0 adds, 1 subtracts). Subtracting works by XOR'ing b with sel to flip it and feeding sel in as the carry in, so it is twos complement through the same ripple carry adder instead of a separate subtractor. Puts out signed overflow and the carry out for the ALU to use. |
| barrel_shifter | `barrel_shifter` | `barrelshifter_tb.v` | 8 bit left shifter for a shift amount of 0 to 7. Three stages of muxes that shift by 1, 2 and 4, so any amount is just the right combination of the three stages instead of a separate shifter per amount. Not wired into the ALU yet. |
| ALU | `ALU` | `alu_tb.v` | Everything above tied together behind a 3 bit op. Written up properly further up. |

## Sequential blocks

All of these live in Sequential/. Same idea as the combinational ones, most of them are built
out of the one before it. All three flip flops are in the Flip Flop folder.

| Folder | Module | Testbench | What it does |
| --- | --- | --- | --- |
| SR_Latch | `SR_Latch` | `SR_Latch_tb.v` | Two cross coupled NOR gates, written with gate primitives instead of an assign. Set pulls Q high, reset pulls it low, and with both at 0 it holds whatever it had. Both at 1 is the invalid state so I stay away from it. |
| D | `D_latch` | `D_Latch_tb.v` | The SR latch with a gate in front of it. set is D & enable and reset is ~D & enable, so they can never both be 1 and the invalid state is gone. Q follows D while enable is high and holds when it drops. |
| Flip Flop | `d_flip_flop` | `D_ff_tb.v` | Master slave, two D latches back to back. The master is open while clk is low and the slave opens when clk goes high, so Q only changes on the rising edge instead of following D the whole time. This is what the registers get built from. |
| Flip Flop | `jk_ff` | `jkff_tb.v` | This one I wrote behaviourally instead of out of gates, an always @(posedge clk) with a case on {J, K}. 00 holds, 01 clears, 10 sets and 11 toggles, so it is basically the SR latch with the invalid state turned into something useful. Has a synchronous reset. |
| Flip Flop | `t_flip_flop` | `tff_tb.v` | Built on the D flip flop with an XOR in front, D = T ^ Q, so T = 1 flips Q every clock and T = 0 holds it. The reset is ANDed into D so Q gets pulled to 0 on the first edge instead of being stuck at x forever, since x XOR anything is still x. |
| Register | `n_bit_register` | `n_bit_register_tb.v` | N bit register with a synchronous reset and a write enable, change the parameter to change the width. Written behaviourally like the JK one, an always @(posedge clk) where reset clears q, otherwise q takes d only when en is high, and with en low it just holds. Reset wins over enable. Tested at N = 4, and the register file is going to be a stack of these at N = 8. |

## Notes to self

The testbenches mostly don't check themselves. They print with $monitor or $display and I compare
it to the truth table by eye. The barrel shifter one is the exception, it prints the expected
value next to the actual one so I am not working it out in my head every time, and that is the
direction I want the rest of them to go. Most of them dump a vcd too so I can open it in GTKWave
and confirm it there instead of only trusting the terminal. Once the blocks get bigger than a
truth table I want to move the checking into cocotb so the tests actually pass or fail on their
own.

Where the width is the interesting part (adder, decoder, comparator) the module is written with a
parameter N and the testbench picks the actual width when it instantiates it. Keeping them
parameterized means I can pull the same modules into the datapath without rewriting them, which
is what add_sub does when it instantiates the ripple carry adder at N = 8. The units that are
part of the datapath itself are just fixed at 8 bits since that is the width I am building to.

The latches and the D flip flop don't have a reset, so Q sits at x in simulation until something
actually gets written into it. The JK and T ones do, both synchronous, so the reset only takes
effect on a clock edge. The T flip flop is where this actually mattered, without the reset it
never gets out of x. The register has one too, so once the register file is built out of it the
core starts up in a known state.

## What is next

Fold the barrel shifter into the ALU as shift opcodes on the two unused op codes, since it is
built and tested but nothing calls it yet.

Then keep going in Sequential/. The register is done, so next is the register file, a set of
8 bit registers with the decoder picking which one gets written and the muxes picking which ones
get read out.

After that the core itself. A minimal custom ISA of about 8 to 10 instructions, then a single
cycle implementation wiring the datapath to a control unit built on the decoder. cocotb
testbenches to verify it properly, then Yosys and nextpnr to get it synthesized and placed and
routed.
