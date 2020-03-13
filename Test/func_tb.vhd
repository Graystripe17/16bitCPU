library IEEE;
use IEEE.std_logic_1164.all;

entity t_func is
end t_func;

architecture t_behaviour of t_func is

	component func is
		port(
			I		: in std_logic_vector(3 downto 0);
			Y		: out std_logic);
	end component func;

	signal I_t		: std_logic_vector(3 downto 0);
	signal Y_t		: std_logic;

	begin	

		module_func: func
		port map (
				I => I_t,
				Y => Y_t
				);
		--
		process
			begin
				
				-- inputs which produce '1' on the output
				
				I_t <= "0000";	--0
				wait for 1 ms;
				I_t <= "0001";	--1
				wait for 1 ms;
				I_t <= "0100";	--4
				wait for 1 ms;
				I_t <= "1001";	--9
				wait for 1 ms;
				I_t <= "1110";	--14
				wait for 1 ms;
				
				-- other inputs
				
				I_t <= "0010";	--2
				wait for 1 ms;
				I_t <= "0011";	--3
				wait for 1 ms;
				I_t <= "0101";	--5
				wait for 1 ms;
				I_t <= "0110";	--6
				wait for 1 ms;
				I_t <= "0111";	--7
				wait for 1 ms;
				I_t <= "1000";	--8
				wait for 1 ms;
				I_t <= "1010";	--10
				wait for 1 ms;
				I_t <= "1011";	--11
				wait for 1 ms;
				I_t <= "1100";	--12
				wait for 1 ms;
				I_t <= "1101";	--13
				wait for 1 ms;
				I_t <= "1111";	--15
				wait for 1 ms;
				wait;
			end process;
		--
	--
--
end t_behaviour;
