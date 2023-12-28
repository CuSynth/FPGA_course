library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.all;

entity FourDigitDisplay is
	port(
		clk		:   in  std_logic;
		bcd_i		:	in std_logic_vector(15 downto 0);
		segm_o		: 	out std_logic_vector(27 downto 0)

	);
end FourDigitDisplay;

architecture Structural of FourDigitDisplay is 
	component bcd_7seg is
		port (
			clk		:   in  std_logic;
			bin_i	:	in  std_logic_vector(3 downto 0);
			segm_o	:	out std_logic_vector(6 downto 0)
		);
	end component;
	
begin
	Display0: bcd_7seg port map(clk=>clk, bin_i => bcd_i(3 downto 0),   segm_o => segm_o(6 downto 0));
    Display1: bcd_7seg port map(clk=>clk, bin_i => bcd_i(7 downto 4),   segm_o => segm_o(13 downto 7));
    Display2: bcd_7seg port map(clk=>clk, bin_i => bcd_i(11 downto 8),  segm_o => segm_o(20 downto 14));
    Display3: bcd_7seg port map(clk=>clk, bin_i => bcd_i(15 downto 12), segm_o => segm_o(27 downto 21));
end Structural;
