# Testbenches and simulation technique

Two testbenches were developed for this project:
+ A simple testbench, with the Unit Under Test and a clock generator;
+ An advanced testbench, including also a data production and error detection modules.

## Simple testbench: `tb_accumulator.vhd`
This testbench simply includes the UUT and a generic clock generation module `clk_gen`, where the period of the clock can be specified. Inputs for the UUT are predefined and applied by a process. Verification of the output can be done by the user, by analysing the output signals with a waveform visualizer.
This technique is not efficient for error detection, since inputs are predetermined by the designer and might not be enough to identify errors inside the design.

## Advanced testbench: `tb_accumulator_complete.vhd`
The advanced testbench tries to overcome the hardware debug problem by using test vector generated externally and comparing the output values with the expected one. For this purpose, a software model was written in Python for random operands generation and computation of the correct outputs (see the software model of the accumulator [here](https://github.com/rob-dbl/accumulator/blob/main/testing/README.md)).
Other than the UUT, the testbench includes the following modules:
+ A **data maker** module, that takes as input a `.txt` file including the input vectors and translates them as signals for the testbench;
+ A **data sink** module, which compares the output coming from the UUT with the ones saved into a second `.txt` file and rising the ERR signal whenever a difference is detected;
+ A **clock generation** module.


