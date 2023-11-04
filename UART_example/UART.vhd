library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--use work.Math_PACK.all;

entity UART is
	generic (
		constant Word_Width			: natural; 	-- Data width
		constant System_Clock_Speed	: natural; 	-- 100MHz
		constant Bit_Rate_value		: natural 	-- 1MHz
	);	
	port 
	(
		clk_i 	: in std_logic;
		data_i	: in std_logic;
		IRQ_o	: out std_logic;
		data_o	: out std_logic_vector(Word_Width-1 downto 0)
	);
end entity;


architecture Behavioral of UART is
	
	constant Oversampling_Ratio : natural := 4;		-- UART clk will be 4*Bit_Rate_Value (use Nyquist-Shannon theorem)
	
	constant Nyquist_Sampling_Speed 			: natural := Bit_Rate_Value*Oversampling_Ratio; 
	constant System_to_Nyquist_Prescaler_Module : natural := System_Clock_Speed/Nyquist_Sampling_Speed;
	-- start bit + data + parity bit + stop bit => Word_Width+3
	constant Bit_Number_to_be_Processed			: natural := Word_Width+3;
	constant Relative_Phase 					: natural := Oversampling_Ratio/2;	-- To determine the middle of start bit
--	constant Sample_Number_Counter_Size 		: natural := f_log2(Bit_Number_to_be_Processed*Oversampling_Ratio);
	
	signal sampling_clk : std_logic;
	
	
	
	component Prescalers is
	generic
	(
		constant sys_clock	: natural; 	
		constant req_clock	: natural
	);
	port
	(
		clk_i	 :	in std_logic;
		clk_o	 :	out std_logic
	);
	end component;
begin 

	presc_map: Prescalers
		generic map (
			sys_clock => System_Clock_Speed,
			req_clock => Nyquist_Sampling_Speed
			
		)
		port map 
		(
			clk_i => clk_i,
			clk_o => sampling_clk
		); 
		
		
end Behavioral;