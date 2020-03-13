library IEEE;
use IEEE.std_logic_1164.all;

entity PC is
    port (
        DIN: in STD_LOGIC_VECTOR(15 downto 0);
        address: buffer STD_LOGIC_VECTOR(15 downto 0);
        CLK: in STD_LOGIC;
        reset: in STD_LOGIC := '0'
    );
end PC;

architecture Behavioral of PC is
begin
    process (reset, CLK)
        begin
            if (reset = '1') then
                address <= "0000000000000000";
            else
                if rising_edge(CLK) then
                    address <= DIN;
                end if;
            end if;
    end process;
end Behavioral;
