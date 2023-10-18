library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity PulseGen is

	generic
	(
		PULSE_WIDTH : natural := 3;
		CNT_WIDTH 	: natural := 8
	);

	port 
	(
		clk 	: in std_logic;
		d	 	: in std_logic;
		q		: out std_logic
	);

end entity;

architecture rtl of PulseGen is
	signal Cnt_Arr  	: std_logic_vector((CNT_WIDTH-1) downto 0);
	signal ES_T1		: std_logic;
	signal ES_T2  		: std_logic;
	signal ES 			: std_logic;
	signal SRFF			: std_logic;
	signal RS_INT		: std_logic;
	
begin

	process (clk)
	begin
		if (rising_edge(clk)) then
			ES_T1 <= d;
			ES_T2 <= ES_T1;
			ES <= ES_T1 and not(ES_T2);
						

			
			if (ES = '1') then
				SRFF <= '1';
			elsif (RS_INT = '1') then
				SRFF <= '0';
			end if;


			
			if (SRFF = '1') then
				Cnt_Arr <= Cnt_Arr + '1';
			end if;

			if (Cnt_Arr = PULSE_WIDTH) then
				RS_INT <= '1';
			else
				RS_INT <= '0';
			end if;
	
			if (RS_INT = '1') then
				Cnt_Arr <= (others => '0');
			end if;
			
		end if;
	end process;
	
	q <= SRFF;
	
end rtl;
