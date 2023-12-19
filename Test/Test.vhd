-- Quartus II VHDL Template
-- Basic Shift Register

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity Test is

	generic
	(
		NUM_STAGES : natural := 8
	);

	port 
	(
		clk		: in std_logic;
		en		: in std_logic;
		q		: out std_logic
	);

end entity;

architecture rtl of Test is
	signal cnt	: std_logic_vector(5 downto 0);
	signal sig  : std_logic_vector(0 downto 0);

	
	COMPONENT Test_mem_32_x_1bit
	PORT (
		address		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
	);
	END COMPONENT;
begin
		RAM1024_inst : Test_mem_32_x_1bit PORT MAP (
		address	 => cnt(4 downto 0), 
		clock	 => clk,
		data	 => (others => '0'),
		wren	 => '0',
		q	 	 => sig
	);


	process (clk)
	begin
		if (rising_edge(clk)) then
			if(en = '1') then
				cnt <= cnt + '1';
				q <= sig(0);
			else
				q <= '0';
			end if;
			if(cnt=31) then
				cnt <= (others=>'0');
			end if;
		end if;
	end process;


end rtl;
