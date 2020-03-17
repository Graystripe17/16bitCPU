library IEEE;
use IEEE.std_logic_1164.all;

entity t_adder is
end t_adder;

architecture behavior of t_adder is
    component Adder is
        generic (
            N: natural := 16
        );
        port (
            A: in STD_LOGIC_VECTOR(N-1 downto 0);
            B: in STD_LOGIC_VECTOR(N-1 downto 0);
            sum: out STD_LOGIC_VECTOR(N-1 downto 0);
            Cout: out STD_LOGIC;
            reset: in STD_LOGIC
        );
    end component Adder;
    signal A_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal B_t: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal sum_t: STD_LOGIC_VECTOR(15 downto 0);
    signal Cout_t: STD_LOGIC;
    signal reset_t: STD_LOGIC := '0';
    begin
        add: Adder
        generic map (
            N => 16
        )
        port map (
            A => A_t,
            B => B_t,
            sum => sum_t,
            Cout => Cout_t,
            reset => reset_t
        );
    process
        begin
            -- Test reset
            reset_t <= '1';
            wait for 1 ms;
            reset_t <= '0';
            assert Cout_t <= '0';
            assert sum_t = "0000000000000000";
            
            -- Test addition
            A_t <= "1000000000000001";
            B_t <= "1000000000001101";
            wait for 1 ms;
            assert sum_t = "0000000000001110"; -- 14
            report "Tests complete";
            wait for 2 ms;
    end process;
end behavior;
