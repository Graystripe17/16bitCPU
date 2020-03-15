library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ControlUnit is
    port (
        opcode: in STD_LOGIC_VECTOR(15 downto 12);
        cRegWrite: out STD_LOGIC;
        cOffset: out STD_LOGIC;
        cALUOp: out STD_LOGIC_VECTOR(3 downto 0);
        cMemWrite: out STD_LOGIC;
        cMemRead: out STD_LOGIC;
        cMemToReg: out STD_LOGIC;
        cLdi: out STD_LOGIC;
        cMv: out STD_LOGIC;
    );
end ControlUnit;

architecture Behavioral of ControlUnit is
    
begin
    process (reset)
    begin
        if (reset = '1') then
            cRegWrite <= '0';
            cOffset <= '0';
            cALUOp <= '0';
            cMemWrite <= '0';
            cMemRead <= '0';
            cMemToReg <= '0';
            cLdi <= '0';
            cMv <= '0';
        else
            
        end if;
    end process;
end Behavioral;
