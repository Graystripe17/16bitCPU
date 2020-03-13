library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity t_alu is
end t_alu;

architecture behavior of t_alu is
    component ALU is 
        port(
            ALUOp: in STD_LOGIC_VECTOR(3 downto 0) := "0000";
            A: in STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
            B: in STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
            isBranch: out STD_LOGIC := '0';
            outToMemory: out STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
            outToRegMux: out STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
            reset: in STD_LOGIC := '1'
        );
    end component ALU;

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

                -- Test writing to ld
                ALUOp_t <= "0000";
                -- Only last 10 bits make address
                A_t <= "0000001000000000";
                assert outToRegMux_t <= "0000000000000000";
        end process;


end behavior;
