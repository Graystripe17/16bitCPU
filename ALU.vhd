library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port (
        CLK: in STD_LOGIC;
        ALUOp: in STD_LOGIC_VECTOR(3 downto 0) := "0000";
        A: in STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
        B: in STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
        isBranch: out STD_LOGIC := '0';
        outToMemory: out STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
        outToRegMux: out STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
        reset: in STD_LOGIC := '1'
    );
end ALU;

architecture Behavioral of ALU is
signal A_t: STD_LOGIC_VECTOR(15 downto 0);
signal B_t: STD_LOGIC_VECTOR(15 downto 0);

begin

    A_t <= A;
    B_t <= B;
    
    process (CLK, reset)
        begin
            if (reset = '1') then
                isBranch <= '0';
                outToMemory <= "0000000000";
                outToRegMux <= "0000000000000000";
            else
                case ALUOp is
                    when "0000" => -- halt
                        -- Do nothing
                        isBranch <= '0'; -- Get branch unstuck
                    when "0001" => -- ld
                        -- Send out last 10 bits for address
                        outToMemory <= A_t(9 downto 0); -- Fetch r1
                        -- Reset outputs
                        isBranch <= '0';
                        outToRegMux <= "0000000000000000";
                    when "0010" => -- ldi
                        -- Handled internally through register file
                        outToMemory <= "0000000000";
                        isBranch <= '0';
                        outToRegMux <= "0000000000000000";
                    when "0011" => -- sd
                        -- Send out last 10 bits of r2
                        outToMemory <= A_t(9 downto 0); -- Used to be B
                        -- Reset outputs
                        isBranch <= '0';
                        outToRegMux <= "0000000000000000";
                    when "0100" => -- mv
                        -- Pass contents of r1 to outToRegMux_t
                        outToRegMux <= A_t;
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "0101" => -- add
                        outToRegMux <= STD_LOGIC_VECTOR(signed(A_t) + signed(B_t));
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "0110" => -- sub
                        outToRegMux <= STD_LOGIC_VECTOR(signed(A_t) - signed(B_t));
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "0111" => -- sll
                        outToRegMux <= STD_LOGIC_VECTOR(shift_left(signed(A_t), to_integer(signed(B))));
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "1000" => -- srl
                        outToRegMux <= STD_LOGIC_VECTOR(shift_right(signed(A_t), to_integer(signed(B))));
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "1001" => -- and
                        outToRegMux <= A_t and B_t;
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "1010" => -- or
                        outToRegMux <= A_t or B_t;
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "1011" => -- beq
                        if (A_t = B) then
                            isBranch <= '1';
                        else
                            isBranch <= '0';
                        end if;
                        outToRegMux <= "0000000000000000";
                        outToMemory <= "0000000000";
                    when "1100" => -- blt
                        if (signed(A_t) < signed(B_t)) then
                            isBranch <= '1';
                            report "BLT";
                        else
                            isBranch <= '0';
                            report "NOB";
                        end if;
                        outToRegMux <= "0000000000000000";
                        outToMemory <= "0000000000";
                    when "1101" => -- bge
                        if (signed(A_t) >= signed(B_t)) then
                            isBranch <= '1';
                        else
                            isBranch <= '0';
                        end if;
                        outToRegMux <= "0000000000000000";
                        outToMemory <= "0000000000";
                    when "1110" => -- jal
                        isBranch <= '1';
                        outToRegMux <= "0000000000000000";
                        outToMemory <= "0000000000";
                    when "1111" => -- jalr
                        isBranch <= '1';
                        outToRegMux <= A_t;
                        outToMemory <= "0000000000";
                    when others =>
                        -- Do nothing
                        report "Invalid opcode";
                end case;
            end if;
    end process;

end Behavioral;
