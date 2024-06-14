library ieee;
use ieee.std_logic_1164.all;

entity rca is
    generic(
        Nbits : integer := 32
    );
    port(
        a, b        : in std_logic_vector(Nbits-1 downto 0);
        s           : out std_logic_vector(Nbits-1 downto 0);
        cout        : out std_logic;
        overflow    : out std_logic
    );
end rca;

architecture structure of rca is

    component FA 
        generic ( 
            DFAS: time := 0 ns;
		    DFAC: time := 0 ns);
	    Port (	
            A:	In	std_logic;
		    B:	In	std_logic;
		    Ci:	In	std_logic;
		    S:	Out	std_logic;
		    Co:	Out	std_logic);
    end component;

    signal c_array : std_logic_vector(Nbits-1 downto 0);

begin

    -- first full adder: cin is 0
    first_adder: FA generic map( 10 ns, 9 ns ) port map(
        A => a(0),
        B => b(0),
        Ci => '0',
        S   => s(0),
        Co  => c_array(0)
    );

    myadder: for i in 1 to Nbits-1 generate
        single_adder: FA port map(
            A => a(i),
            B => b(i),
            Ci  => c_array(i-1),
            S   => s(i),
            Co  => c_array(i)
        );
        end generate;

    Cout <= c_array(Nbits-1);
end structure;