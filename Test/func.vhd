library IEEE;
use IEEE.std_logic_1164.all;

entity func is
	port(
		I	: in  std_logic_vector(3 downto 0);
        Y	: out std_logic);
end func;

architecture behaviour of func is
begin	
	process (I)
	begin
		case (I) is
			when "0000" => Y <= '1';
			when "0001" => Y <= '1';
			when "0100" => Y <= '1';
			when "1001" => Y <= '1';
			when "1110" => Y <= '1';
			when others => Y <= '0';
		end case;
	end process;
end behaviour;
