LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity PosControl is
	generic (
		carriage_w 	: natural;
		carriage_h 	: natural;
		
		ball_w  	: natural;
		ball_h		: natural;
		
		brd_L		: natural;
		brd_R		: natural;
		brd_U		: natural;
		brd_D		: natural
	);
	port(
		clk_i	: in std_logic;

		EOF		: in std_logic;

		Carr_X 	: in integer range 0 to 640;
		Carr_Y	: in integer range 0 to 480;
		Carr_V	: in integer range -10 to 10;
		
		Ball_X_o	: out integer range 0 to 640;
		Ball_Y_o	: out integer range 0 to 480;
		
		
		Fall	: out std_logic;
		Touch	: out std_logic
	);
end PosControl;


architecture Behavioral of PosControl is
	signal V_x : integer range -20 to 20 := 5;
	signal V_y : integer range -20 to 20 := -1;
	
	signal movement_reg : integer range 0 to 100;
	
	signal Ball_X	: integer range 0 to 640 := 300;
	signal Ball_Y	: integer range 0 to 480 := 200;
begin

		
	movement: process (clk_i)
	begin
		if(rising_edge(clk_i)) then
			if(EOF = '1')
			then
				movement_reg <= movement_reg+1;
			end if;
			
			if(movement_reg >= 3) then
				movement_reg <= 0;

				Ball_X <= Ball_X +  V_x;
				if((V_x > 0 and Ball_X+V_x+ball_w >= brd_R) or
					(V_x < 0 and Ball_X+V_x <= brd_L))
				then 
					V_x <= -1*V_x;
				end if;

				Ball_Y <= Ball_Y +  V_y;
				if((V_y > 0 and Ball_Y+V_y+ball_h >= brd_D) or
					(V_y < 0 and Ball_Y <= brd_U))
				then 
					V_y <= -1*V_y;
				end if;
			end if;			
		end if;
	end process movement;		
		
	Ball_X_o <= Ball_X;
	Ball_Y_o <= Ball_Y;
		
end Behavioral;