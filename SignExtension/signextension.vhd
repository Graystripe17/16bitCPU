library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SignExtension is
    port (
        input: in STD_LOGIC_VECTOR(7 downto 0);
        output: out STD_LOGIC_VECTOR(15 downto 0);
        reset: in STD_LOGIC := '0'
    );
end SignExtension;

architecture Behavioral of SignExtension is
begin
    process (reset, input)
        begin
            if (reset = '1') then
                output <= "0000000000000000";
            else
                output <= STD_LOGIC_VECTOR(resize(signed(input), 16));
            end if;
    end process;
end Behavioral;
