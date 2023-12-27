LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Ball is
	generic (
		constant ColorDepth : natural;
		constant R_color	: natural;
		constant G_color	: natural;
		constant B_color	: natural
		);	

	port(
		clk_i	: in std_logic;

		EOF		: in std_logic;
		Cur_x	: in std_logic_vector(9 downto 0);
		Cur_y	: in std_logic_vector(9 downto 0);		
		
		PosX	: in natural;
		PosY	: in natural;
		
		R_o 	: out std_logic_vector(ColorDepth-1 downto 0);
		G_o 	: out std_logic_vector(ColorDepth-1 downto 0);
		B_o 	: out std_logic_vector(ColorDepth-1 downto 0)
	);
end Ball;


architecture Behavioral of Ball is
	component Ball_sprite_mem
	port (
		address		: in std_logic_vector (9 downto 0);
		clock		: in std_logic;
		data		: in std_logic_vector(7 downto 0);
		wren		: in std_logic;
		q			: out std_logic_vector(7 downto 0)
	);
	end component;
		
	signal Pixel_ON 	: std_logic;
	
	signal Color_R_s 	: std_logic_vector(ColorDepth-1 downto 0) := std_logic_vector(to_unsigned(R_color, ColorDepth));
	signal Color_G_s 	: std_logic_vector(ColorDepth-1 downto 0) := std_logic_vector(to_unsigned(G_color, ColorDepth));
	signal Color_B_s    : std_logic_vector(ColorDepth-1 downto 0) := std_logic_vector(to_unsigned(B_color, ColorDepth));
	
	
	signal SpritePixelCnt 	: std_logic_vector(9 downto 0);	
    signal SpritePixel 		: std_logic_vector(7 downto 0);
    signal SpritePixelCntEn : std_logic;
		
	signal anim_reg   	  : integer range 0 to 100;
	signal pic_num 		  : integer range 0 to 6 := 0;

		
begin
	RAM_inst : Ball_sprite_mem port map (
		address	 => SpritePixelCnt,	 
		clock	 => clk_i,
		data	 => (others => '0'),
		wren	 => '0',
		q	 	 => SpritePixel
	);


	draw : process (clk_i) 	begin
		if (rising_edge(clk_i)) then 
			if (SpritePixelCntEn='1') then
				SpritePixelCnt<=SpritePixelCnt+'1';
			end if;
			if (EOF='1') then
				SpritePixelCnt<=(others=>'0');
			end if;
		end if;
		--- todo: refactor: use picture_width/picture_height
		if (Cur_X>PosX and Cur_X<=(PosX+32) and Cur_Y>PosY and Cur_Y<=(PosY+32)) then
			Pixel_On<=SpritePixel(5-pic_num);
		else
			Pixel_On<='0';
		end if;
		
		if ((Cur_X>PosX-1 and Cur_X<(PosX+32-1) and Cur_Y=PosY+1) or
			(Cur_X>=PosX-1 and Cur_X<(PosX+32-1) and Cur_Y>PosY and Cur_Y<(PosY+32+1)) 
			
			) then
			SpritePixelCntEn<='1';
		else
			SpritePixelCntEn<='0';
		end if;
	end process draw;

	animation: process (clk_i)
	begin
		if(rising_edge(clk_i)) then
			if(EOF = '1')
			then
				anim_reg <= anim_reg+1;
			end if;
			
			if(anim_reg >= 7) then
				anim_reg <= 0;

				pic_num <= pic_num+1;
				if(pic_num>=5) then
					pic_num <= 0;
				end if;
					
			end if;			
		end if;
	end process animation;
		
		
	DAC_out : for i in 0 to (ColorDepth-1) generate
		R_o(i)		<=	Color_R_s(i) and Pixel_ON;
		G_o(i)		<=	Color_G_s(i) and Pixel_ON; 
		B_o(i)		<=	Color_B_s(i) and Pixel_ON;
	end generate;
		
end Behavioral;