library ieee;
use ieee.std_logic_1164.all;

entity CyclicCnctr is

	generic
	(
		NUM_STAGES : natural := 8
	);

	port 
	(
		clk		: in std_logic;
--		preset  : in std_logic;
		q		: out std_logic_vector((NUM_STAGES-1) downto 0)
	);

end entity;

architecture rtl of CyclicCnctr is

	type cntr_data is array ((NUM_STAGES-1) downto 0) of std_logic;
	signal sr: cntr_data;

begin

	process (clk)
	begin
		if (rising_edge(clk)) then
			sr((NUM_STAGES-1) downto 1) <= sr((NUM_STAGES-2) downto 0);
			sr(0) <= not(sr(NUM_STAGES-1));

--			if (preset = '1') then
--				sr(0) <= '1';
--			end if;

		end if;
		
		q <= std_logic_vector(sr);
	end process;
end rtl;





