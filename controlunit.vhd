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
        cJalr: out STD_LOGIC;
        reset: in STD_LOGIC
    );
end ControlUnit;

architecture Behavioral of ControlUnit is
    
begin
    process (reset, opcode)
    begin
        if (reset = '1') then
            cRegWrite <= '0';
            cOffset <= '0';
            cALUOp <= "0000";
            cMemWrite <= '0';
            cMemRead <= '0';
            cMemToReg <= '0';
            cLdi <= '0';
            cJalr <= '0';
        else
            cALUOp <= opcode;
            case opcode is
                when "0001" => -- ld
                    -- Loads from memory into rd
                    cRegWrite <= '1';
                    cOffset <= '0';
                    cMemWrite <= '0';
                    cMemRead <= '1';
                    cMemToReg <= '1'; -- Pass back memory
                    cLdi <= '0';
                    cJalr <= '0';
                when "0010" => -- ldi
                    -- Loads 8 bit immediate into rd
                    cRegWrite <= '1';
                    cOffset <= '0';
                    cMemWrite <= '0';
                    cMemRead <= '0';
                    cMemToReg <= 'X'; -- Ignored
                    cLdi <= '1';
                    cJalr <= '0';
                when "0011" => -- sd
                    -- Stores to memory
                    cRegWrite <= '0';
                    cOffset <= '0';
                    cMemWrite <= '1';
                    cMemRead <= '0';
                    cMemToReg <= '0';
                    cLdi <= '0';
                    cJalr <= '0';
                when "0100" | "0101" | "0110" | "0111" | "1000" | "1001" | "1010" => 
                    -- mv | add | sub | sll | srl | and | or
                    cRegWrite <= '1';
                    cOffset <= '0';
                    cMemWrite <= '0';
                    cMemRead <= '0';
                    cMemToReg <= '0'; -- Pass back ALU out
                    cLdi <= '0';
                    cJalr <= '0';
                when "1011" | "1100" | "1101" | "1110" =>
                    -- beq | blt | bge | jal
                    cRegWrite <= '0'; -- Check
                    cOffset <= '1';
                    cMemWrite <= '0';
                    cMemRead <= '0';
                    cMemToReg <= '0';
                    cLdi <= '0';
                    cJalr <= '0';
                when "1111" =>
                    -- jalr
                    cRegWrite <= '1';
                    cOffset <= '1';
                    cMemWrite <= '0';
                    cMemRead <= '0';
                    cMemToReg <= '0';
                    cLdi <= '0';
                    cJalr <= '1';
                when others => -- halt
                    cRegWrite <= '0';
                    cOffset <= '0';
                    cMemWrite <= '0';
                    cMemRead <= '0';
                    cMemToReg <= '0';
                    cLdi <= '0';
                    cJalr <= '0';
            end case;
        end if;
    end process;
end Behavioral;
