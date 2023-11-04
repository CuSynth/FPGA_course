library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--use work.Math_PACK.all;


entity Prescalers is
	generic
	(
		constant sys_clock	: natural; 	
		constant req_clock	: natural
	);
	port
	(
		clk_i	 :	in std_logic;
		clk_o	 :	out std_logic
	);
end Prescalers;


architecture Behavioral of Prescalers is
	constant presc_val	: natural := (sys_clock/req_clock);
	signal 	 presc_reg	: integer range 0 to presc_val := 0;
begin
	process(clk_i)
	begin
		if(rising_edge(clk_i)) then
		
			presc_reg <= presc_reg + 1;		
			if (presc_reg >= presc_val) then
				presc_reg <= 0;
				clk_o <= '1';
			else
				clk_o <= '0';
			end if; -- presc_reg >= presc_val

		end if; -- rising_edge(clk_i)
	end process;
end Behavioral;