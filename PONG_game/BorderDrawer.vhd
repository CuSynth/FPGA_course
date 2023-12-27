LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity BorderDrawer is
	generic (
		constant ColorDepth : natural;
		constant R_color	: natural;
		constant G_color	: natural;
		constant B_color	: natural;

		constant Up 		: natural;
		constant Dwn 		: natural;
		constant Lft 		: natural;
		constant Rght 		: natural
	);	

	port(
		clk_i	: in std_logic;

		Cur_x	: in std_logic_vector(9 downto 0);
		Cur_y	: in std_logic_vector(9 downto 0);		
		
		R_o 	: out std_logic_vector(ColorDepth-1 downto 0);
		G_o 	: out std_logic_vector(ColorDepth-1 downto 0);
		B_o 	: out std_logic_vector(ColorDepth-1 downto 0)
	);
end BorderDrawer;




architecture Behavioral of BorderDrawer is
	signal Pixel_ON 	: std_logic;
	
	signal Color_R_s 	: std_logic_vector(ColorDepth-1 downto 0) := std_logic_vector(to_unsigned(R_color, ColorDepth));
	signal Color_G_s 	: std_logic_vector(ColorDepth-1 downto 0) := std_logic_vector(to_unsigned(R_color, ColorDepth));
	signal Color_B_s    : std_logic_vector(ColorDepth-1 downto 0) := std_logic_vector(to_unsigned(R_color, ColorDepth));
begin

	draw : process (clk_i)
	begin

		if ( ((Cur_y = Up or Cur_y = Dwn) and (Cur_x >= Lft and  Cur_x <= Rght))
				or ((Cur_x = Lft or Cur_x = Rght) and (Cur_y >= Up and  Cur_y <= Dwn)))
		then
			Pixel_ON <= '1';
		else
			Pixel_ON <= '0';
		end if;
	end process draw;

		
	DAC_out : for i in 0 to (ColorDepth-1) generate
		R_o(i)		<=	Color_R_s(i) and Pixel_ON;
		G_o(i)		<=	Color_G_s(i) and Pixel_ON; 
		B_o(i)		<=	Color_B_s(i) and Pixel_ON;
	end generate;
		
end Behavioral;