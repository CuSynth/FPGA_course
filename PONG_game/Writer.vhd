LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Writer is
	generic (
		constant ColorDepth : natural;
		constant R_color	: natural;
		constant G_color	: natural;
		constant B_color	: natural;

		constant PosX		: natural;
		constant PosY		: natural
		);	

	port(
		clk_i	: in std_logic;

		EOF		: in std_logic;
		Cur_x	: in std_logic_vector(9 downto 0);
		Cur_y	: in std_logic_vector(9 downto 0);		
		
		to_show : in natural;


		R_o 	: out std_logic_vector(ColorDepth-1 downto 0);
		G_o 	: out std_logic_vector(ColorDepth-1 downto 0);
		B_o 	: out std_logic_vector(ColorDepth-1 downto 0)
	);
end Writer;




architecture Behavioral of Writer is
	component Font_mem
	port (
		address		: in std_logic_vector (7 downto 0);
		clock		: in std_logic;
		data		: in std_logic_vector(15 downto 0);
		wren		: in std_logic;
		q			: out std_logic_vector(15 downto 0)
	);
	end component;
		
	signal Pixel_ON 	: std_logic;
	
	signal Color_R_s 	: std_logic_vector(ColorDepth-1 downto 0) := std_logic_vector(to_unsigned(R_color, ColorDepth));
	signal Color_G_s 	: std_logic_vector(ColorDepth-1 downto 0) := std_logic_vector(to_unsigned(G_color, ColorDepth));
	signal Color_B_s    : std_logic_vector(ColorDepth-1 downto 0) := std_logic_vector(to_unsigned(B_color, ColorDepth));
	
	
	signal SpritePixelCnt 	: std_logic_vector(7 downto 0);	
    signal SpritePixel 		: std_logic_vector(15 downto 0);
    signal SpritePixelCntEn : std_logic;
		
begin
	RAM_inst : Font_mem PORT MAP (
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

		if (Cur_X>PosX and Cur_X<=(PosX+16) and Cur_Y>PosY and Cur_Y<=(PosY+16)) then
			Pixel_On<=SpritePixel(to_show);
		else
			Pixel_On<='0';
		end if;
		
		if ((Cur_X>PosX-1 and Cur_X<(PosX+16-1) and Cur_Y=PosY+1) or
			(Cur_X>=PosX-1 and Cur_X<(PosX+16-1) and Cur_Y>PosY and Cur_Y<(PosY+16+1)) 
			
			) then
			SpritePixelCntEn<='1';
		else
			SpritePixelCntEn<='0';
		end if;
	end process draw;

		
	DAC_out : for i in 0 to (ColorDepth-1) generate
		R_o(i)		<=	Color_R_s(i) and Pixel_ON;
		G_o(i)		<=	Color_G_s(i) and Pixel_ON; 
		B_o(i)		<=	Color_B_s(i) and Pixel_ON;
	end generate;
		
end Behavioral;