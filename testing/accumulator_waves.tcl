# add_waves.tcl
#set sig_list [list sig_name_a register_name\[32:0\]]  # List of signals (escape brackets)

# Add signals using list
#gtkwave::addSignalsFromList $sig_list

set name top.tb_acc.clk_i

gtkwave::addWave $name
