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
        );
    end component ControlUnit;

    signal opcode_t: STD_LOGIC_VECTOR(15 downto 12);
    signal cRegWrite_t: STD_LOGIC;
    signal cOffset_t: STD_LOGIC;
    signal cALUOp_t: STD_LOGIC;
    signal cMemWrite_t: STD_LOGIC;
    signal cMemRead_t: STD_LOGIC;
    signal cMemToReg_t: STD_LOGIC;
    signal cLdi_t: STD_LOGIC;
    signal CMv_t: STD_LOGIC;

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
            cMv => cMv_t
        );
        process
        begin

        end process;
end behavior;
