library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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
            outr1toOffsetMux: out STD_LOGIC_VECTOR(15 downto 0);
            outr2toALU: out STD_LOGIC_VECTOR(15 downto 0);
            toMemory: out STD_LOGIC_VECTOR(15 downto 0);
            outvalue: out STD_LOGIC_VECTOR(15 downto 0); -- Debugging
            reset: in STD_LOGIC
        );
    end component RegisterFile;

    signal rd_t: STD_LOGIC_VECTOR(11 downto 8) := "0000";
    signal r1_t: STD_LOGIC_VECTOR(7 downto 4) := "0000";
    signal r2_t: STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal cRegWrite_t: STD_LOGIC := '0';
    signal input_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal inr_t: STD_LOGIC_VECTOR(3 downto 0) := "0000"; -- Debugging
    signal outr1toOffsetMux_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal outr2toALU_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal toMemory_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal outvalue_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; -- Debugging
    signal reset_t: STD_LOGIC := '1';

    begin
        rf: RegisterFile
        port map(
            rd => rd_t,
            r1 => r1_t,
            r2 => r2_t,
            cRegWrite => cRegWrite_t,
            input => input_t,
            inr => inr_t,
            outr1toOffsetMux => outr1toOffsetMux_t,
            outr2toALU => outr2toALU_t,
            toMemory => toMemory_t,
            outvalue => outvalue_t,
            reset => reset_t
        );
        process
            begin
                reset_t <= '1';
                wait for 1 ms;
                reset_t <= '0';
                -- Test writing to a register
                rd_t <= "0100"; -- register 4
                r1_t <= "0101"; -- register 5
                r2_t <= "0110"; -- register 6
                wait for 1 ms;
                cRegWrite_t <= '1';
                wait for 1 ms;
                -- assert register16(4) = "0000000000001110";
                -- report to_hex_string(outr1toOffsetMux_t);
                -- assert outr1toOffsetMux_t = "0000000000011111"; -- Reg 5
                -- assert outr2toALU_t = "0000000000111111"; -- Reg 6
                -- assert cRegWrite_t = '1';
                wait for 10000 ms;
        end process;

end behavior;
