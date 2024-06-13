# Simple Accumulator

## Table of Contents

- [About](#about)
- [Structure](#structure)
- [Testbench](#testbench)

## About <a name = "about"></a>

This repository contains a simple structural accumulator described and tested using VHDL. Simulation was carried out using GHDL. Main purpose of the project was to regain practice with VHDL using free EDA tools for basic analysis and verification.

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

## Testbench<a name = "testbench"></a>

The testbench is written in VHDL and includes, other than the unit under test (UUT), a clock generation module that runs independently to the test bench. The test procedure is described as a process where proper stimuli are applied to the UUT inputs and the output is evaluated.
Waves were written into an output file `wave.ghw`, that is readable by post-simulation tools such as GTKwave.
The commands used for analysis, elaboration and simulation were all included into a script file 'simulate.sh' to ease and speed-up the simulation process.
