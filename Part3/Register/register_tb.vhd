library IEEE;
use IEEE.std_logic_1164.all;

entity t_registerfile is
end t_registerfile;

architecture behavior of t_registerfile is
    component RegisterFile is
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
    end component RegisterFile;

    signal rd_t: STD_LOGIC_VECTOR(11 downto 8);
    signal r1_t: STD_LOGIC_VECTOR(7 downto 4);
    signal r2_t: STD_LOGIC_VECTOR(3 downto 0);
    signal cRegWrite_t: STD_LOGIC;
    signal input_t: STD_LOGIC_VECTOR(15 downto 0);
    signal inr_t: STD_LOGIC_VECTOR(3 downto 0); -- Debugging
    signal toOffset_t: STD_LOGIC_VECTOR(15 downto 0);
    signal toALU_t: STD_LOGIC_VECTOR(15 downto 0);
    signal toMemory_t: STD_LOGIC_VECTOR(15 downto 0);
    signal outvalue_t: STD_LOGIC_VECTOR(15 downto 0); -- Debugging

    begin
        rf: RegisterFile
        port map(
            rd => rd_t,
            r1 => r1_t,
            r2 => r2_t,
            cRegWrite => cRegWrite_t,
            input => input_t,
            inr => inr_t,
            toOffset => toOffset_t,
            toALU => toALU_t,
            toMemory => toMemory_t,
            outvalue => outvalue_t
        );
        process
            begin
                -- Test writing to a register
                rd_t <= "0100"; -- register 4
                r1_t <= "0101"; -- register 5
                r2_t <= "0110"; -- register 6
                register16(6) <= "0000000000001110";
                cRegWrite_t <= '1';
                assert register16(4) = "0000000000001110";
        end process;

end behavior;
