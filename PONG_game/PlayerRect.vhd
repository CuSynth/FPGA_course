LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity PlayerRect is
	generic (
		constant ColorDepth : natural;
		constant R_color	: natural;
		constant G_color	: natural;
		constant B_color	: natural;

		constant MaxSpeed   : natural;
		
		constant wdth   	: natural;
		constant depth   	: natural;

		constant Pos_x   	: natural
		
	);	

	port(
		clk_i	: in std_logic;

		EOF		: in std_logic;
		Cur_x	: in std_logic_vector(9 downto 0);
		Cur_y	: in std_logic_vector(9 downto 0);		
		
		btn_up	: in std_logic;
		btn_dn	: in std_logic;

		R_o 	: out std_logic_vector(ColorDepth-1 downto 0);
		G_o 	: out std_logic_vector(ColorDepth-1 downto 0);
		B_o 	: out std_logic_vector(ColorDepth-1 downto 0)
	);
end PlayerRect;




architecture Behavioral of PlayerRect is
	signal Pixel_ON 	: std_logic;
	
	signal Color_R_s 	: std_logic_vector(ColorDepth-1 downto 0) := std_logic_vector(to_unsigned(R_color, ColorDepth));
	signal Color_G_s 	: std_logic_vector(ColorDepth-1 downto 0) := std_logic_vector(to_unsigned(G_color, ColorDepth));
	signal Color_B_s    : std_logic_vector(ColorDepth-1 downto 0) := std_logic_vector(to_unsigned(B_color, ColorDepth));

	signal speed 		: integer range -MaxSpeed to MaxSpeed;
	
	signal LU_x 		: integer range 0 to 640 := Pos_x;
	signal LU_y 		: integer range 0 to 480 := 230;

	signal counter		: std_logic_vector(4 downto 0);
	
begin

	draw : process (clk_i)
	begin
	
	if (Cur_x >= LU_x and Cur_x <= LU_x+depth and Cur_y >= LU_y and Cur_y <= LU_y+wdth)
	then
		Pixel_ON<='1';
	else
		Pixel_ON<='0';
	end if;	

	end process draw;

		
	DAC_out : for i in 0 to (ColorDepth-1) generate
		R_o(i)		<=	Color_R_s(i) and Pixel_ON;
		G_o(i)		<=	Color_G_s(i) and Pixel_ON; 
		B_o(i)		<=	Color_B_s(i) and Pixel_ON;
	end generate;
		
end Behavioral;