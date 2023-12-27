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

	----- PLL 100MHz -----
	component VGA_PLL
	port (
		inclk0		: in std_logic := '0';
		c0			: out std_logic
	);
	end component;

	----- VGA -----
	component VGA_Synchro 
	generic ( 
		Display_Mode 			: integer := 640; 
		Refrence_Clock_Speed	: integer := 25 
	);
	port (
		clock			:	 in std_logic;
		X_Coordinate	:	 out std_logic_vector(9 DOWNTO 0);
		Y_Coordinate	:	 out std_logic_vector(9 DOWNTO 0);
		vga_h_sync		:	 out std_logic;
		vga_v_sync		:	 out std_logic;
		End_of_Frame	:	 out std_logic
	);
	end component;

	----- Border -----
	component BorderDrawer
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
	end component;
	----- Player -----
	component PlayerRect
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

	end component;


	--------------------------- Signals ---------------------------
		
	----- VGA -----
	signal End_of_Frame_s 	: std_logic;

	signal X_Coord        	: std_logic_vector(9 downto 0);
	signal Y_Coord        	: std_logic_vector(9 downto 0);

	----- Connections -----
	signal Border_R_s      	: std_logic_vector(3 downto 0);
	signal Border_G_s      	: std_logic_vector(3 downto 0);
	signal Border_B_s      	: std_logic_vector(3 downto 0);
	
	signal Player_R_s      	: std_logic_vector(3 downto 0);
	signal Player_G_s      	: std_logic_vector(3 downto 0);
	signal Player_B_s      	: std_logic_vector(3 downto 0);

	----- Common -----
	signal Global_Clock		: std_logic;
	
	
	
	
	
begin
	--------------------------- Mapping ---------------------------
	
	----- PLL -----
    PLL: VGA_PLL
	port map(
		inclk0	=> clk_i,
		c0  	=> Global_Clock
	);
	
	----- VGA -----
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
	
	----- Border -----
	Border_inst: BorderDrawer
	generic map (
	
		ColorDepth => VGA_Color_Depth,
		R_color	=> 15,
		G_color	=> 15,
		B_color	=> 15,

		Lft => 10,
		Rght => 630,
		
		Up => 10,
		Dwn => 470
	)
	port map(
		clk_i => Global_Clock,

		Cur_x => X_Coord,
		Cur_y => Y_Coord,	
		
		R_o => Border_R_s,
		G_o => Border_G_s,
		B_o => Border_B_s
	);


	----- PlayerRect -----
	PlayerRect_inst : PlayerRect
	generic map (
		ColorDepth => VGA_Color_Depth,
		R_color	=> 15,
		G_color	=> 8,
		B_color	=> 10,

		Speed => 3,
		MinY => 15,
		MaxY => 465,
		
		wdth => 25,
		depth => 3,

		Pos_x => 620
	)
	port map(
		clk_i => Global_Clock,

		EOF => End_of_Frame_s,
		Cur_x => X_Coord,
		Cur_y => Y_Coord,	
		
		btn_up => up_btn,
		btn_dn => dn_btn,

		R_o => Player_R_s,
		G_o => Player_G_s,
		B_o => Player_B_s
	);


	--------------------------- Logic ---------------------------

	R_o <= Border_R_s or Player_R_s;
	G_o <= Border_G_s or Player_G_s;
	B_o <= Border_B_s or Player_B_s;
	
	dn_LED <= dn_btn;		
	up_LED <= up_btn;
end rtl;