library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RegisterFile is
    port(
        rd: in STD_LOGIC_VECTOR(11 downto 8);
        r1: in STD_LOGIC_VECTOR(7 downto 4);
        r2: in STD_LOGIC_VECTOR(3 downto 0);
        cRegWrite: in STD_LOGIC;
        input: in STD_LOGIC_VECTOR(15 downto 0);
        inr: in STD_LOGIC_VECTOR(3 downto 0); -- Debugging
        toOffset: out STD_LOGIC_VECTOR(15 downto 0);
        toALU: out STD_LOGIC_VECTOR(15 downto 0);
        toMemory: out STD_LOGIC_VECTOR(15 downto 0);
        outvalue: out STD_LOGIC_VECTOR(15 downto 0) -- Debugging
    );
end RegisterFile;

architecture Behavioral of RegisterFile is
    subtype word is STD_LOGIC_VECTOR(15 downto 0); -- 16-bit register
    type memory is array (0 to 15) of word; -- 16 total registers
    signal register16: memory;
        
begin
    -- Write input to register16(r2)
    process (cRegWrite)
        begin
            if (cRegWrite = '1') then
                register16(to_integer(unsigned(r2))) <= input;
            end if;
    end process;


end Behavioral;

