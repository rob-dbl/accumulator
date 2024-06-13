library ieee;
use ieee.std_logic_1164.all;

entity tb_acc is
end tb_acc;

architecture bhv of tb_acc is

    -- Unit under test
    component accumulator is
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
    end component;

    -- Clock generator
    component clk_gen is
        generic ( Ts : time := 10 ns );
        port(
            end_sim : in std_logic;
            clk     : out std_logic
        );
    end component;

    signal a, b, y : std_logic_vector(7 downto 0);
    signal clk_i, end_sim_i : std_logic;
    signal acc_i, acc_en_i, rst_i : std_logic;

begin

    -- Instantiation of the components
    clk_gen_i: clk_gen generic map( 20 ns )
    port map(
        end_sim => end_sim_i,
        clk     => clk_i
    );

    dut: accumulator generic map(8) port map(
        a           => a,
        b           => b,
        accumulate  => acc_i,
        acc_enable  => acc_en_i,
        clk         => clk_i,
        rst_n       => rst_i,
        y           => y
    );

    test: process
    begin

        wait for 1 ns;
        
        end_sim_i   <= '0';  
        rst_i       <= '0';
        acc_i       <= '0';
        acc_en_i    <= '1';
        a <= x"01";
        b <= x"03";
        wait for 10 ns;
        rst_i       <= '1';
        acc_en_i    <= '0';
        wait for 10 ns;
        acc_en_i    <= '1';
        wait for 10 ns;
        a <= x"07";
        b <= x"04";
        wait for 10 ns;
        a <= x"01";
        b <= x"03";
        wait for 10 ns;
        acc_i <= '1';
        wait for 30 ns;
        end_sim_i <= '1';
        wait;
    end process;
end bhv;

        

