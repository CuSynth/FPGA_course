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
	
	COMPONENT VGA_Synchro GENERIC ( Display_Mode : INTEGER := 640; Refrence_Clock_Speed : INTEGER := 25 );
		PORT
		(
			clock			:	 IN STD_LOGIC;
			X_Coordinate	:	 OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			Y_Coordinate	:	 OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			vga_h_sync		:	 OUT STD_LOGIC;
			vga_v_sync		:	 OUT STD_LOGIC;
			End_of_Frame	:	 OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT PLL_VGA
		PORT
		(
			inclk0		: IN STD_LOGIC  := '0';
			c0			: OUT STD_LOGIC 
		);
	end component;
	signal Global_Clock   : STD_LOGIC;

begin
	
	----------------------------------------- PLL ------------------------------------------
    PLL: PLL_VGA
		port map(
					inclk0	=> clk_i,
					c0  	=> Global_Clock
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

	---------------------------------------- logic ----------------------------------------
	draw_line : process (Global_Clock) 
	begin
		if (rising_edge(Global_Clock)) then 
			if (((X_Coord > 100 and X_Coord < 200) and (Y_Coord = 199 or Y_Coord = 101))
					or((Y_Coord > 100 and Y_Coord < 200) and (X_Coord = 199 or X_Coord = 101))) then 
					Pixel_ON <= '1';
																   else
					Pixel_ON <= '0';
			end if;
		end if;
	end process draw_line;
	
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