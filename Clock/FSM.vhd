library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity FSM is
	port(
		clk			:	in  std_logic;
		Up			: 	in  std_logic;
		Down 		:	in  std_logic;
		AlarmON		:	in  std_logic;
		
		data_out	:	out std_logic_vector(15 downto 0)
	);
end FSM;