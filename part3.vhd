library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Winston is
    port(
        CLK: in STD_LOGIC;
        inr: in STD_LOGIC_VECTOR(3 downto 0); -- Debug
        outvalue: out STD_LOGIC_VECTOR(15 downto 0); -- Debug
        );
end Winston;

architecture Behavioral of Winston is

end Behavioral;
