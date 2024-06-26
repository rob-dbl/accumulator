#!/bin/bash

ghdl -a \
src/rca/fa.vhd \
src/rca/rca.vhd \
src/mux/mux_2to1.vhd \
src/mux/mux_2to1_generic.vhd \
src/accumulator.vhd \
tb/utils/clk_gen.vhd \
tb/tb_accumulator.vhd

ghdl -e tb_acc
ghdl -r tb_acc --wave=wave.ghw --stop-time=100ns
open -a gtkwave wave.ghw