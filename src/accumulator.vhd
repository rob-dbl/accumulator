library ieee;
use ieee.std_logic_1164.all;

entity accumulator is
    generic(
        Nbits   : integer := 32
    );
    port(
        a, b        : in std_logic_vector(Nbits-1 downto 0);
        accumulate  : in std_logic;
        acc_enable  : in std_logic;
        clk, rst_n  : in std_logic;
        y           : out std_logic_vector(Nbits-1 downto 0)
    );
end accumulator;

architecture structure of accumulator is 

    -- Adder: rca/my_rca.vhd
    component rca is
        generic(
            Nbits : integer := 32
        );
        port(
            a, b    : in std_logic_vector(Nbits-1 downto 0);
            s       : out std_logic_vector(Nbits-1 downto 0);
            cout    : out std_logic
        );
    end component;

    -- Multiplexer: mux_nto1_str.vhd
    component mux_2to1_generic
        generic (
            N : integer := 8
        );
        port(
            a, b    : in std_logic_vector(N-1 downto 0);
            sel     : in std_logic;
            y       : out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal adder_out, mux_out, reg_out : std_logic_vector(Nbits-1 downto 0);
    signal cout : std_logic;

begin

    -- Multiplexer
    mux : mux_2to1_generic generic map(Nbits) port map(
        a   => b,
        b   => reg_out,
        sel => accumulate,
        y   => mux_out
    );

    -- Adder instantiation
    adder: rca generic map (
        Nbits
    )
    port map (
        a       => a,
        b       => mux_out,
        s       => adder_out,
        cout    => cout
    );

    -- Register process
    reg_process : process(clk, rst_n, acc_enable)
    begin
        if clk'event and clk = '1' then
            -- Enable has priority on acc_enable
            if acc_enable = '1' then
                if rst_n = '0' then 
                    reg_out <= (others=>'0');
                else
                    reg_out <= adder_out;
                end if;
            end if;
        end if;
    end process;

    y <= reg_out;
end structure;
            

