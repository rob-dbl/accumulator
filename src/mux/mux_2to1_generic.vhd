library ieee;
use ieee.std_logic_1164.all;

entity mux_2to1_generic is
    generic (
        N : integer := 8
    );
    port(
        a, b    : in std_logic_vector(N-1 downto 0);
        sel     : in std_logic;
        y       : out std_logic_vector(N-1 downto 0)
    );
end mux_2to1_generic;

architecture structure of mux_2to1_generic is

    component mux_2to1
        port
            (
              a, b, sel : in std_logic;
              y         : out std_logic
            );
    end component;

begin

    my_n_mux: for i in 0 to n-1 generate
        my_mux: mux_2to1 port map(
            a => a(i),
            b => b(i),
            sel => sel,
            y   => y(i)
        );
        end generate my_n_mux;

end structure;
    