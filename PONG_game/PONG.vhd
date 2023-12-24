LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY PONG IS
PORT(   
		clk_i		: in std_logic;
		
		up_btn		: in std_logic;
		dn_btn		: in std_logic;

		up_LED		: out std_logic;
		dn_LED		: out std_logic
	);
end  PONG;

architecture rtl of PONG is

begin
	
	process (clk_i)
	begin
	if (rising_edge(clk_i)) then
		if (up_btn = '1') then
			up_LED <= '1';
		else
			up_LED <= '0';
		end if;
	end if;
	end process;
	
	dn_LED <= dn_btn;
		
end rtl;