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
            data_valid  : out std_logic;
            y           : out std_logic_vector(Nbits-1 downto 0);
            overflow    : out std_logic
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

    -- Data maker
    component data_maker
        port (
          CLK     : in  std_logic;
          RST_n   : in  std_logic;
          EN		: in  std_logic; -- Used to stop the reading of the file from TB
          VOUT    : out std_logic;
          DOUT    : out std_logic_vector(19 downto 0);             
          END_SIM : out std_logic);
    end component;

    -- Data sink
    component data_sink
        port (
            CLK   : in std_logic;
            RST_n : in std_logic;
            VIN   : in std_logic;
            DIN   : in std_logic_vector(11 downto 0);
            ERR	  : out std_logic);
    end component;

    signal ai, bi, yi : std_logic_vector(7 downto 0);
    signal douti : std_logic_vector(19 downto 0);
    signal dini     : std_logic_vector(11 downto 0);
    signal clk_i, end_sim_i, vouti1, vouti2 : std_logic;
    signal acc_i, acc_en_i, ext_rst_i, rst_i, of_i, err_i : std_logic;
    signal data_valid_i, data_sink_en : std_logic;

begin

    -- Instantiation of the components
    clk_gen_i: clk_gen generic map( 10 ns )
    port map(
        end_sim => end_sim_i,
        clk     => clk_i
    );

    dut: accumulator generic map(8) port map(
        a           => ai,
        b           => bi,
        accumulate  => acc_i,
        acc_enable  => acc_en_i,
        clk         => clk_i,
        rst_n       => rst_i,
        y           => yi,
        overflow    => of_i,
        data_valid  => data_valid_i
    );

    stimuli: data_maker port map (
        CLK     => clk_i,
        RST_n   => ext_rst_i,
        EN		=> '1',
        VOUT    => vouti1,
        DOUT    => douti,             
        END_SIM => end_sim_i
    );

    bi <= douti(7 downto 0);
    ai <= douti(15 downto 8);

    rst_i <= douti(18);
    acc_i <= douti(17);
    acc_en_i <= douti(16);

    -- Internal register for vouti
    v_prop: process(clk_i, ext_rst_i)
    begin
        if ext_rst_i = '0' then
            vouti2 <= '0';
        else
            if clk_i'event and clk_i = '1' then
                vouti2 <= vouti1;
            end if;
        end if;
    end process;

    dini <= "000" & of_i & yi;
    data_sink_en <= vouti2 and data_valid_i;

    comparator: data_sink port map ( 
        CLK   => clk_i,
        RST_n => ext_rst_i,
        VIN   => vouti1,
        DIN   => dini,
        ERR	  => err_i
    );

    
    test: process
    begin
        ext_rst_i <= '0';
        wait for 1 ns;
        ext_rst_i <= '1';
        wait;
    end process;

    
end bhv;

        

