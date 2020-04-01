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
            reset: in STD_LOGIC
        );
    end component;

    constant CLK_period: time := 1000 ns;

    signal CLK_t: STD_LOGIC;
    signal reset_t: STD_LOGIC;
    signal instructionWriteEnable_t: STD_LOGIC;
    signal instructionWriteAddr_t: STD_LOGIC_VECTOR(15 downto 0);
    signal instructionWriteData_t: STD_LOGIC_VECTOR(15 downto 0);
    signal instructionOut_t: STD_LOGIC_VECTOR(15 downto 0);

    begin
        test: top
        port map (
            CLK => CLK_t,
            instructionWriteEnable => instructionWriteEnable_t,
            instructionWriteAddr => instructionWriteAddr_t,
            instructionWriteData => instructionWriteData_t,
            reset => reset_t
        );

        -- CLK_t <= not CLK_t after CLK_period / 2;

        clk_process: process
        begin
            CLK_t <= '0';
            wait for CLK_period / 2;
            CLK_t <= '1';
            wait for CLK_period / 2;
        end process;

        main: process
        begin
        
            reset_t <= '0';

            -- LOAD

            instructionWriteEnable_t <= '1';

            -- First instruction: ld
            -- Opcode rd x6  r1 x7  filler
            -- 0001   0110   0111   0000
            instructionWriteAddr_t <= "0000000000000001";
            instructionWriteData_t <= "0001011001110000";

            wait for CLK_period;
            assert instructionOut_t = "0001011001110000";

            -- ldi x6, 3
            -- Opcode rd x6  constant
            -- 0010   0110   00000011
            instructionWriteAddr_t <= "0000000000000010";
            instructionWriteData_t <= "0010011000000011";

            wait for CLK_period;

            -- ldi x7, 5
            -- Opcode rd x7  constant
            -- 0010   0111   00000111
            instructionWriteAddr_t <= "0000000000000011";
            instructionWriteData_t <= "0010011100000111";
            
            wait for CLK_period;

            -- mv x6, x8
            -- Opcode rd x6  r1 x8  filler
            -- 0100   0110   1000   0000
            instructionWriteAddr_t <= "0000000000000100";
            instructionWriteData_t <= "0100011010000000";

            wait for 1 ms;

            -- EXECUTE
            instructionWriteAddr_t <= "0000000000000001";
            instructionWriteEnable_t <= '0';
             
            
            report "Test Finished";
        end process main;
        
end Behavioral;
