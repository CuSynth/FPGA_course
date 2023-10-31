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
	
		alrm_sw 	: 	in std_logic;
		fast_sw		: 	in std_logic;
		
		buzz_o	 	:	out std_logic;
		alrm_on_o	:	out std_logic;
		t_set_o 	:	out std_logic;
		a_set_o		:	out std_logic;
	
		data_out	:	out std_logic_vector(15 downto 0)
	);
end FSM;



architecture Behavioral of FSM is

	type State_t is (Tim, Tim_s, Alarm_s);
	signal State : State_t := Tim;
	
	signal internal_time_clk  		: std_logic;
	signal internal_alarm_clk   : std_logic;
	signal internal_up   		: std_logic;
	signal internal_down 		: std_logic;

	signal cur_time 	 		: std_logic_vector(15 downto 0);
	signal cur_alarm 	 		: std_logic_vector(15 downto 0);


	component ClockCore is
		port (
		CC_clk_i	:	in  std_logic;
		CC_up_i		:	in  std_logic;
		CC_down_i	:	in  std_logic;
		CC_time_o	:	out std_logic_vector(15 downto 0)
		);
	end component; -- ClockCore

	component AlarmCore is
		port(
		AC_clk_i		:	in  std_logic;
		AC_set_clk_i	:	in  std_logic;
		AC_up_i			:	in  std_logic;
		AC_down_i		:	in  std_logic;
		AC_time_i		:	in  std_logic_vector(15 downto 0);
		AC_time_o		:	out std_logic_vector(15 downto 0);
		AC_buzz_o		:   out std_logic
		);
	end component;


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
			if(fast_sw = '0') then
				internal_time_clk  <= clk_1Hz;
			else
				internal_time_clk  <= clk_20Hz;
			end if;
			internal_alarm_clk <= '0';
			internal_up   <= '1';
			internal_down <= '0';
		
			data_out  <= cur_time;
			
			t_set_o <= '0';
			a_set_o <= '0';
			when Tim_s =>
			internal_time_clk <= clk_2Hz;
			internal_alarm_clk <= '0';
			internal_up   <= Up_btn;
			internal_down <= Down_btn;
			
			data_out  <= cur_time;
			
			t_set_o <= '1';
			a_set_o <= '0';
		when Alarm_s =>
			internal_time_clk <= '0';
			internal_alarm_clk <= clk_2Hz;
			internal_up   <= Up_btn;
			internal_down <= Down_btn;			
			
			data_out  <= cur_alarm;
			
			t_set_o <= '0';
			a_set_o <= '1';
		end case;
	end if;
	end process;


	ClockCore_map : ClockCore port map (CC_clk_i  => internal_time_clk,
										CC_up_i	  => internal_up,
									    CC_down_i => internal_down,
										CC_time_o => cur_time);
										
	AlarmCore_map : AlarmCore port map (AC_clk_i => (clk and alrm_sw),
										AC_set_clk_i => internal_alarm_clk,
										AC_up_i => internal_up,
										AC_down_i => internal_down,
										AC_time_i => cur_time,
										AC_time_o => cur_alarm,
										AC_buzz_o => buzz_o);

	alrm_on_o <= alrm_sw;
end Behavioral;