library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity UART_example is
	generic (
		constant Data_Width			: natural := 8; 	-- Data width
		constant system_clk_freq	: natural := 100; 	-- 100MHz
		constant Bit_Rate		 	: natural := 1	-- 1MHz
	);
	port 
	(
		clk 			: in  std_logic;
		Input_Data_Line : in  std_logic;
		IRQ				: out std_logic;
		Output_Data_Bus	: out std_logic_vector(Data_Width-1 downto 0)
	);
end entity;



architecture rtl of UART_example is
	signal system_clk 	: std_logic;
	signal dat			: std_logic_vector(Data_Width-1 downto 0);
	
	--------------------------------------


	component Main_PLL is
	port
	(
		inclk0		: in std_logic;
		c0			: out std_logic 
	);
	end component;
	
	component UART is
	generic (
		constant Word_Width			: natural;
		constant System_Clock_Speed	: natural;
		constant Bit_Rate_value		: natural
	);
	port
	(
		clk_i 	: in std_logic;
		data_i	: in std_logic;
		IRQ_o	: out std_logic;
		data_o	: out std_logic_vector(Data_Width-1 downto 0)
	);
	end component;


begin
	PLL_map: Main_PLL 
		port map 
		(
			inclk0 => clk,
			c0 => system_clk
		); 

		
	UART_map: UART
		generic map (
			Word_Width 			=> Data_Width,
			System_Clock_Speed 	=> system_clk_freq,
			Bit_Rate_Value		=> Bit_Rate 
			
		)
		port map 
		(
			clk_i	=> system_clk,
			data_i	=> Input_Data_Line,
			IRQ_o	=> IRQ,
			data_o	=> dat
		); 
	

	--------------------------------------	
	
	Output_Data_Bus <= dat;

end rtl;