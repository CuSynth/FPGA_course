library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--use work.Math_PACK.all;


entity Clock is
	port 
	(
		clk 	:	in std_logic;
		buzz	:	out std_logic;
		
		segm_0	: 	out std_logic_vector(6 downto 0);
		segm_1	: 	out std_logic_vector(6 downto 0);
		segm_2	: 	out std_logic_vector(6 downto 0);
		segm_3	: 	out std_logic_vector(6 downto 0)
	);
end entity;



architecture rtl of Clock is
	signal	 sec_clk_sig		: std_logic := '0';
	signal	 min_clk_sig		: std_logic := '0';
	
	signal	 cur_time			: std_logic_vector(15 downto 0);
	
	component Prescalers is
		port (
			clk_i		:	in std_logic;
			clk_sec_o	:	out std_logic;	
			clk_min_o	:	out std_logic
		);
	end component; -- Prescalers
	
	component ClockCore is
		port (
		ClockCore_clk			:	in  std_logic;
		ClockCore_up			:	in  std_logic;
		ClockCore_down			:	in  std_logic;
		ClockCore_time_out		:	out std_logic_vector(15 downto 0)
		);
	end component; -- ClockCore
	
	component FourDigitDisplay is
		port (
			FourDigitDisplay_bcd	:	in std_logic_vector(15 downto 0);
			FourDigitDisplay_segm	: 	out std_logic_vector(27 downto 0)
		);
	end component; -- FourDigitDisplay	
	
begin
	Presc_map :	Prescalers port map (clk_i 	   => clk, 
									 clk_sec_o => sec_clk_sig,
									 clk_min_o => min_clk_sig);
										 
	ClockCore_map : ClockCore port map (ClockCore_clk      => sec_clk_sig,
										ClockCore_up	   => '1',
										ClockCore_down	   => '0',
										ClockCore_time_out => cur_time);
	
	FourDigitDisplay_map : FourDigitDisplay port map (FourDigitDisplay_bcd => cur_time,
													  FourDigitDisplay_segm(6 downto 0)   => segm_0,
													  FourDigitDisplay_segm(13 downto 7)  => segm_1,
													  FourDigitDisplay_segm(20 downto 14) => segm_2,
													  FourDigitDisplay_segm(27 downto 21) => segm_3);	
end rtl;

