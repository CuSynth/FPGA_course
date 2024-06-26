library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SyncCntr is

	generic
	(
		CNT_WIDTH : natural := 8
	);

	port 
	(
		clk 	: in std_logic;
		dir		: in std_logic;
		rst		: in std_logic;
		q		: out std_logic_vector((CNT_WIDTH-1) downto 0)

	);

end entity;

architecture rtl of SyncCntr is
	signal Trig_Array: std_logic_vector((CNT_WIDTH-1) downto 0);
begin

	process (clk)
	begin
		if (rising_edge(clk)) then
			if rst = '1' then
				Trig_Array <= (others => '0');
			else
				if dir = '0' then
					Trig_Array <= Trig_Array + '1';
				else
					Trig_Array <= Trig_Array - '1';
				end if;
			end if;
		end if;
	end process;
		
	q <= (Trig_Array);
	
end rtl;
