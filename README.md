# Simple Accumulator

## Table of Contents

- [About](#about)
- [Structure](#structure)
- [Simulation and verification](#testbench)

## About <a name = "about"></a>

This repository contains a simple structural accumulator described and tested using VHDL. Simulation was carried out using GHDL. Main purpose of the project was to regain practice with VHDL using free EDA tools for basic analysis and verification.
In particular, it was possible to:
+ Practice with digital design techniques and description using VHDL
+ Practice with GHDL simulation tool, along with GTKWave for waveform visualisation
+ Develop a strategy allowing an easy verification of digital designs, with software model written in Python and complex testbench for automatic error detection.

## Structure and functionality<a name = "structure"></a>

The picture below represents the basic structure of the accumulator. It is composed of three main blocks:
- A multiplexer, for selection of the source;
- A simple adder (currently, a ripple-carry adder);
- A register used for accumulation.
  
<p align="center">
  <img src="https://github.com/rob-dbl/accumulator/blob/main/others/schematic.png" width="480">
</p>
  
The unit is enabled when the `acc_enable` signal is set.
Selection of the function to perform (simple sum or successive accumulation of operands) is controlled by the `accumulate` pin. When it is not set, the unit will simply give the sum of the two operands A and B; otherwise, the output register will be selected as operand and sum to A, as long as the `accumulate` is set. The result of the operation will be available at the beginning of the successive clock cycle.

## Simulation and verification<a name = "testbench"></a>

Two verification techniques were used to assess the functionalities of the unit, a simple one - with signals "hardwired" and defined inside the testbench itself - and an advanced one, using an external software model to validate the output of the VHDL model.
Waves were written into an output file `wave.ghw`, that is readable by post-simulation tools such as GTKwave (used in this case).
The commands used for analysis, elaboration and simulation were all included into a script files to ease and speed-up the simulation process.

### Advanced simulation and validation
To improve the validation process of the design and efficiently identify hardware bugs, a software model of the accumulator was designed in Python along with a stimuli generator.
The process used was the following:
+ Software model:
  1. Definition of the control signals for each of the features to validate;
  2. Collection of the test vectors into a single list, applied to the software model;
  3. Production and storage of two files, one including the input vectors and a second one storing the output of the software model.
+ VHDL model:
  4. Simulation using the two files as input for the data maker and the data sink;
  5. Evaluation of possible errors when comparing the output of the VHDL model and the software model.
