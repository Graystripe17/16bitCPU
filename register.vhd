library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Note PC requires clock

entity RegisterFile is
    port (
        CLK: in STD_LOGIC;
        rd: in STD_LOGIC_VECTOR(11 downto 8) := "0000";
        r1: in STD_LOGIC_VECTOR(7 downto 4) := "0000";
        r2: in STD_LOGIC_VECTOR(3 downto 0) := "0000";
        cRegWrite: in STD_LOGIC := '0';
        cLdi: in STD_LOGIC;
        cJalr: in STD_LOGIC;
        writeInput: in STD_LOGIC_VECTOR(15 downto 0);
        outr1toOffsetMux: out STD_LOGIC_VECTOR(15 downto 0);
        outr2toALU: out STD_LOGIC_VECTOR(15 downto 0);
        rdContent: out STD_LOGIC_VECTOR(15 downto 0);
        toMemory: out STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
        PCoutput: out STD_LOGIC_VECTOR(15 downto 0);
        PCinput: in STD_LOGIC_VECTOR(15 downto 0);
        inr: in STD_LOGIC_VECTOR(3 downto 0);
        outr: out STD_LOGIC_VECTOR(15 downto 0);
        reset: in STD_LOGIC := '1'
    );
end RegisterFile;

architecture Behavioral of RegisterFile is
    subtype word is STD_LOGIC_VECTOR(15 downto 0); -- 16-bit register
    type memory is array (0 to 15) of word; -- 16 total registers
    signal register16: memory := (others => "0000000000000000");

begin

    PCoutput <= register16(15);
    
    outr1toOffsetMux <= register16(to_integer(unsigned(r1)));
    outr2toALU <= register16(to_integer(unsigned(r2)));
    rdContent <= register16(to_integer(unsigned(rd)));
    toMemory <= register16(to_integer(unsigned(r1))); -- Load or store
    outr <= register16(to_integer(unsigned(inr))); -- Debug

    process (CLK, writeInput)
        begin
            if (reset = '1') then
--                register16 <= (0 => "0000000000000000",
--                              1 => "0000000000000001",
 --                             2 => "0000000000000011",
  --                            3 => "0000000000000111",
   --                           4 => "0000000000001111",
    --                          5 => "0000000000011111",
     --                         6 => "0000000000111111",
      --                        7 => "0000000001111111",
       --                       8 => "0000000011111111",
        --                      9 => "0000000111111111",
         --                     others => "1000000000000000");
                register16 <= (others => "0000000000000000");
                register16(to_integer(unsigned(rd))) <= "0000000000000000";
                register16(to_integer(unsigned(r1))) <= "0000000000000000";
                register16(to_integer(unsigned(r2))) <= "0000000000000000";
                register16(to_integer(unsigned(inr))) <= "0000000000000000";
                register16(15) <= "0000000000000000";
            else
                if falling_edge(CLK) then
                    register16(15) <= PCinput;
                end if;
                if (cLdi = '1') then
                    -- Special instruction ignore MemToReg
                    register16(to_integer(unsigned(rd))) <= "00000000" & r1 & r2;
                elsif (cJalr = '1') then
                    -- If JALR flag, write to return register x10
                    register16(10) <= writeInput;
                elsif (cRegWrite = '1') then
                    register16(to_integer(unsigned(rd))) <= writeInput; -- Warning: Changes on the next clock cycle
                end if;
            end if;
    end process;

end Behavioral;
