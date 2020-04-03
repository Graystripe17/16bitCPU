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
                                 -- ldi x6, 3
                                 -- Opcode rd x6  constant
                                 -- 0010   0110   00000011
                                1 => "0010011000000011",
                                 -- ldi x7, 7
                                 -- Opcode rd x7  constant
                                 -- 0010   0111   00000111
                                2 => "0010011100000111",
                                 -- mv x8, x6
                                 -- Opcode rd x8  r1 x6  filler
                                 -- 0100   1000   0110   0000
                                3 => "0100100001100000",
                                 -- x6 = 3
                                 -- x7 = 7
                                 -- x8 = 3
                                 -- add x5, x7, x8
                                 -- Opcode rd x5  r1 x7  r2 x8
                                 -- 0101   0101   0111   1000
                                 -- Expect x5 to hold 0xA 
                                4 => "0101010101111000",
                                 -- blt x8, x5, x7
                                 -- Opcode rd x8  r1 x5  r2 x7
                                 -- 1100   1000   1010   0111
                                5 => "1100100010100111",
                                6 => "0101010101111000",
                                7 => "0101010101111000",
                                123 => "0101010101111000",
                                others => "0101010101111000");

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
