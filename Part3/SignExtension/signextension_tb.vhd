library IEEE;
use IEEE.std_logic_1164.all;

entity t_signextension is
end t_signextension;

architecture behavior of t_signextension is
    component SignExtension is
        port (
            input: in STD_LOGIC_VECTOR(7 downto 0);
            output: out STD_LOGIC_VECTOR(15 downto 0);
            reset: in STD_LOGIC := '0'
        );
    end component SignExtension;

    signal input_t: STD_LOGIC_VECTOR(7 downto 0);
    signal output_t: STD_LOGIC_VECTOR(15 downto 0);
    signal reset_t: STD_LOGIC;

    begin
        extension: SignExtension
        port map(
            input => input_t,
            output => output_t,
            reset => reset_t
        );
        process
            begin
                -- Test reset
                reset_t <= '1';
                wait for 1 ms;
                assert output_t = "0000000000000000";
                reset_t <= '0';
                wait for 1 ms;

                -- Test positive edge cases
                input_t <= "00000001";
                wait for 1 ms;
                assert output_t = "0000000000000001";
                wait for 1 ms;
                input_t <= "01111111";
                wait for 1 ms;
                assert output_t = "0000000001111111";
                wait for 1 ms;

                -- Test negative edge cases
                input_t <= "10000000";
                wait for 1 ms;
                assert output_t = "1111111110000000";
                wait for 1 ms;
                input_t <= "11111111";
                wait for 1 ms;
                assert output_t = "1111111111111111";
                wait for 1 ms;

                report "Test complete";
        end process;
end architecture;
