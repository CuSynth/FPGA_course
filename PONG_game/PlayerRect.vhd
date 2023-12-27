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

		constant Speed   	: natural;
		constant MinY		: natural;
		constant MaxY		: natural;
		
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

	signal CurSpeed 	: integer range -Speed to Speed;
	
	signal LU_x 		: integer range 0 to 640 := Pos_x;
	signal LU_y 		: integer range 0 to 480 := 230;
		
begin
	btn_process : process (clk_i)
	begin
		if(rising_edge(clk_i))
		then
			if(EOF = '1')
			then
				if(btn_up = '1')
				then

					CurSpeed <= Speed;
				elsif (btn_dn = '1')
				then
					CurSpeed <= -1*Speed;
				else
					CurSpeed <= 0;			
				end if;
			end if;
		end if;	
	end process btn_process;
	
	move : process (clk_i)
	begin
		if(rising_edge(clk_i))
		then
			if(EOF = '1')
			then
				if(LU_y+CurSpeed >= MinY and LU_y+CurSpeed+wdth <= MaxY)
				then
					LU_y <= LU_y+CurSpeed;
				end if;
				
			end if;
		end if;	
	end process move;




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