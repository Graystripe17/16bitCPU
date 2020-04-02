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
        toMemory: out STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
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

    process (CLK)
        begin
            if (reset = '1') then
                register16 <= (others => "0000000000000000");
                outr1toOffsetMux <= "0000000000000000";
                outr2toALU <= "0000000000000000";
                toMemory <= "0000000000000000";
                outr <= "0000000000000000";
            else
                outr1toOffsetMux <= register16(to_integer(unsigned(r1)));
                outr2toALU <= register16(to_integer(unsigned(r2)));
                toMemory <= register16(to_integer(unsigned(r1))); -- Load or store
                outr <= register16(to_integer(unsigned(inr))); -- Debug
                if (cLdi = '1' or rising_edge(cLdi)) then
                    -- Special instruction ignore MemToReg
                    register16(to_integer(unsigned(rd))) <= "00000000" & r1 & r2;
                    report "Register: Ldi";
                elsif (cJalr = '1') then
                    -- If JALR flag, write to return register x10
                    register16(10) <= writeInput;
                elsif (cRegWrite = '1') then
                    register16(to_integer(unsigned(rd))) <= writeInput; -- Won't change immediately
                    report "WRITING";
                end if;
            end if;
    end process;

end Behavioral;
