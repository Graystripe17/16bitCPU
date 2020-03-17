
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Lab8 is
    port(
        CLK: in STD_LOGIC;
        Y: out STD_LOGIC_VECTOR(6 downto 0);
        AN: out STD_LOGIC_VECTOR(7 downto 0) := "11111110"
    );
end Lab8;

architecture Behavioral of Lab8 is
    constant T : time := 10 ns;
    constant H7 : STD_LOGIC_VECTOR(6 downto 0) := "0111110";
    constant E7 : STD_LOGIC_VECTOR(6 downto 0) := "0011111";
    constant L7 : STD_LOGIC_VECTOR(6 downto 0) := "0001111";
    constant O7 : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
    constant CLEAR: STD_LOGIC_VECTOR(6 downto 0) := "1111111";
    
    signal timeup: STD_LOGIC := '0';
    signal selector: STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal result: STD_LOGIC_VECTOR(6 downto 0) := "1111110";
    component counter is
        generic(overflow: integer := 1000000);
        port(
            CLK: in std_logic;
            Oout: out std_logic
        );
    end component;
    component MUX is
        port(a, b, c, d, e, f, g, h: in std_logic_vector(6 downto 0);
             s: in std_logic_vector(2 downto 0);
             output: out std_logic_vector(6 downto 0);
             AN: out std_logic_vector(7 downto 0));
    end component;
begin
    ms: counter
        generic map(overflow=>1000000)
        port map(CLK=>CLK, Oout=>timeup);    
    
    selectmeboy: MUX
        port map(a=>H7, b=>E7, c=>L7, d=>L7, e=>O7, f=>CLEAR, g=>CLEAR, h=>CLEAR, s=>selector, output=>Y, AN=>AN);
    
    bounce: process(timeup)
    begin
        if (rising_edge(timeup)) then
            selector <= std_logic_vector(unsigned(selector) + 1);
        end if;
    end process bounce;

end Behavioral;
