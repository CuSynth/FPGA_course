library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity UART_example is
	port 
	(
		clk : in std_logic
	);
end entity;

architecture rtl of UART_example is
	signal system_clk : std_logic;
	
	component Main_PLL is
	port
	(
		inclk0		: in std_logic;
		c0			: out std_logic 
	);
	end component;
	
begin

	PLL_map: Main_PLL port map 
	(
		inclk0 => clk,
		c0 => system_clk
	); 
	
------------------------------------------	
	
	process(system_clk)
	begin 
	
	end process;



end rtl;