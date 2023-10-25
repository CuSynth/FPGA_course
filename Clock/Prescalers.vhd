library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.Math_PACK.all;


entity Prescalers is
	port(
		clk_i		:	in std_logic;
		clk_sec_o	:	out std_logic;	
		clk_min_o	:	out std_logic
	);
end Prescalers;


architecture Behavioral of Prescalers is

	constant CLOCK_PRESCALER 	: natural := (5000000);
--	signal 	 sec_pr_reg			: std_logic_vector(f_log2(CLOCK_PRESCALER)-1 downto 0);
	signal 	 sec_pr_reg			: integer range 0 to CLOCK_PRESCALER := 0;
	signal   min_pr_reg			: integer range 0 to 60 := 0;

	signal	 sec_clk			: std_logic := '0';
	signal	 min_clk			: std_logic := '0';

begin
	process(clk_i)
	begin
		if(rising_edge(clk_i)) then
--			sec_pr_reg <= sec_pr_reg + '1';		
			sec_pr_reg <= sec_pr_reg + 1;		

			if (sec_pr_reg >= CLOCK_PRESCALER) then
--				sec_pr_reg <= (others => '0');
				sec_pr_reg <= 0;
				sec_clk <= '1';
				
				min_pr_reg <= min_pr_reg + 1;
				if(min_pr_reg = 59) then
					min_pr_reg <= 0;
					min_clk <= '1';
				else
					min_clk <= '0';
				end if; -- min_presc = 59
			else
				sec_clk <= '0';
			end if; -- presc_reg >= CLOCK_PRESCALER					
		end if; -- rising_edge(ClockCore_clk)
	end process;
	
	clk_sec_o <= sec_clk;
	clk_min_o <= min_clk;
end Behavioral;