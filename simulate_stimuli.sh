#!/bin/bash


ghdl -a -fsynopsys \
src/rca/fa.vhd \
src/rca/rca.vhd \
src/mux/mux_2to1.vhd \
src/mux/mux_2to1_generic.vhd \
src/accumulator.vhd \
tb/utils/clk_gen.vhd \
tb/utils/data_maker.vhd \
tb/utils/data_sink.vhd \
tb/tb_accumulator_complete.vhd

ghdl -e -fsynopsys tb_acc 
ghdl -r -fsynopsys tb_acc --wave=wave.ghw --stop-time=200ns
open -a gtkwave wave.ghw

rm work-obj93.cf