-- ADC imitator

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity ADC_Imitator is
	port 
	(
		ADC_clk_i		: in std_logic;
		ADC_CS_i		: in std_logic := '1';
		ADC_Data_Out_o	: out STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		Reset_i			: in std_logic := '0';
		
		Test_Interval_i	: in std_logic := '1';
		Test_RAM_Out_o  : out STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		ADC_addr_cnt_o  : out STD_LOGIC_VECTOR(7 DOWNTO 0);
		Test_addr_cnt_o : out STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
end entity;

architecture rtl of ADC_Imitator is

    signal ADC_addr_cnt_s 	: STD_LOGIC_VECTOR(7 DOWNTO 0);
    
    signal clk_s			: std_logic;
    
    signal Test_addr_cnt_s 	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal reg_s 			: STD_LOGIC_VECTOR(15 DOWNTO 0);
	
    signal ADC_RAM_out_s 	: STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal Data_RAM_out_s	: STD_LOGIC_VECTOR(15 DOWNTO 0);
begin
	
	ADC_RAM256_inst : RAM256 PORT MAP (
		address	 => ADC_addr_cnt_s,
		clock	 => clk_s,
		data	 => (others => '0'),
		wren	 => '0',
		q	 	 => ADC_RAM_out_s
	);
	
	DATA_RAM256_inst : RAM256 PORT MAP (
		address	 => Test_addr_cnt_s,
		clock	 => clk_s,
		data	 => reg_s,
		wren	 => Test_Interval_i,
		q	 	 => Data_RAM_out_s
	);
	
	
	clk_s <= ADC_clk_i;

	process (clk_s)
	begin
		if (Reset_i = '1') then
			ADC_addr_cnt_s  <= (others=>'0');
			Test_addr_cnt_s <= (others=>'0');
		else if (rising_edge(clk_s)) then
				if (ADC_CS_i = '1') then
					ADC_addr_cnt_s <= ADC_addr_cnt_s + '1';
				end if;
				if (Test_Interval_i = '1') then
					Test_addr_cnt_s <= Test_addr_cnt_s + '1';
				end if;
				reg_s(14 downto 0) <= (ADC_RAM_out_s(15 downto 1)); -- divide ADC data by 2 for example
				reg_s(15)<='0';
			 end if;
		end if;
	end process;
	
	ADC_Data_Out_o <= ADC_RAM_out_s;
	Test_RAM_Out_o <= Data_RAM_out_s;
	
	ADC_addr_cnt_o <= ADC_addr_cnt_s;
	Test_addr_cnt_o <= Test_addr_cnt_s;
end rtl;