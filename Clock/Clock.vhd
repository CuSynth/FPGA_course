library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.Math_PACK.all;
--use work.bcd_7seg.all;

entity Clock is
	port 
	(
		clk 	: in std_logic;
		segm_0	: out std_logic_vector(6 downto 0)
	);
end entity;



architecture rtl of Clock is
	constant CLOCK_PRESCALER 	: natural := 50000000;
	signal 	 presc_reg			: std_logic_vector(f_log2(CLOCK_PRESCALER)-1 downto 0);

	signal  segm_0_in			: std_logic_vector(3 downto 0);
	signal  segm_0_out			: std_logic_vector(6 downto 0);
	signal  segm_0_cntr			: std_logic_vector(3 downto 0);

	component bcd_7seg is
		port (
			bin		:	in  std_logic_vector(3 downto 0);
			segm	:	out std_logic_vector(6 downto 0)
		);
	end component;
	
begin
	process (clk)
	begin
	if (rising_edge(clk)) then
		presc_reg <= presc_reg + '1';		
		if (presc_reg >= CLOCK_PRESCALER) then
			presc_reg <= (others => '0');

			segm_0_cntr <= segm_0_cntr+'1';
			if (segm_0_cntr >= 10) then
				segm_0_cntr <= (others => '0');
			end if;
		end if;
		

		
	end if;
	end process;
	
	segm_0_in <= segm_0_cntr;
	u1: bcd_7seg port map(bin => segm_0_in, segm => segm_0_out);
	segm_0 <= segm_0_out;
	
	
end rtl;

