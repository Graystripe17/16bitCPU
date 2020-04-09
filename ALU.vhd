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
signal outToRegMux_t: STD_LOGIC_VECTOR(15 downto 0);

begin

    outToRegMux <= outToRegMux_t;
    
    process (CLK, reset)
        begin
            if (reset = '1') then
                isBranch <= '0';
                outToMemory <= "0000000000";
                outToRegMux_t <= "0000000000000000";
            else
                case ALUOp is
                    when "0000" => -- halt
                        -- Do nothing
                        isBranch <= '0'; -- Get branch unstuck
                    when "0001" => -- ld
                        -- Send out last 10 bits for address
                        outToMemory <= A(9 downto 0); -- Fetch r1
                        -- Reset outputs
                        isBranch <= '0';
                        outToRegMux_t <= "0000000000000000";
                    when "0010" => -- ldi
                        -- Handled internally through register file
                        outToMemory <= "0000000000";
                        isBranch <= '0';
                        outToRegMux_t <= "0000000000000000";
                    when "0011" => -- sd
                        -- Send out last 10 bits of r2
                        outToMemory <= B(9 downto 0);
                        -- Reset outputs
                        isBranch <= '0';
                        outToRegMux_t <= "0000000000000000";
                    when "0100" => -- mv
                        -- Pass contents of r1 to outToRegMux_t
                        outToRegMux_t <= A;
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "0101" => -- add
                        outToRegMux_t <= STD_LOGIC_VECTOR(signed(A) + signed(B));
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "0110" => -- sub
                        outToRegMux_t <= STD_LOGIC_VECTOR(signed(A) - signed(B));
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "0111" => -- sll
                        outToRegMux_t <= STD_LOGIC_VECTOR(shift_left(signed(A), to_integer(signed(B))));
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "1000" => -- srl
                        outToRegMux_t <= STD_LOGIC_VECTOR(shift_right(signed(A), to_integer(signed(B))));
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "1001" => -- and
                        outToRegMux_t <= A and B;
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "1010" => -- or
                        outToRegMux_t <= A or B;
                        -- Reset outputs
                        isBranch <= '0';
                        outToMemory <= "0000000000";
                    when "1011" => -- beq
                        if (A = B) then
                            isBranch <= '1';
                        else
                            isBranch <= '0';
                        end if;
                        outToRegMux_t <= "0000000000000000";
                        outToMemory <= "0000000000";
                    when "1100" => -- blt
                        if (signed(A) < signed(B)) then
                            isBranch <= '1';
                        else
                            isBranch <= '0';
                        end if;
                        outToRegMux_t <= "0000000000000000";
                        outToMemory <= "0000000000";
                    when "1101" => -- bge
                        if (signed(A) >= signed(B)) then
                            isBranch <= '1';
                        else
                            isBranch <= '0';
                        end if;
                        outToRegMux_t <= "0000000000000000";
                        outToMemory <= "0000000000";
                    when "1110" => -- jal
                        isBranch <= '1';
                        outToRegMux_t <= "0000000000000000";
                        outToMemory <= "0000000000";
                    when "1111" => -- jalr
                        isBranch <= '1';
                        outToRegMux_t <= A;
                        outToMemory <= "0000000000";
                    when others =>
                        -- Do nothing
                        report "Invalid opcode";
                end case;
            end if;
    end process;

end Behavioral;
