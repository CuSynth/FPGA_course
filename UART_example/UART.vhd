library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

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
	
	constant Oversampling_Ratio 	: natural := 4;		-- UART clk will be 4*Bit_Rate_Value (use Nyquist-Shannon theorem)
	constant Relative_Phase 		: natural := (Oversampling_Ratio)/2-1;	-- To determine the middle of start bit
	constant Nyquist_Sampling_Speed	: natural := Bit_Rate_Value*Oversampling_Ratio; 
	-- start bit + data + parity bit + stop bit => Word_Width+3
	constant pack_len				: natural := Word_Width+3;
	
	signal edge_sensing_reg		: std_logic_vector(1 downto 0);


	signal latch				: std_logic := '0';
	signal shift				: std_logic := '0';
	signal IRQ					: std_logic := '0';
	signal sampling_clk 		: std_logic := '0';
	signal start_bit_sensing 	: std_logic := '0';
	signal start_bit_SR			: std_logic := '0';
	signal parity_bit_reg		: std_logic := '0';
	signal data_ready_reg		: std_logic := '0';

	signal data_register		: std_logic_vector(pack_len-1 downto 0);
	signal latched_data			: std_logic_vector(pack_len-1 downto 0);

	signal rx_data_status		: std_logic := '0';
	signal bit_clocks_counter	: integer range 0 to Oversampling_Ratio-1;
	signal data_bits_counter	: integer range 0 to pack_len;
	
	--------------------------------------

	
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


	--------------------------------------
	-- todo: remake. Bad realization.
	process(sampling_clk)
	begin
		if(rising_edge(sampling_clk)) then
			if(edge_sensing_reg(0) = '0' and data_i = '1') then
				start_bit_SR <= '1';		
			end if; -- edge_sensing_reg = "01"

			
			if(start_bit_SR = '1') then
				edge_sensing_reg(0) <= data_i; -- ?
				bit_clocks_counter <= bit_clocks_counter + 1;
				
				if(bit_clocks_counter = Relative_Phase and rx_data_status = '0') then
					bit_clocks_counter <= 0;
					if(data_i = '0') then
						start_bit_SR <= '0';
--						start_bit_sensing <= '0';
					else
						rx_data_status <= '1';
					end if; -- data_i = '0' and rx_data_status = '0'
				end if; -- bit_clocks_counter = Relative_Phase
				
				if(rx_data_status = '1' and bit_clocks_counter = Oversampling_Ratio-1) then
					bit_clocks_counter <= 0;
					data_bits_counter <= data_bits_counter + 1;
					shift <= '1';
					if(data_bits_counter = pack_len-1) then
						latch <= '1';
						start_bit_SR <= '0';
						data_bits_counter <= 0;
						bit_clocks_counter <= 0;
						rx_data_status <= '0';
					else
						latch <= '0';
					end if; -- data_bits_counter
				else
					shift <= '0';
				end if; -- rx_data_status = '1' and bit_clocks_counter = Oversampling_Ratio-1					
			end if; -- start_bit_SR
			
			if(latch = '1') then
				shift <= '0';
				latch <= '0';
				start_bit_SR <= '0';
			end if;
		
			if(latch = '1') then
				data_ready_reg <= not parity_bit_reg;
			else
				data_ready_reg <= '0';
			end if;
		
		end if; -- rising_edge(sampling_clk)
	end process; -- clk_i


	process(shift)
	begin
		if(rising_edge(shift)) then
			data_register <= data_register(pack_len-2 downto 0) & data_i;
			if(data_bits_counter < pack_len) then
				parity_bit_reg <= parity_bit_reg xor data_i;
			end if;
		end if;
	end process;
	
	process(latch)
	begin
		if(rising_edge(latch)) then
			latched_data <= data_register;
		end if;
	end process;

	IRQ_o  <= data_ready_reg;
	data_o <= latched_data(9 downto 2);
end Behavioral;