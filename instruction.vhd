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
    signal outInstruction_t: STD_LOGIC_VECTOR(15 downto 0);
begin

    -- outInstruction <= outInstruction_t;

    -- Main block
    process (PC, reset)
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
                                 -- add x5, x7, x8
                                 -- x6 = 3
                                 -- x7 = 7
                                 -- x8 = 3
                                 -- Opcode rd x5  r1 x7  r2 x8
                                 -- 0101   0101   0111   1000
                                 -- Expect x5 to hold 0xA 
                                4 => "0101010101111000",
                                 -- sub x4, x7, x8
                                 --      4 = 7 - 3
                                 -- Opcode rd x4  r1 x7  r2 x8
                                 -- 0110   0100   0111   1000
                                5 => "0110010001111000",
                                 -- sll x3, x5, x8
                                 --     80 = 10 >> 3
                                 -- Opcode rd x3  r1 x5  r2 x8
                                 -- 0111   0011   0101   1000
                                6 => "0111001101011000",
                                 -- srl x2, x5, x8
                                 --     1 = 10 << 3
                                 -- Opcode rd x2  r1 x5  r2 x8
                                 -- 1000   0010   0101   1000
                                7 => "1000001001011000",
                                 -- and x9, x2, x3
                                 -- 1010000 and 1
                                 -- 0 = 80 and 1
                                 -- Opcode rd x9  r1 x2  r2 x3
                                 -- 1001   1001   0010   0011
                                8 => "1001100100100011", -- 9923
                                 -- or x11, x2, x3
                                 -- 1010000 or 1
                                 -- 81 = 80 or 1
                                 -- Opcode rd x11 r1 x2  r2 x3
                                 -- 1010   1011   0010   0011
                                9 => "1010101100100011", -- AB23
                                 -- blt x8, x10, x7
                                 -- x8 contains 3, so jump forward 3 instructions if x5 < x7
                                 -- Opcode rd x8  r1 x10 r2 x7
                                 -- 1100   1000   1010   0111
                                10 => "1100100010100111", -- C8A7
                                 -- beq x2, x3, x4
                                 -- x2 = 80
                                 -- x3 = 1
                                 -- x4 = 4
                                 -- Do not branch, since x3 != x4
                                 -- Opcode rd x2  r1 x3  r2 x4
                                 -- 1011   0010   0011   0100
                                13 => "1011001000110100", -- B134
                                 -- jalr x5, x7
                                 -- Mv x7 to x10
                                 -- Jump by A (x5)
                                 -- Opcode rd x5  r1 x7  filler
                                 -- 1111   0101   0111   0000
                                14 => "1111010101110000", -- F530
                                 -- sd x2, x3
                                 -- Store 0x3 into memory address 1
                                 -- Opcode rd x2  r1 x3  filler
                                 -- 0011   0010   0011   0000
                                17 => "0011011000110000",
                                 -- ld x12, x3
                                 -- Load 0xF from memory address 3
                                 -- Opcode rd x12 r1 x3  filler
                                 -- 0001   1100   0011   0000
                                18 => "0001110000110000",
                                -- ldi x6, 16
                                others => "0010011000001111");
            outInstruction <= "0000000000000000";
        else
            outInstruction <= instruction65536(to_integer(unsigned(PC))); -- WARNING REVERT
        end if;
        
    end process;

end Behavioral;
