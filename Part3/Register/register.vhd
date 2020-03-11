library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RegisterFile is
    port(
        rd: in STD_LOGIC_VECTOR(11 downto 8) := "0000";
        r1: in STD_LOGIC_VECTOR(7 downto 4) := "0000";
        r2: in STD_LOGIC_VECTOR(3 downto 0) := "0000";
        cRegWrite: in STD_LOGIC := '0';
        input: in STD_LOGIC_VECTOR(15 downto 0);
        inr: in STD_LOGIC_VECTOR(3 downto 0); -- Debugging
        outr1toOffsetMux: out STD_LOGIC_VECTOR(15 downto 0);
        outr2toALU: out STD_LOGIC_VECTOR(15 downto 0);
        toMemory: out STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
        outvalue: out STD_LOGIC_VECTOR(15 downto 0); -- Debugging
        reset: in STD_LOGIC := '1'
    );
end RegisterFile;

architecture Behavioral of RegisterFile is
    subtype word is STD_LOGIC_VECTOR(15 downto 0); -- 16-bit register
    type memory is array (0 to 15) of word; -- 16 total registers
    signal register16: memory := (others => "0000000000000000");
        
begin
    -- Asynchronous reset 
    process(reset, rd, r1, r2)
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
                outr1toOffsetMux <= "0000000000000000";
                outr2toALU <= "0000000000000000";
                toMemory <= "0000000000000000";
                outvalue <= "0000000000000000";
                assert register16(0) = "0000000000000000";
                report "reset on";
            else
                outr1toOffsetMux <= register16(to_integer(unsigned(r1)));
                outr2toALU <= register16(to_integer(unsigned(r2)));
                toMemory <= register16(to_integer(unsigned(r1))); -- Load or store
                report "outputs set";
                outvalue <= "0000000000000000";
                report "reset off";
            end if;
    end process;

    -- Write input to register16(r2)
    process (cRegWrite)
        begin
            if (cRegWrite = '1') then
                -- register16(4) <= "1010101010101010";
                assert r2 = "0110";
                assert to_integer(unsigned(r2)) = 6;
                assert input = "0000000000000000";
                -- register16(to_integer(unsigned(r2))) <= input;
                register16(6) <= "1000000000000000";
                assert register16(6) = "0000000000000000";
                report "cRegWrite set";
            end if;
    end process;


end Behavioral;

