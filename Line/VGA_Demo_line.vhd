-- VGA_Demo_line

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.Math_PACK.all;


ENTITY VGA_Demo_line IS
PORT(   
		clk_i		: in STD_LOGIC;
		
		Hsync_o     : out STD_LOGIC;
		Vsync_o		: out STD_LOGIC; 
		R_o 		: out STD_LOGIC_VECTOR(VGA_Color_Depth-1 downto 0);
		G_o 		: out STD_LOGIC_VECTOR(VGA_Color_Depth-1 downto 0);
		B_o 		: out STD_LOGIC_VECTOR(VGA_Color_Depth-1 downto 0)
	);
end  VGA_Demo_line;

ARCHITECTURE rtl of  VGA_Demo_line IS
	signal End_of_Frame_s : STD_LOGIC;
	signal Color_R_s      : STD_LOGIC_VECTOR(3 downto 0);
	signal Color_G_s      : STD_LOGIC_VECTOR(3 downto 0);
	signal Color_B_s      : STD_LOGIC_VECTOR(3 downto 0);
	
	signal Pixel_ON       : STD_LOGIC;
	signal Pixel_ON_Trg_s : STD_LOGIC;
	signal X_Coord        : STD_LOGIC_VECTOR(9 downto 0);
	signal Y_Coord        : STD_LOGIC_VECTOR(9 downto 0);

	----------------------------------------------------------------------------------------
	-- pic:
		
	signal SpritePixelCnt : STD_LOGIC_VECTOR(9 downto 0):="0000000000";	--RAM_cnt_s,
    signal SpritePixel : STD_LOGIC_VECTOR(7 downto 0);	-- RAM_data_s
    signal SpritePixelCntEn : STD_LOGIC;
	signal pic_num 		  : integer range 0 to 3 := 0;

	----------------------------------------------------------------------------------------
    

	signal Global_Clock   : STD_LOGIC;

	
	signal RAM_data_s	  : STD_LOGIC_VECTOR(7 downto 0);
	signal RAM_cnt_s	  : std_logic_vector(9 downto 0);
	signal RAM_cnt_en	  : std_logic;
	
	signal LU_x 		  : integer range -40 to 700 := 10;
	signal LU_y 		  : integer range -40 to 700 := 10;

	constant picture_w 	  : integer range 0 to 100 := 32;
	constant picture_h 	  : integer range 0 to 100 := 32;	

	signal V_x	  		  : integer range -10 to 10 := 3;	
	signal V_y 		  	  : integer range -10 to 10 := 2;


	signal movement_reg   : integer range 0 to 100;
	signal anim_reg   : integer range 0 to 100;
	
	----------------------------------------------------------------------------------------

	COMPONENT VGA_Synchro 
	GENERIC ( 
		Display_Mode : INTEGER := 640; 
		Refrence_Clock_Speed : INTEGER := 25 
	);
	PORT (
		clock			:	 IN STD_LOGIC;
		X_Coordinate	:	 OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		Y_Coordinate	:	 OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		vga_h_sync		:	 OUT STD_LOGIC;
		vga_v_sync		:	 OUT STD_LOGIC;
		End_of_Frame	:	 OUT STD_LOGIC
	);
	END COMPONENT;
	
	COMPONENT PIC_32x32_8bit
	PORT (
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT PLL_VGA
	PORT (
		inclk0		: IN STD_LOGIC  := '0';
		c0			: OUT STD_LOGIC 
	);
	end component;

begin
		
	----------------------------------------- PLL ------------------------------------------
    PLL: PLL_VGA
		port map(
					inclk0	=> clk_i,
					c0  	=> Global_Clock
				);
	----------------------------------------- RAM ------------------------------------------
	RAM1024_inst : PIC_32x32_8bit PORT MAP (
		address	 => SpritePixelCnt,	 
		clock	 => Global_Clock,
		data	 => (others => '0'),
		wren	 => '0',
		q	 	 => SpritePixel
	);
	------------------------------------- VGA controller -----------------------------------
    VGA_ctrl_inst: VGA_Synchro
		generic map
		(
			Display_Mode => 640,
			Refrence_Clock_Speed => 25
		)
		port map(
					clock			=> Global_Clock,
					X_Coordinate	=> X_Coord,
					Y_Coordinate	=> Y_Coord,
					vga_h_sync		=> Hsync_o,
					vga_v_sync		=> Vsync_o,
					End_of_Frame	=> End_of_Frame_s
				);

	----------------------------------- Picture area logic -----------------------------------
	draw_pic : process (Global_Clock) 	begin
		if (rising_edge(Global_Clock)) then 
			if (SpritePixelCntEn='1') then
				SpritePixelCnt<=SpritePixelCnt+'1';
			end if;
			if (End_of_Frame_s='1') then
				SpritePixelCnt<=(others=>'0');
			end if;
		end if;

		if (X_Coord>LU_x and X_Coord<=(LU_x+picture_w) and Y_Coord>LU_y and Y_Coord<=(LU_y+picture_h)) then
			Pixel_On<=SpritePixel(pic_num);
		else
			Pixel_On<='0';
		end if;
		
		if ((X_Coord>LU_x-1 and X_Coord<(LU_x+picture_w-1) and Y_Coord=LU_y+1) or
			(X_Coord>=LU_x-1 and X_Coord<(LU_x+picture_w-1) and Y_Coord>LU_y and Y_Coord<(LU_y+picture_h+1)) 
			
			) then
			SpritePixelCntEn<='1';
		else
			SpritePixelCntEn<='0';
		end if;

	end process draw_pic;

	----------------------------------- Movement logic -----------------------------------
	movement: process (Global_Clock)
	begin
		if(rising_edge(Global_Clock)) then
			if(End_of_Frame_s = '1')
			then
				movement_reg <= movement_reg+1;
			end if;
			
			if(movement_reg >= 3) then
				movement_reg <= 0;

				LU_x <= LU_x +  V_x;
				if((V_x > 0 and LU_x+V_x+picture_w >= 639) or
					(V_x < 0 and LU_x <= 5))
				then 
					V_x <= -1*V_x;
				end if;

				LU_y <= LU_y +  V_y;
				if((V_y > 0 and LU_y+V_y+picture_h >= 478) or
					(V_y < 0 and LU_y <= 2))
				then 
					V_y <= -1*V_y;
				end if;
			end if;			
		end if;
	end process movement;
	
	anim: process (Global_Clock)
	begin
		if(rising_edge(Global_Clock)) then
			if(End_of_Frame_s = '1')
			then
				anim_reg <= anim_reg+1;
			end if;
			
			if(anim_reg >= 6) then
				anim_reg <= 0;

				pic_num <= pic_num+1;
				if(pic_num>=2) then
					pic_num <= 0;
				end if;
					
			end if;			
		end if;
	end process anim;
	
	
	-- set line color 
	Color_R_s <= std_logic_vector(to_unsigned(0, 4));
	Color_G_s <= std_logic_vector(to_unsigned(15, 4));
	Color_B_s <= std_logic_vector(to_unsigned(15, 4));
	
	DAC_out : for i in 0 to 3 generate
		R_o(i)		<=	Color_R_s(i) and Pixel_ON;
		G_o(i)		<=	Color_G_s(i) and Pixel_ON; 
		B_o(i)		<=	Color_B_s(i) and Pixel_ON;
	end generate DAC_out;
	
END rtl;