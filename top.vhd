library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
    port (
        CLK: in STD_LOGIC;
        inr: in STD_LOGIC_VECTOR(3 downto 0); -- Debug
        outvalue: out STD_LOGIC_VECTOR(15 downto 0); -- Debug
        reset: in STD_LOGIC
    );
end top;

architecture Behavioral or top is
begin
    process (CLK)
        begin
            reset <= '0';
    end process;
end Behavioral;
