library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity t_pc is
end t_pc;

architecture behavior of t_pc is
    component PC is
        port (
            DIN: in STD_LOGIC_VECTOR(15 downto 0);
            address: buffer STD_LOGIC_VECTOR(15 downto 0);
            CLK: in STD_LOGIC;
            reset: in STD_LOGIC := '0'
        );
    end component PC;

    signal DIN_t: STD_LOGIC_VECTOR(15 downto 0);
    signal address_t: STD_LOGIC_VECTOR(15 downto 0);
    signal CLK_t: STD_LOGIC;
    signal reset_t: STD_LOGIC;

    begin
        r15: PC
        port map (
            DIN => DIN_t,
            address => address_t,
            CLK => CLK_t,
            reset => reset_t
        );
        process
        begin
            -- Test reset
            reset_t <= '1';
            wait for 1 ms;
            reset_t <= '0';
            assert address_t = 
        end process;
end behavior;
