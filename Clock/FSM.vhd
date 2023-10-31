library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity FSM is
	port(
		clk			:	in std_logic;
		clk_1Hz		:	in std_logic;	-- for standart clock mode
		clk_2Hz		:	in std_logic;	-- for setup mode
		clk_20Hz	:	in std_logic;	-- for fast update mode

		Set_btn		:	in std_logic;	
		Up_btn		: 	in std_logic;
		Down_btn 	:	in std_logic;
	
		data_out	:	out std_logic_vector(15 downto 0)
	);
end FSM;



architecture Behavioral of FSM is

	type State_t is (Tim, Tim_s, Alarm_s);
	signal State : State_t := Tim;
	
	signal internal_clk  : std_logic;
	signal internal_up   : std_logic;
	signal internal_down : std_logic;


	component ClockCore is
		port (
		CC_clk_i	:	in  std_logic;
		CC_up_i		:	in  std_logic;
		CC_down_i	:	in  std_logic;
		CC_time_o	:	out std_logic_vector(15 downto 0)
		);
	end component; -- ClockCore

begin
	process(Set_btn)
	begin
	if(falling_edge(Set_btn)) then		
		case State is
		when Tim =>
				State <= Tim_s;
		when Tim_s =>
				State <= Alarm_s;			
		when Alarm_s =>
				State <= Tim;		
		end case;
	end if;
	end process;
	
	
	process(clk)
	begin
	if(rising_edge(clk)) then
		case State is
		when Tim =>
			internal_clk <= clk_1Hz;
		when Tim_s =>
		when Alarm_s =>
		end case;
	end if;
	end process;


	ClockCore_map : ClockCore port map (CC_clk_i  => internal_clk,
										CC_up_i	  => internal_up,
									    CC_down_i => internal_down,
										CC_time_o => data_out);
	
end Behavioral;