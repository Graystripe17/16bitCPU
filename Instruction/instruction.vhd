library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity InstructionMemory is
    port (
        PC: in STD_LOGIC_VECTOR(15 downto 0);
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
    process (reset, PC)
    begin
        if (reset = '1') then
            instruction65536 <= (others => "0000000000000000");
            outInstruction <= "0000000000000000";
        else
            outInstruction <= instruction65536(to_integer(unsigned(PC)));
        end if;
        
    end process;

end Behavioral;