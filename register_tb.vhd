library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity t_registerfile is
end t_registerfile;

architecture behavior of t_registerfile is
    component RegisterFile is
        port (
            CLK: in STD_LOGIC := '0';
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
    end component RegisterFile;

    constant CLK_period: time := 1000 ns;
    signal CLK_t: STD_LOGIC := '0';
    signal rd_t: STD_LOGIC_VECTOR(11 downto 8) := "0000";
    signal r1_t: STD_LOGIC_VECTOR(7 downto 4) := "0000";
    signal r2_t: STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal cRegWrite_t: STD_LOGIC := '0';
    signal cLdi_t: STD_LOGIC := '0';
    signal cJalr_t: STD_LOGIC := '0';
    signal writeInput_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal outr1toOffsetMux_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal outr2toALU_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal toMemory_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal outvalue_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; -- Debugging
    signal inr_t: STD_LOGIC_VECTOR(3 downto 0);
    signal outr_t: STD_LOGIC_VECTOR(15 downto 0);
    signal reset_t: STD_LOGIC := '1';

    begin
        rf: RegisterFile
        port map(
            CLK => CLK_t,
            rd => rd_t,
            r1 => r1_t,
            r2 => r2_t,
            cRegWrite => cRegWrite_t,
            cLdi => cLdi_t,
            cJalr => cJalr_t,
            writeInput => writeInput_t,
            outr1toOffsetMux => outr1toOffsetMux_t,
            outr2toALU => outr2toALU_t,
            toMemory => toMemory_t,
            inr => inr_t,
            outr => outr_t,
            reset => reset_t
        );
        CLK_t <= not CLK_t after CLK_period / 2;
        process
            begin
                -- Test reset
                reset_t <= '1';
                wait for 1 ms;
                reset_t <= '0';

                -- Test writing to a register
                rd_t <= "0100"; -- register 4
                r1_t <= "0101"; -- register 5
                r2_t <= "0110"; -- register 6
                writeInput_t <= "0000000000000011";
                cRegWrite_t <= '1';
                wait for 1 ms;
                cRegWrite_t <= '0';
                wait for 5 ms;
                
                -- Test debugging
                inr_t <= "0100";
                wait for 1 ms;
                assert outr_t = "0000000000000011";

                -- Test outr1
                -- Write 3 to register 4
                rd_t <= "0100"; -- register 4
                writeInput_t <= "0000000000000011";
                cRegWrite_t <= '1';
                wait for 1 ms;
                cRegWrite_t <= '0';
                -- Read register 4
                r1_t <= "0100";
                wait for 1 ms;
                assert outr1toOffsetMux_t = "0000000000000011";
                -- Test toMemory
                assert toMemory_t = "0000000000000011";

                -- Test outr2
                -- Write 7 to register 5
                rd_t <= "0101"; -- register 5
                writeInput_t <= "0000000000000111";
                cRegWrite_t <= '1';
                wait for 1 ms;
                cRegWrite_t <= '0';
                -- Read register 5
                r2_t <= "0101";
                wait for 1 ms;
                assert outr2toALU_t = "0000000000000111";
                wait for 1 ms;

                -- Test jalr storage
                cJalr_t <= '1';
                writeInput_t <= "1010101010101010";
                wait for 1 ms;
                cJalr_t <= '0';
                r2_t <= "1010"; -- Register x10
                wait for 1 ms;
                assert outr2toALU_t = "1010101010101010";

                report "DONE";
        end process;

end behavior;
