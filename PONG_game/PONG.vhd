LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PONG is

generic (
	VGA_Color_Depth : natural := 4
);

port (   
		clk_i		: in std_logic;
		
	--- Control ---
		up_btn		: in std_logic;
		dn_btn		: in std_logic;
		
	--- Debug ---
		up_LED		: out std_logic;
		dn_LED		: out std_logic;
	
	--- VGA ---
		Hsync_o     : out std_logic;
		Vsync_o		: out std_logic; 
		R_o 		: out std_logic_vector(VGA_Color_Depth-1 downto 0);
		G_o 		: out std_logic_vector(VGA_Color_Depth-1 downto 0);
		B_o 		: out std_logic_vector(VGA_Color_Depth-1 downto 0)
	);
end  PONG;




architecture rtl of PONG is
	--------------------------- Components ---------------------------

	--- PLL 100MHz ---
	component VGA_PLL
	port (
		inclk0		: in std_logic := '0';
		c0			: out std_logic
	);
	end component;

	--- VGA ---
	COMPONENT VGA_Synchro 
	GENERIC ( 
		Display_Mode : INTEGER := 640; 
		Refrence_Clock_Speed : INTEGER := 25 
	);
	PORT (
		clock			:	 in std_logic;
		X_Coordinate	:	 out std_logic_vector(9 DOWNTO 0);
		Y_Coordinate	:	 out std_logic_vector(9 DOWNTO 0);
		vga_h_sync		:	 out std_logic;
		vga_v_sync		:	 out std_logic;
		End_of_Frame	:	 out std_logic
	);
	END COMPONENT;

	--------------------------- Signals ---------------------------
		
	--- VGA ---
	signal End_of_Frame_s : std_logic;
	signal Color_R_s      : std_logic_vector(3 downto 0);
	signal Color_G_s      : std_logic_vector(3 downto 0);
	signal Color_B_s      : std_logic_vector(3 downto 0);
	
	signal Pixel_ON       : std_logic;
	signal Pixel_ON_Trg_s : std_logic;
	signal X_Coord        : std_logic_vector(9 downto 0);
	signal Y_Coord        : std_logic_vector(9 downto 0);

	--- Common ---
	signal Global_Clock	: std_logic;
	
	
begin
	--------------------------- Mapping ---------------------------
	
	--- PLL ---
    PLL: VGA_PLL
	port map(
		inclk0	=> clk_i,
		c0  	=> Global_Clock
	);
	
	--- VGA ---
	VGA_ctrl_inst: VGA_Synchro
	generic map (
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

	--------------------------- Logic ---------------------------

	sq: process(Global_Clock)
	begin
		if((X_Coord > 15 and X_Coord < 25) and (Y_Coord > 15 and Y_Coord < 25))
		then
			Pixel_ON <= '1';
		else 
			Pixel_ON <= '0';
		end if;
	end process sq;

	Color_R_s <= std_logic_vector(to_unsigned(0, 4));
	Color_G_s <= std_logic_vector(to_unsigned(15, 4));
	Color_B_s <= std_logic_vector(to_unsigned(15, 4));

	DAC_out : for i in 0 to 3 generate
		R_o(i)		<=	Color_R_s(i) and Pixel_ON;
		G_o(i)		<=	Color_G_s(i) and Pixel_ON; 
		B_o(i)		<=	Color_B_s(i) and Pixel_ON;
	end generate DAC_out;

	dn_LED <= dn_btn;		
	up_LED <= up_btn;
end rtl;