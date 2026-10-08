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
and T flip flops, an N bit register, the SISO, SIPO, PISO and PIPO shift registers, a
bi-directional shift register, and up/down, ring and Johnson counters are done so far.

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
| full_adder | `full_adder` | `full_adder_tb.v` | Made out of two half adders, the two carries get OR'd for the carry out. |
| ripple_carry_adder_N | `rcN_adder` | `ripple_carry_N_adder_tb.v` | N bit adder. A generate loop makes N full adders and the carry from each one goes into the next. Change N to change the width. |
| muxes | `mux_2to1`, `mux_4to1`, `mux_8to1` | `muxstb.v` | 2 to 1 uses a ternary, 4 to 1 and 8 to 1 use a case statement. |
| demuxes | `dmux_1to2`, `dmux_1to4`, `dmux_1to8` | `demux_tb.v` | 1 to 4 is made from three 1 to 2 demuxes, 1 to 8 is a 1 to 2 and two 1 to 4s. Needed ifndef guards so the files don't get included twice. |
| decoders | `n_decoder` | `n_decoder_tb.v` | N to 2^N decoder, the output is just 1 << in. |
| encoders | `_encoder8to3` | `encoder_tb.v` | 8 to 3 encoder using OR gates. Only works with one hot inputs, an input of 0 and an input of 1 both give 000. |
| encoders | `priorityEn8_3` | `priority_tb.v` | Priority encoder using casez, outputs the index of the highest bit that is set. |
| comparator | `mag_comp_N` | `mag_comp_tb.v` | N bit comparator with outputs for a < b, a == b and a > b. |
| add_sub | `add_sub` | `add_sub_tb.v` | 8 bit adder/subtractor using the ripple carry adder. sel = 0 adds, sel = 1 XORs b and sets the carry in to 1 to subtract. Also outputs overflow and carry out. |
| barrel_shifter | `barrel_shifter` | `barrelshifter_tb.v` | 8 bit left shift by 0 to 7, done in three stages that shift by 1, 2 and 4. |
| ALU | `ALU` | `alu_tb.v` | Puts everything above together, the opcodes are in the ALU section. |

## Sequential blocks

All of these live in Sequential/. Same idea as the combinational ones, most of them are built
out of the one before it. All three flip flops are in the Flip Flop folder.

| Folder | Module | Testbench | What it does |
| --- | --- | --- | --- |
| SR_Latch | `SR_Latch` | `SR_Latch_tb.v` | Two NOR gates feeding into each other. s = r = 1 isn't allowed. |
| D | `D_latch` | `D_Latch_tb.v` | SR latch with set = D & enable and reset = ~D & enable, so S and R are always opposite. |
| Flip Flop | `d_flip_flop` | `D_ff_tb.v` | Two D latches as master and slave, the master is enabled on ~clk and the slave on clk. |
| Flip Flop | `jk_ff` | `jkff_tb.v` | Case on {J, K}, 00 holds, 01 resets, 10 sets and 11 toggles. Has a synchronous reset. |
| Flip Flop | `t_flip_flop` | `tff_tb.v` | D flip flop with D = T ^ Q. Needed a reset or Q stays stuck at x. |
| Register | `n_bit_register` | `n_bit_register_tb.v` | N bit register with rst and en. If rst is high q goes to 0, if en is high q takes d, otherwise it holds. |
| Shift Registers | `SISO` | `SISO_tb.v` | Serial in serial out shift register, shifts d in every clock and q is the last bit. At N = 1 it is just a D flip flop. |
| Shift Registers | `SIPO` | `SIPO_tb.v` | Serial in parallel out, uses the SISO module but outputs all N bits at once. |
| Shift Registers | `PISO` | `PISO_tb.v` | Parallel in serial out, made from 1 bit registers. SH_LD = 0 loads d, SH_LD = 1 shifts it out of q one bit at a time. |
| Shift Registers | `PIPO` | none yet | Parallel in parallel out, q takes all of d every clock. Same as the register without en. |
| Bi_directionalShiftReg | `BDSR` | `BDSR_tb.v` | Bi-directional shift register, R_Lshift = 0 shifts left and 1 shifts right. q is the bit at whichever end it is shifting towards. |
| Counters | `counter_up_down` | `counter_tb.v` | N bit up/down counter, dir = 1 counts up and dir = 0 counts down. |
| Counters | `ring_counter` | `ring_counter_tb.v` | Ring counter, preset puts a 1 in the first flip flop and then it goes around, 0001, 0010, 0100, 1000 and back. |
| Counters | `johnson_counter` | `jc_tb.v` | Johnson counter, same as the ring counter but the last bit gets inverted when it goes back to the start. 4 bits gives 8 states. |

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

Any testbench with a clock needs a $finish. The clock always has another edge coming so the sim
never stops on its own, and with $dumpvars on it just keeps writing the vcd. I forgot it on an
early version of the BDSR testbench and the vcd got to 161 GB and filled my drive. The
testbenches without a clock stop by themselves once nothing else is left to happen, which is why
this never came up before.

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
