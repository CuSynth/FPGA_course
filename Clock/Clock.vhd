library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--use work.Math_PACK.all;


entity Clock is
	port 
	(
		clk 	 	:	in std_logic;
		set_btn	 	:	in std_logic;	-- Key2
		plus_btn 	:	in std_logic;	-- Key3
		mins_btn 	:	in std_logic;	-- Key1
		
		alrm_tggler	: 	in std_logic;	-- SW0
		fast_clk_tg	: 	in std_logic;	-- SW1
		
		buzz	 	:	out std_logic;	-- LEDG7
		alrm_on_ind	:	out std_logic;	-- LEDG6
		t_set_ind 	:	out std_logic;	-- LEDG5
		a_set_ind	:	out std_logic;	-- LEDG4
		
		segm_0	 	:	out std_logic_vector(6 downto 0);
		segm_1	 	:	out std_logic_vector(6 downto 0);
		segm_2	 	:	out std_logic_vector(6 downto 0);
		segm_3	 	:	out std_logic_vector(6 downto 0)
	);
end entity;



architecture rtl of Clock is
	signal clk_1Hz		: std_logic;
	signal clk_2Hz		: std_logic;
	signal clk_20Hz		: std_logic;
	
	signal cur_time		: std_logic_vector(15 downto 0);
	
	component Prescalers is
		port (
			clk_i	 	:	in std_logic;
			out_1Hz	 	:	out std_logic;	
			out_2Hz	 	:	out std_logic;	
			out_20Hz 	:	out std_logic
		);
	end component; -- Prescalers
	
	component FSM is
		port(
			clk			:	in std_logic;
			clk_1Hz		:	in std_logic;
			clk_2Hz		:	in std_logic;
			clk_20Hz	:	in std_logic;

			Set_btn		:	in std_logic;	
			Up_btn		: 	in std_logic;
			Down_btn	:	in std_logic;

			alrm_sw 	: 	in std_logic;
			fast_sw		: 	in std_logic;
		
			buzz_o	 	:	out std_logic;
			alrm_on_o	:	out std_logic;
			t_set_o 	:	out std_logic;
			a_set_o		:	out std_logic;
			
			data_out	:	out std_logic_vector(15 downto 0)
		);
	end component; -- FSM
		
	component FourDigitDisplay is
		port (
			bcd_i		:	in std_logic_vector(15 downto 0);
			segm_o  	: 	out std_logic_vector(27 downto 0)
		);
	end component; -- FourDigitDisplay	
	
	
	
begin
	


	Presc_map :	Prescalers port map (clk_i	  => clk, 
									 out_1Hz  => clk_1Hz,
									 out_2Hz  => clk_2Hz,
									 out_20Hz => clk_20Hz);
	
	FSM_map : FSM port map (clk 	  => clk,
							clk_1Hz   => clk_1Hz,
							clk_2Hz   => clk_2Hz,
							clk_20Hz  => clk_20Hz,
							Set_btn	  => set_btn,
							Up_btn 	  => plus_btn,
							Down_btn  => mins_btn,
							alrm_sw   => alrm_tggler,
							fast_sw	  =>	fast_clk_tg,
							buzz_o	  => buzz,
							alrm_on_o => alrm_on_ind,
							t_set_o   => t_set_ind,
							a_set_o	  => a_set_ind,
							data_out  => cur_time);
	
	FourDigitDisplay_map : FourDigitDisplay port map (bcd_i => cur_time,
													  segm_o(6 downto 0)   => segm_0,
													  segm_o(13 downto 7)  => segm_1,
													  segm_o(20 downto 14) => segm_2,
													  segm_o(27 downto 21) => segm_3);	
end rtl;

