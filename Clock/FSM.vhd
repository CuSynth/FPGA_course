library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity FSM is
	port(
		clk				:	in std_logic;
		clk_1Hz			:	in std_logic;
		clk_2Hz			:	in std_logic;
		clk_10Hz		:	in std_logic;

		Up_btn			: 	in std_logic;
		Down_btn 		:	in std_logic;
		Set_btn			:	in std_logic;	

		FSM_sw  		: 	in std_logic;		
		Alarm_sw		:	in std_logic;
	
		alarm_out		:	in std_logic;
		alarm_set_out	:	in std_logic;
		data_set_out	:	in std_logic;
		data_out		:	out std_logic_vector(15 downto 0)
	);
end FSM;



architecture Behavioral of ClockCore is

	type State_t is (Tim, Tim_s, Alarm_s);
	signal State : State_t := Tim;

	

begin



end Behavioral;