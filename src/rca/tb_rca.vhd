library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rca is
end tb_rca;

architecture behavior of tb_rca is

    -- UUT 
    component rca is
        generic(
            Nbits : integer := 32
        );
        port(
            a, b        : in std_logic_vector(Nbits-1 downto 0);
            s           : out std_logic_vector(Nbits-1 downto 0);
            cout        : out std_logic;
            overflow    : out std_logic
        );
    end component;

    signal a, b, s  : std_logic_vector(3 downto 0);
    signal cout     : std_logic;

begin

    uut: rca generic map(4) port map(
        a => a,
        b => b,
        s => s,
        cout => cout
    );

    -- Testing process
    test: process
    begin

        a <= std_logic_vector(to_signed(5,a'length));
        b <= std_logic_vector(to_signed(-3,b'length));

        wait for 5 ns;
        wait;
    end process;
end behavior;