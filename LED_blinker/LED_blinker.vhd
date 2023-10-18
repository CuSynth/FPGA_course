library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.Math_PACK.all;

entity LED_blinker is
	port 
	(
		clk 	: in std_logic;
		buttons : in std_logic_vector(2 downto 0);
		LEDs	: out std_logic_vector(2 downto 0)
	);
end entity;



architecture rtl of LED_blinker is
	constant CLOCK_PRESCALER 	: natural := 5000000;
	constant UP_PRESCALER 		: natural := 2500000;
	
	signal toggler 		: std_logic; 
	signal blinkler 	: std_logic; 
	signal count_reg	: std_logic_vector(f_log2(CLOCK_PRESCALER)-1 downto 0);

begin
	
	-- Blink
	process (clk)
	begin
	if (rising_edge(clk)) then
		if (buttons(2) = '1') then	
			count_reg <= count_reg + '1';
		
			if (count_reg < UP_PRESCALER) then
				blinkler <= '1';
			elsif (count_reg < CLOCK_PRESCALER) then
				blinkler <= '0';
			else
				count_reg <= (others => '0');
			end if;
		else
			count_reg <= (others => '0');
		end if;
	end if;
	end process;
	
	-- Toggle
	process (buttons(1))
	begin
	if(rising_edge(buttons(1))) then
		toggler <= not(toggler);
	end if;
	end process;
		
	LEDs(0) <= buttons(0);
	LEDs(1) <= toggler;
	LEDs(2) <= blinkler;
	
end rtl;


