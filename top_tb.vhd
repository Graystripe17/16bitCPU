library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity t_top is
end t_top;

architecture Behavioral of t_top is
    component top
        port (
            CLK: in STD_LOGIC;
            instructionWriteEnable: in STD_LOGIC;
            instructionWriteAddr: in STD_LOGIC_VECTOR(15 downto 0);
            instructionWriteData: in STD_LOGIC_VECTOR(15 downto 0);
            startPC: in STD_LOGIC_VECTOR(15 downto 0);
            instructionOut: out STD_LOGIC_VECTOR(15 downto 0); -- Debug
            inr: in STD_LOGIC_VECTOR(3 downto 0); -- Debug rf
            outr: out STD_LOGIC_VECTOR(15 downto 0); -- Debug rf
            reset: in STD_LOGIC
        );
    end component;

    constant CLK_period: time := 10 ns;

    signal CLK_t: STD_LOGIC;
    signal reset_t: STD_LOGIC;
    signal instructionWriteEnable_t: STD_LOGIC;
    signal instructionWriteAddr_t: STD_LOGIC_VECTOR(15 downto 0);
    signal instructionWriteData_t: STD_LOGIC_VECTOR(15 downto 0);
    signal startPC_t: STD_LOGIC_VECTOR(15 downto 0);
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
            startPC => startPC_t,
            instructionOut => instructionOut_t,
            inr => inr_t,
            outr => outr_t,
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
            report "MAIN";
            reset_t <= '1';
            wait for CLK_period;
            reset_t <= '0';
            startPC_t <= "0000000000000000";

            -- LOAD
-- 
--             instructionWriteEnable_t <= '1';
-- 
--             -- Start on instruction 18
--             -- First instruction: ld
--             -- Opcode rd x6  r1 x7  filler
--             -- 0001   0110   0111   0000
--             instructionWriteAddr_t <= "0000000000010010"; -- 18
--             instructionWriteData_t <= "0001011001110000";
-- 
--             wait for CLK_period;
--             instructionWriteEnable_t <= '0';
--             wait for CLK_period;
--             instructionWriteEnable_t <= '1';
-- 
--             -- ldi x6, 3
--             -- Opcode rd x6  constant
--             -- 0010   0110   00000011
--             instructionWriteAddr_t <= "0000000000010011"; -- 19
--             instructionWriteData_t <= "0010011000000011";
-- 
--             wait for CLK_period;
--             instructionWriteEnable_t <= '0';
--             wait for CLK_period;
--             instructionWriteEnable_t <= '1';
-- 
--             -- ldi x7, 7
--             -- Opcode rd x7  constant
--             -- 0010   0111   00000111
--             instructionWriteAddr_t <= "0000000000100100"; -- 20
--             instructionWriteData_t <= "0010011100000111";
--             
--             wait for CLK_period;
--             instructionWriteEnable_t <= '0';
--             wait for CLK_period;
--             instructionWriteEnable_t <= '1';
-- 
--             -- mv x8, x6
--             -- Opcode rd x8  r1 x6  filler
--             -- 0100   1000   0110   0000
--             instructionWriteAddr_t <= "0000000000100101"; -- 21
--             instructionWriteData_t <= "0100100001100000";
-- 
--             inr_t <= "1000"; -- Check value of x8
-- 
--             wait for CLK_period;
--             assert outr_t <= "0000000000000011";
--             instructionWriteEnable_t <= '0';
--             wait for CLK_period;
--             instructionWriteEnable_t <= '1';
-- 
--             -- Test add
--             -- x6 = 3
--             -- x7 = 7
--             -- x8 = 3
--             -- add x5, x7, x8
--             -- Opcode rd x5  r1 x7  r2 x8
--             -- 0101   0101   0111   1000
--             -- Expect x5 to hold 0xA 
--             instructionWriteAddr_t <= "0000000000100110"; -- 22
--             instructionWriteData_t <= "0101010101111000";
-- 
--             wait for CLK_period;
--             instructionWriteEnable_t <= '0';
--             wait for CLK_period;
--             instructionWriteEnable_t <= '1';
-- 
--             -- Test blt
--             -- Opcode rd x8  r1 x7  r2 x5
--             -- 1100   1000   0111   1010
--             -- If 7 < 10, branch to 0x3
--             instructionWriteAddr_t <= "0000000000100111"; -- 23
--             instructionWriteData_t <= "1100100001110101";
-- 
--             wait for CLK_period;
--             instructionWriteEnable_t <= '0';
--             wait for CLK_period;
--             instructionWriteEnable_t <= '1';
-- 
--             -- Test jalr
--             -- Opcode rd x5  r1 x7  filler
--             -- 1111   0101   0111   0000
--             -- PC should jump to 0xA
--             --instructionWriteAddr_t <= "0000000000100111"; -- 23
--             --instructionWriteData_t <= "1111010101110000";
-- 
--             --inr_t <= "1010"; -- Check value of x10
-- 
--             wait for CLK_period;
--             assert outr_t <= "0000000000000111"; -- x10 match value of x7
--             instructionWriteEnable_t <= '0';
--             wait for CLK_period;
--             instructionWriteEnable_t <= '1';
-- 
--             -- EXECUTE
--             report "Executing add";
--             startPC_t <= "0000000000000010"; -- Useless
--             instructionWriteAddr_t <= "0000000000100010"; -- PC = 2
--             instructionWriteEnable_t <= '0';
--             inr_t <= "0101"; -- Read register 5
--             wait for CLK_period; 
--             assert outr_t = "0000000000001010"; -- Assert equal to 10
--             wait for CLK_period;
--             inr_t <= "0110"; -- Read x6
--             wait for CLK_period;
--             inr_t <= "0111"; -- Read x7
--             wait for CLK_period;
--             inr_t <= "1000";
--             wait for CLK_period;
--             inr_t <= "1001";
--             wait for CLK_period * 50;
--             report "Execution complete";
                for A in 0 to 15 loop
                    inr_t <= STD_LOGIC_VECTOR(to_unsigned(A, 4));
                    wait for 10 ns;
                end loop;
                for A in 0 to 15 loop
                    inr_t <= STD_LOGIC_VECTOR(to_unsigned(A, 4));
                    wait for 10 ns;
                end loop;
                for A in 0 to 15 loop
                    inr_t <= STD_LOGIC_VECTOR(to_unsigned(A, 4));
                    wait for 10 ns;
                end loop;
                for A in 0 to 15 loop
                    inr_t <= STD_LOGIC_VECTOR(to_unsigned(A, 4));
                    wait for 10 ns;
                end loop;
            report "Test Finished";
        end process main;
        
end Behavioral;
