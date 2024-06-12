library ieee;
use ieee.std_logic_1164.all;

entity mux_2to1 is
  port
  (
    a, b, sel : in std_logic;
    y         : out std_logic
  );
end mux_2to1;

architecture structure of mux_2to1 is
begin

  y <= ((not sel) and a) or (sel and b);

end structure;