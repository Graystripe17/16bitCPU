library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity t_memory is
end t_memory;

architecture behavior of t_memory is
    component Memory is
        port (
            ADDR: in STD_LOGIC_VECTOR(9 downto 0);
            DIN: in STD_LOGIC_VECTOR(15 downto 0);
            cMemWrite: in STD_LOGIC;
            cMemRead: in STD_LOGIC;
            outMemory: out STD_LOGIC_VECTOR(15 downto 0);
            reset: in STD_LOGIC := '0'
        );
    end component Memory;

    signal ADDR_t: STD_LOGIC_VECTOR(9 downto 0);
    signal DIN_t: STD_LOGIC_VECTOR(15 downto 0);
    signal cMemWrite_t: STD_LOGIC;
    signal cMemRead_t: STD_LOGIC;
    signal outMemory_t: STD_LOGIC_VECTOR(15 downto 0); 
    signal reset_t: STD_LOGIC;

    begin
        mem: Memory
        port map(
            ADDR => ADDR_t,
            DIN => DIN_t,
            cMemWrite => cMemWrite_t,
            cMemRead => cMemRead_t,
            outMemory => outMemory_t,
            reset => reset_t
        );
        process
        begin
            -- Test reset
            reset_t <= '1';
            wait for 1 ms;
            reset_t <= '0';
            wait for 1 ms;
            
            -- Test mem read/write
            cMemWrite_t <= '1';
            ADDR_t <= "1010101010"; -- Address 682
            DIN_t <= "1000000000000000"; -- 32768
            wait for 1 ms;
            cMemWrite_t <= '0';
            cMemRead_t <= '1';
            ADDR_t <= "1010101010";
            wait for 1 ms;
            assert outMemory_t = DIN_t;

        end process;
            

end behavior;
