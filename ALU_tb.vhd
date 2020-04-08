library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity t_alu is
end t_alu;

architecture behavior of t_alu is
    component ALU is 
        port(
            CLK: in STD_LOGIC;
            ALUOp: in STD_LOGIC_VECTOR(3 downto 0) := "0000";
            A: in STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
            B: in STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
            isBranch: out STD_LOGIC := '0';
            outToMemory: out STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
            outToRegMux: out STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
            reset: in STD_LOGIC := '1'
        );
    end component ALU;

    signal CLK_t: STD_LOGIC := '0';
    signal ALUOp_t: STD_LOGIC_VECTOR(3 downto 0);
    signal A_t: STD_LOGIC_VECTOR(15 downto 0);
    signal B_t: STD_LOGIC_VECTOR(15 downto 0);
    signal isBranch_t: STD_LOGIC;
    signal outToMemory_t: STD_LOGIC_VECTOR(9 downto 0);
    signal outToRegMux_t: STD_LOGIC_VECTOR(15 downto 0);
    signal reset_t: STD_LOGIC;

    begin
        math: ALU
        port map(
            CLK => CLK_t,
            ALUOp => ALUOp_t,
            A => A_t,
            B => B_t,
            isBranch => isBranch_t,
            outToMemory => outToMemory_t,
            outToRegMux => outToRegMux_t,
            reset => reset_t
        );
        process
            begin
                -- Test reset
                reset_t <= '1';
                wait for 1 ms;
                reset_t <= '0';
                assert outToMemory_t = "0000000000";
                assert outToRegMux_t = "0000000000000000";
                wait for 1 ms;

                -- Test writing to ld
                ALUOp_t <= "0001";
                -- Only last 10 bits make address
                A_t <= "0000001000000000";
                wait for 1 ms;
                assert outToRegMux_t = "0000000000000000";
                wait for 1 ms;

                -- Test sd
                ALUOp_t <= "0011";
                B_t <= "0000000000001111";
                wait for 1 ms;
                assert outToMemory_t = "0000001111";
                wait for 1 ms;

                -- Test mv
                ALUOp_t <= "0100";
                A_t <= "0000000000010000";
                wait for 1 ms;
                assert outToMemory_t = "0000000000";
                wait for 1 ms;

                -- Test add
                ALUOp_t <= "0101";
                A_t <= "0000000000000101";
                B_t <= "0000000000001010";
                wait for 1 ms;
                assert outToRegMux_t = "0000000000001111";
                wait for 1 ms;

                -- Test sub
                ALUOp_t <= "0110";
                A_t <= "0000000000000101";
                B_t <= "0000000000001010";
                wait for 1 ms;
                assert outToRegMux_t = "1111111111111011";
                wait for 1 ms;

                -- Test sll
                ALUOp_t <= "0111";
                A_t <= "1010101010101010";
                B_t <= "0000000000000001";
                wait for 1 ms;
                assert outToRegMux_t = "0101010101010100";
                wait for 1 ms;

                -- Test srl
                ALUOp_t <= "1000";
                A_t <= "1010000010101010";
                B_t <= "0000000000000011";
                wait for 1 ms;
                assert outToRegMux_t = "1111010000010101"; -- Pad with 1
                wait for 1 ms;
                
                -- Test and
                ALUOp_t <= "1001";
                A_t <= "0000000010101111";
                B_t <= "0000000001101111";
                wait for 1 ms;
                assert outToRegMux_t = "0000000000101111";
                wait for 1 ms;
                -- Test overflow
                A_t <= "1111111111111100";
                B_t <= "1111111111111101";
                wait for 1 ms;
                assert outToRegMux_t = "1111111111111100";
                wait for 1 ms;

                -- Test or
                ALUOp_t <= "1010";
                A_t <= "0000000010101111";
                B_t <= "0000000001101111";
                wait for 1 ms;
                assert outToRegMux_t = "0000000011101111";
                wait for 1 ms;

                -- Test beq
                ALUOp_t <= "1011";
                A_t <= "0000000010101111";
                B_t <= "0000000010101111";
                wait for 1 ms;
                assert isBranch_t = '1';
                wait for 1 ms;

                -- Test blt
                ALUOp_t <= "1100";
                wait for 1 ms;
                assert isBranch_t = '0';
                wait for 1 ms;

                -- Test bge
                ALUOp_t <= "1101";
                wait for 1 ms;
                assert isBranch_t = '1';
                wait for 1 ms;
                
                -- Test jal
                ALUOp_t <= "1110";
                A_t <= "1111111111111111";
                wait for 1 ms;
                assert outToRegMux_t = "0000000000000000";
                assert isBranch_t = '1';
                wait for 1 ms;

                -- Test jalr
                ALUOp_t <= "1111";
                A_t <= "1111111111111111";
                wait for 1 ms;
                assert outToRegMux_t = "1111111111111111";
                assert isBranch_t = '1';
                wait for 1 ms;

                report "Test complete";
        end process;
end behavior;
