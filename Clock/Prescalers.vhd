library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.Math_PACK.all;


entity Prescalers is
	port(
		clk_i	 :	in std_logic;
		out_1Hz	 :	out std_logic;	
		out_2Hz	 :	out std_logic;	
		out_20Hz :	out std_logic
	);
end Prescalers;


architecture Behavioral of Prescalers is
	constant CPU_CLOCK		: natural := 50000000;

	constant PRESCALER_1HZ  : natural := (CPU_CLOCK/1);
	signal 	 presc_reg_1Hz  : integer range 0 to PRESCALER_1HZ := 0;

	constant PRESCALER_2HZ  : natural := (CPU_CLOCK/2);
	signal 	 presc_reg_2Hz  : integer range 0 to PRESCALER_2HZ := 0;

	constant PRESCALER_20HZ : natural := (CPU_CLOCK/20);
	signal 	 presc_reg_20Hz : integer range 0 to PRESCALER_20HZ := 0;
	
begin
	process(clk_i)
	begin
		if(rising_edge(clk_i)) then
		
			presc_reg_1Hz <= presc_reg_1Hz + 1;		
			if (presc_reg_1Hz >= PRESCALER_1HZ) then
				presc_reg_1Hz <= 0;
				out_1Hz <= '1';
			else
				out_1Hz <= '0';
			end if; -- 1Hz_pr_reg >= 1HZ_PRESCALER

			presc_reg_2Hz <= presc_reg_2Hz + 1;		
			if (presc_reg_2Hz >= PRESCALER_2HZ) then
				presc_reg_2Hz <= 0;
				out_2Hz <= '1';
			else
				out_2Hz <= '0';
			end if; -- 2Hz_pr_reg >= 2HZ_PRESCALER
			
			presc_reg_20Hz <= presc_reg_20Hz + 1;		
			if (presc_reg_20Hz >= PRESCALER_20HZ) then
				presc_reg_20Hz <= 0;
				out_20Hz <= '1';
			else
				out_20Hz <= '0';
			end if; -- 20Hz_pr_reg >= 20HZ_PRESCALER

		end if; -- rising_edge(ClockCore_clk)
	end process;
end Behavioral;