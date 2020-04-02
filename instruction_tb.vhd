library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity t_instruction is
end t_instruction;

architecture behavior of t_instruction is
    component InstructionMemory is
        port (
            CLK: in STD_LOGIC;
            PC: in STD_LOGIC_VECTOR(15 downto 0);
            outInstruction: out STD_LOGIC_VECTOR(15 downto 0);
            reset: in STD_LOGIC := '0'
        );
    end component InstructionMemory;

    signal CLK_t: STD_LOGIC;
    signal PC_t: STD_LOGIC_VECTOR(15 downto 0);
    signal outInstruction_t: STD_LOGIC_VECTOR(15 downto 0); 
    signal reset_t: STD_LOGIC;

    begin
        instruction: InstructionMemory
        port map(
            CLK => CLK_t,
            PC => PC_t,
            outInstruction => outInstruction_t,
            reset => reset_t
        );
        process
        begin
            -- Test reset
            reset_t <= '1';
            wait for 1 ms;
            reset_t <= '0';
            wait for 1 ms;
            
            -- Ensure zeroed out instruction memory
            for A in 0 to 65536 loop
                PC_t <= STD_LOGIC_VECTOR(to_unsigned(A, 16));
                wait for 1 ns;
                assert outInstruction_t = "0000000000000000";
            end loop;

--             -- Write instructions in location 6, 7, 10
--             writeEnable_t <= '1';
--             PC_t <= "0000000000000110";
--             writeData_t <= "0000000000001111";
--             wait for 1 ms;
--             PC_t <= "0000000000000111";
--             writeData_t <= "0000000000010000";
--             wait for 1 ms;
--             PC_t <= "0000000000001010";
--             writeData_t <= "0000000000010110";
--             wait for 1 ms;
-- 
--             writeEnable_t <= '0';
--             PC_t <= "0000000000000110";
--             wait for 1 ms;
--             assert outInstruction_t = "0000000000001111";
-- 
--             PC_t <= "0000000000000111";
--             wait for 1 ms;
--             assert outInstruction_t = "0000000000010000";
--             
--             PC_t <= "0000000000001010";
--             wait for 1 ms;
--             assert outInstruction_t = "0000000000010110";

        end process;

end behavior;
