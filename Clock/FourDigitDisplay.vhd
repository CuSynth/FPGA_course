library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.all;

entity FourDigitDisplay is
	port(
		FourDigitDisplay_bcd	:	in std_logic_vector(15 downto 0);
		FourDigitDisplay_segm	: 	out std_logic_vector(27 downto 0)

	);
end FourDigitDisplay;

architecture Structural of FourDigitDisplay is 
	component bcd_7seg is
		port (
			bin		:	in  std_logic_vector(3 downto 0);
			segm	:	out std_logic_vector(6 downto 0)
		);
	end component;
	
begin
	Display0: bcd_7seg port map(bin => FourDigitDisplay_bcd(3 downto 0), segm => FourDigitDisplay_segm(6 downto 0));
    Display1: bcd_7seg port map(bin => FourDigitDisplay_bcd(7 downto 4), segm => FourDigitDisplay_segm(13 downto 7));
    Display2: bcd_7seg port map(bin => FourDigitDisplay_bcd(11 downto 8), segm => FourDigitDisplay_segm(20 downto 14));
    Display3: bcd_7seg port map(bin => FourDigitDisplay_bcd(15 downto 12), segm => FourDigitDisplay_segm(27 downto 21));
end Structural;
