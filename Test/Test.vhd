-- Quartus II VHDL Template
-- Basic Shift Register

library ieee;
use ieee.std_logic_1164.all;

entity Test is

	generic
	(
		NUM_STAGES : natural := 8
	);

	port 
	(
		clk		: in std_logic;
		s		: in std_logic;
		r		: in std_logic;
		q		: out std_logic
	);

end entity;

architecture rtl of Test is
	signal RS	: std_logic;

begin

	process (clk)
	begin
		if (rising_edge(clk)) then

			if (s = '1') then
				RS <= '1';
			end if;

			if (r = '1') then
				RS <= '0';
			end if;
			
		end if;
	end process;

	q <= RS;
end rtl;
