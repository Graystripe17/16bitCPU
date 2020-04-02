library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity t_controlunit is
end t_controlunit;

architecture behavior of t_controlunit is
    component ControlUnit is
        port (
            opcode: in STD_LOGIC_VECTOR(15 downto 12);
            cRegWrite: out STD_LOGIC;
            cOffset: out STD_LOGIC;
            cALUOp: out STD_LOGIC_VECTOR(3 downto 0);
            cMemWrite: out STD_LOGIC;
            cMemRead: out STD_LOGIC;
            cMemToReg: out STD_LOGIC;
            cLdi: out STD_LOGIC;
            cJalr: out STD_LOGIC;
            reset: in STD_LOGIC
        );
    end component ControlUnit;

    signal opcode_t: STD_LOGIC_VECTOR(15 downto 12);
    signal cRegWrite_t: STD_LOGIC;
    signal cOffset_t: STD_LOGIC;
    signal cALUOp_t: STD_LOGIC_VECTOR(3 downto 0);
    signal cMemWrite_t: STD_LOGIC;
    signal cMemRead_t: STD_LOGIC;
    signal cMemToReg_t: STD_LOGIC;
    signal cLdi_t: STD_LOGIC;
    signal cJalr_t: STD_LOGIC;
    signal reset_t : STD_LOGIC;

    begin
        control: ControlUnit
        port map (
            opcode => opcode_t,
            cRegWrite => cRegWrite_t,
            cOffset => cOffset_t,
            cALUOp => cALUOp_t,
            cMemWrite => cMemWrite_t,
            cMemRead => cMemRead_t,
            cMemToReg => cMemToReg_t,
            cLdi => cLdi_t,
            cJalr => cJalr_t,
            reset => reset_t
        );
        process
        begin
            -- Test reset
            reset_t <= '1';
            wait for 1 ms;
            reset_t <= '0';
            assert cALUOp_t <= "0000";
            wait for 1 ms;

            -- Test ld
            opcode_t <= "0001";
            wait for 1 ms;
            assert cMemRead_t = '1';
            assert cMemToReg_t = '1';
            wait for 1 ms; 

            -- Test ldi
            opcode_t <= "0010";
            assert cMemRead_t = '1';
            assert cMemToReg_t = '1';
            wait for 1 ms;

            -- Test sd
            opcode_t <= "0011";
            assert cMemWrite_t <= '1';

            -- Test arithmetic type
            for A in 4 to 10 loop
                opcode_t <= STD_LOGIC_VECTOR(to_unsigned(A, 4));
                assert cRegWrite_t <= '1';
                wait for 1 ms;
            end loop;

            -- Test branches and jumps
            for A in 11 to 15 loop
                opcode_t <= STD_LOGIC_VECTOR(to_unsigned(A, 4));
                assert cRegWrite_t <= '1';
                assert cOffset_t <= '1';
                wait for 1 ms;
            end loop;

            report "Test complete";
        end process;
end behavior;
