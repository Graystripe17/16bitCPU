library IEEE;
use IEEE.std_logic_1164.all;

entity mux2 is
    port(
        a1: in STD_LOGIC_VECTOR(15 downto 0);
        a2: in STD_LOGIC_VECTOR(15 downto 0);
        sel: in STD_LOGIC;
        b: out STD_LOGIC_VECTOR(15 downto 0)
    );
end mux2;

architecture rtl of mux2 is

begin
    with sel select
        b <= a1 when '0',
             a2 when others;
end rtl;
