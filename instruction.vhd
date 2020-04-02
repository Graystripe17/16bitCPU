library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity InstructionMemory is
    port (
        CLK: in STD_LOGIC;
        PC: in STD_LOGIC_VECTOR(15 downto 0);
        writeEnable: in STD_LOGIC;
        writeData: in STD_LOGIC_VECTOR(15 downto 0);
        outInstruction: out STD_LOGIC_VECTOR(15 downto 0);
        reset: in STD_LOGIC := '0'
    );
end InstructionMemory;

architecture Behavioral of InstructionMemory is
    subtype word is STD_LOGIC_VECTOR(15 downto 0);
    type mem is array (0 to 65535) of word;
    signal instruction65536: mem := (others => "0000000000000000");
begin
    -- Main block
    process (CLK, reset, PC, writeEnable, writeData)
    begin
        if (reset = '1') then
            instruction65536 <= (
                                1 => "0010011000000011", -- ldi x6, 3
                                2 => "0010011100000111", -- ldi x7, 7
                                3 => "0100100001100000", -- mv x8, x6
                                4 => "0101010101111000", -- add x5, x7, x8
                                5 => "1100100001111010", -- blt x8, x7, x5
                                others => "0000000000000000");
            outInstruction <= "0000000000000000";
        else
            if (writeEnable = '1') then
                instruction65536(to_integer(unsigned(PC))) <= writeData;
            else
                outInstruction <= instruction65536(to_integer(unsigned(PC)));
            end if;
        end if;
        
    end process;

end Behavioral;
