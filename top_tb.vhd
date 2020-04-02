library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity t_top is
end t_top;

architecture Behavioral of t_top is
    component top
        port (
            CLK: in STD_LOGIC;
            instructionWriteEnable: in STD_LOGIC;
            instructionWriteAddr: in STD_LOGIC_VECTOR(15 downto 0);
            instructionWriteData: in STD_LOGIC_VECTOR(15 downto 0);
            instructionOut: out STD_LOGIC_VECTOR(15 downto 0); -- Debug
            inr: in STD_LOGIC_VECTOR(3 downto 0); -- Debug rf
            outr: out STD_LOGIC_VECTOR(15 downto 0); -- Debug rf
            reset: in STD_LOGIC
        );
    end component;

    constant CLK_period: time := 1000 ns;

    signal CLK_t: STD_LOGIC;
    signal startClock: STD_LOGIC := '0';
    signal reset_t: STD_LOGIC;
    signal instructionWriteEnable_t: STD_LOGIC;
    signal instructionWriteAddr_t: STD_LOGIC_VECTOR(15 downto 0);
    signal instructionWriteData_t: STD_LOGIC_VECTOR(15 downto 0);
    signal instructionOut_t: STD_LOGIC_VECTOR(15 downto 0);
    signal inr_t: STD_LOGIC_VECTOR(3 downto 0);
    signal outr_t: STD_LOGIC_VECTOR(15 downto 0);

    begin
        test: top
        port map (
            CLK => CLK_t,
            instructionWriteEnable => instructionWriteEnable_t,
            instructionWriteAddr => instructionWriteAddr_t,
            instructionWriteData => instructionWriteData_t,
            instructionOut => instructionOut_t,
            inr => inr_t,
            outr => outr_t,
            reset => reset_t
        );

        -- CLK_t <= not CLK_t after CLK_period / 2;

        clk_process: process
        begin
            report "CLOCK";
            if (startClock = '1') then
                CLK_t <= '0';
                wait for CLK_period / 2;
                CLK_t <= '1';
                wait for CLK_period / 2;
            else
                wait for CLK_period / 2;
            end if;
        end process;

        main: process
        begin
            report "MAIN";
            startClock <= '0';
            reset_t <= '1';
            wait for CLK_period;
            reset_t <= '0';

            -- LOAD

            instructionWriteEnable_t <= '1';

            -- First instruction: ld
            -- Opcode rd x6  r1 x7  filler
            -- 0001   0110   0111   0000
            instructionWriteAddr_t <= "0000000000000001";
            instructionWriteData_t <= "0001011001110000";

            wait for CLK_period;
            instructionWriteEnable_t <= '0';
            wait for CLK_period;
            instructionWriteEnable_t <= '1';
            assert instructionOut_t = "0001011001110000";

            -- ldi x6, 3
            -- Opcode rd x6  constant
            -- 0010   0110   00000011
            instructionWriteAddr_t <= "0000000000000010";
            instructionWriteData_t <= "0010011000000011";

            wait for CLK_period;
            instructionWriteEnable_t <= '0';
            wait for CLK_period;
            instructionWriteEnable_t <= '1';

            -- ldi x7, 5
            -- Opcode rd x7  constant
            -- 0010   0111   00000111
            instructionWriteAddr_t <= "0000000000000011";
            instructionWriteData_t <= "0010011100000111";
            
            wait for CLK_period;
            instructionWriteEnable_t <= '0';
            wait for CLK_period;
            instructionWriteEnable_t <= '1';

            -- mv x8, x6
            -- Opcode rd x8  r1 x6  filler
            -- 0100   1000   0110   0000
            instructionWriteAddr_t <= "0000000000000100";
            instructionWriteData_t <= "0100100001100000";

            -- At this point
            -- x6 = 3
            -- x7 = 5
            -- x8 = 3
            -- add x5, x7, x8
            -- Opcode rd x5  r1 x7  r2 x8
            -- 0101   0101   0111   1000
            instructionWriteAddr_t <= "0000000000000101";
            instructionWriteData_t <= "0101010101111000";

            wait for CLK_period;
            instructionWriteEnable_t <= '0';
            wait for CLK_period;
            instructionWriteEnable_t <= '1';

            -- EXECUTE
            startClock <= '1';
            report "Executing add";
            instructionWriteAddr_t <= "0000000000000010"; -- PC = 2
            instructionWriteEnable_t <= '0';
            inr_t <= "0110"; -- Read register 6
            wait for CLK_period * 3; 
            assert outr_t = "0000000000001000";
            wait for CLK_period;
            inr_t <= "0110"; -- Read x6
            wait for CLK_period;
            inr_t <= "0111"; -- Read x7
            wait for CLK_period;
            inr_t <= "1000";
            wait for CLK_period;
            inr_t <= "1001";
            wait for CLK_period;
            report "Execution complete";
            
            report "Test Finished";
        end process main;
        
end Behavioral;
