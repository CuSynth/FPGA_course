library ieee;
use ieee.std_logic_1164.all;
	
entity bcd_7seg is
	port ( 
		bin		:	in  std_logic_vector(3 downto 0);
		segm	:	out std_logic_vector(6 downto 0)
	);
end bcd_7seg;


architecture Behavioral of bcd_7seg is 
begin

	process(bin)
	begin
		case bin is
		when "0000" => segm <= "1000000"; ---0
		when "0001" => segm <= "1111001"; ---1
		when "0010" => segm <= "0100100"; ---2
		when "0011" => segm <= "0110000"; ---3
		when "0100" => segm <= "0011001"; ---4
		when "0101" => segm <= "0010010"; ---5
		when "0110" => segm <= "0000010"; ---6
		when "0111" => segm <= "1111000"; ---7
		when "1000" => segm <= "0000000"; ---8
		when "1001" => segm <= "0010000"; ---9
		when others => segm <= "1111111"; --- None
		end case;
	end process;
end Behavioral;
