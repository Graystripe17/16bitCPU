library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Memory is
    port (
        ADDR: in STD_LOGIC_VECTOR(9 downto 0);
        DIN: in STD_LOGIC_VECTOR(15 downto 0);
        cMemWrite: in STD_LOGIC;
        cMemRead: in STD_LOGIC;
        outMemory: out STD_LOGIC_VECTOR(15 downto 0);
        reset: in STD_LOGIC := '0'
    );
end Memory;

architecture Behavioral of Memory is
    subtype word is STD_LOGIC_VECTOR(15 downto 0);
    type mem is array (0 to 1023) of word;
    signal memory1024: mem := (others => "0000000000000000");
begin
    -- Main block
    process (reset, ADDR, DIN, cMemWrite, cMemRead)
    begin
        if (reset = '1') then
            memory1024 <= (others => "0000000000000000");
            outMemory <= "0000000000000000";
        else
            if (rising_edge(cMemRead)) then
                outMemory <= memory1024(to_integer(unsigned(ADDR)));
                report "cMemRead";
            end if;
            if (rising_edge(cMemWrite)) then
                memory1024(to_integer(unsigned(ADDR))) <= DIN;
                report "cMemWrite";
            end if;
            if (cMemRead = '0' and cMemWrite = '0') then
                -- Pass through DIN
                -- Useful for ldi and mv instructions
                outMemory <= DIN;
                report "pass through";
            end if;
        end if;
    end process;

end Behavioral;
