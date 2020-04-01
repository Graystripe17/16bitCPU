library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Adder is
    generic (N: natural := 16);
    port (
        A: in STD_LOGIC_VECTOR(N-1 downto 0);
        B: in STD_LOGIC_VECTOR(N-1 downto 0);
        sum: out STD_LOGIC_VECTOR(N-1 downto 0);
        Cout: out STD_LOGIC;
        reset: in STD_LOGIC := '0'
    );
end Adder;


architecture Behavioral of Adder is
    signal result: STD_LOGIC_VECTOR(N downto 0);
    begin
        process (reset, A, B)
            begin
                if (reset = '0') then
                    result <= std_logic_vector(unsigned(('0' & A)) + unsigned(('0' & B)));
                else
                    result <= (others => '0');
                end if;
        end process;

        process (result)
            begin
                sum <= result(N-1 downto 0);
                Cout <= result(N);
        end process;
end Behavioral;
