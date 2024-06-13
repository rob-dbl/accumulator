library ieee;
use ieee.std_logic_1164.all;

entity clk_gen is
    generic ( Ts : time := 10 ns );
    port(
        end_sim : in std_logic;
        clk     : out std_logic
    );
end clk_gen;

architecture bhv of clk_gen is
    --constant Ts : time := 10 ns;
    signal clk_i : std_logic;
begin

    clk_gen_proc: process
    begin
        if(clk_i = 'U') then
            clk_i <= '1';
        else
            clk_i <= not(clk_i);
        end if;
        wait for Ts/2;
    end process;

    clk <= clk_i and not end_sim;
end bhv;