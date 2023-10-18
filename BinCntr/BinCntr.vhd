library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity BinCntr is

	generic
	(
		CNT_WIDTH : natural := 8
	);

	port 
	(
		clk 	: in std_logic;
		q		: out std_logic_vector((CNT_WIDTH-1) downto 0)

	);

end entity;

architecture rtl of BinCntr is
	signal Trig_Array: std_logic_vector((CNT_WIDTH-1) downto 0);
begin

	process (clk)
	begin
		if (rising_edge(clk)) then
			Trig_Array(0) <= not(Trig_Array(0));
		end if;
	end process;
	
	FOR_GEN: for i in 0 to (CNT_WIDTH-2) generate 
		process (Trig_Array(i))
		begin
			if (falling_edge(Trig_Array(i))) then
				Trig_Array(i+1) <= not(Trig_Array(i+1));
			end if;
		end process;
	end generate FOR_GEN;
	
	q <= (Trig_Array);
	
end rtl;
