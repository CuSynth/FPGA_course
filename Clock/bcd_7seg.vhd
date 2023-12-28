library ieee;
use ieee.std_logic_1164.all;
	
entity bcd_7seg is
	port ( 
		clk		:   in  std_logic;
		bin_i	:	in  std_logic_vector(3 downto 0);
		segm_o  :	out std_logic_vector(6 downto 0)
	);
end bcd_7seg;


architecture Behavioral of bcd_7seg is 
begin

	process(clk)
	begin
		case bin_i is
		when "0000" => segm_o <= "1000000"; ---0
		when "0001" => segm_o <= "1111001"; ---1
		when "0010" => segm_o <= "0100100"; ---2
		when "0011" => segm_o <= "0110000"; ---3
		when "0100" => segm_o <= "0011001"; ---4
		when "0101" => segm_o <= "0010010"; ---5
		when "0110" => segm_o <= "0000010"; ---6
		when "0111" => segm_o <= "1111000"; ---7
		when "1000" => segm_o <= "0000000"; ---8
		when "1001" => segm_o <= "0010000"; ---9
		when others => segm_o <= "1111111"; --- None
		end case;
	end process;
end Behavioral;
