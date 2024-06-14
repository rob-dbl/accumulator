----------------------------------------------------------------
-- DATA READER
-- Modified version of the "clk_gen.vhd" example code.
-- Data are read from the input file "samples.txt" and provided
-- to the output port DOUT. Whenever a valid data is sent, 
-- the control signal VOUT is set to high.
--
-- Project: Lab 1.1
-- Authors: Group 32 (Chatrasi, Di Bella, Zangeneh)
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity data_maker is  
  port (
    CLK     : in  std_logic;
    RST_n   : in  std_logic;
	EN		: in  std_logic; -- Used to stop the reading of the file from TB
    VOUT    : out std_logic;
    DOUT    : out std_logic_vector(19 downto 0);             
    END_SIM : out std_logic);
end data_maker;

architecture bhv of data_maker is

  constant tco : time := 2 ns;

  signal sEndSim : std_logic;
  signal END_SIM_i : std_logic_vector(0 to 10);  

begin  

  rd_file: process (CLK, RST_n, EN)
  
    file fp_in          : text open READ_MODE is "/Users/roberto/Projects/ms_revival/lab1/_accumulator/accumulator/testing/acc_stimuli.txt";
    variable line_in    : LINE;
    variable Data       : STD_LOGIC_VECTOR(19 downto 0);
    variable Success    : BOOLEAN;
	
  begin  -- process rd_file
  
    if RST_n = '0' then                 -- asynchronous reset (active low)
      DOUT <= (others => '0') after tco;      
      VOUT <= '0' after tco;
      sEndSim <= '0' after tco;
	  
    elsif CLK'event and CLK = '1' then  -- rising clock edge
		if EN = '1' then
		  if not endfile(fp_in) then
		    readline(fp_in, line_in);
		    hread(line_in, Data, Success);
		    --DOUT <= conv_std_logic_vector(x, 20) after tco;
		    --DOUT <= std_logic_vector(to_unsigned(Data,DOUT'length));
            DOUT <= Data after tco;
            VOUT <= '1' after tco;
		    sEndSim <= '0' after tco;
		  else
		    VOUT <= '0' after tco;        
		    sEndSim <= '1' after tco;
		  end if;
		else
			VOUT <= '0' after tco;
		end if;
    end if;
  end process rd_file;

  shift_count: process (CLK, RST_n)
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      END_SIM_i <= (others => '0') after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      END_SIM_i(0) <= sEndSim after tco;
      END_SIM_i(1 to 10) <= END_SIM_i(0 to 9) after tco;
    end if;
  end process shift_count;

  END_SIM <= END_SIM_i(10);  

end bhv;
