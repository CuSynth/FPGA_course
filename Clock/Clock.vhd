library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.Math_PACK.all;


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
	constant CLOCK_PRESCALER 	: natural := (50000000);
	signal 	 presc_reg			: std_logic_vector(f_log2(CLOCK_PRESCALER)-1 downto 0);
	
	signal	 sec_clk			: std_logic := '0';
	signal   min_presc			: integer range 0 to 60 := 0;
	signal	 min_clk			: std_logic := '0';
	
	signal	 cur_time			: std_logic_vector(15 downto 0);
	
	component FourDigitDisplay is
		port (
			FourDigitDisplay_bcd	:	in std_logic_vector(15 downto 0);
			FourDigitDisplay_segm	: 	out std_logic_vector(27 downto 0)
		);
	end component; -- FourDigitDisplay
	
	component ClockCore is
		port (
			ClockCore_clk			:	in  std_logic;
			ClockCore_time_o		:	out std_logic_vector(15 downto 0)
		);
	end component; -- FourDigitDisplay
	
	
begin
	process (clk)
	begin
	if (rising_edge(clk)) then
		presc_reg <= presc_reg + '1';		
		if (presc_reg >= CLOCK_PRESCALER) then
			presc_reg <= (others => '0');
			sec_clk <= '1';
			
			min_presc <= min_presc + 1;
			if(min_presc = 59) then
				min_presc <= 0;
				min_clk <= '1';
			else
				min_clk <= '0';
			end if; -- min_presc = 59
		else
			sec_clk <= '0';
		end if; -- presc_reg >= CLOCK_PRESCALER
	end if; -- rising_edge(clk)
	end process;
	
	FourDigitDisplay_map : FourDigitDisplay port map (FourDigitDisplay_bcd => cur_time,
													  FourDigitDisplay_segm(6 downto 0)   => segm_0,
													  FourDigitDisplay_segm(13 downto 7)  => segm_1,
													  FourDigitDisplay_segm(20 downto 14) => segm_2,
													  FourDigitDisplay_segm(27 downto 21) => segm_3);
	
	ClockCore_map : ClockCore port map (ClockCore_clk    => min_clk,
										ClockCore_time_o => cur_time);
	
	
--	segm_0_in <= segm_0_cntr;
--	u1: bcd_7seg port map(bin => segm_0_in, segm => segm_0_out);
--	segm_0 <= segm_0_out;
	
	
end rtl;

