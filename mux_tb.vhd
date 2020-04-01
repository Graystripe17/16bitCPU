library IEEE;
use IEEE.std_logic_1164.all;

entity t_mux is
end t_mux;

architecture behavior of t_mux is
    component mux2 is 
    port(
        a1: in STD_LOGIC_VECTOR(15 downto 0);
        a2: in STD_LOGIC_VECTOR(15 downto 0);
        sel: in STD_LOGIC;
        b: out STD_LOGIC_VECTOR(15 downto 0)
    );
    end component mux2;

    signal I1_t: STD_LOGIC_VECTOR(15 downto 0);
    signal I2_t: STD_LOGIC_VECTOR(15 downto 0);
    signal S_t: STD_LOGIC;
    signal Y_t: STD_LOGIC_VECTOR(15 downto 0);

    begin
        Mux: mux2
        port map(
            a1 => I1_t,
            a2 => I2_t,
            sel => S_t,
            b => Y_t
        );
        process
            begin
                I1_t <= "0000000000000000";
                I2_t <= "1111111111111111";
                S_t <= '0';
                wait for 1 ms;
                assert Y_t = I1_t;

                S_t <= '1';
                wait for 1 ms;
                assert Y_t = I2_t;

                wait;
        end process;
    end behavior;
