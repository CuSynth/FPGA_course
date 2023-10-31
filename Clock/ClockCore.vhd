library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ClockCore is
	port(
		CC_clk_i	:	in  std_logic;
		CC_up_i		:	in  std_logic;
		CC_down_i	:	in  std_logic;
		CC_time_o	:	out std_logic_vector(15 downto 0)
	);
end ClockCore;


architecture Behavioral of ClockCore is
	
	signal sec		:	integer range 0 to 60 := 0;
	signal m1		:	integer range 0 to 10 := 0;
	signal m10		:	integer range 0 to 6 := 0; 
	signal h1		:	integer range 0 to 10 := 0; 
	signal h10		:	integer range 0 to 3 := 0; 

begin
	process(CC_clk_i)
	begin
		if(rising_edge(CC_clk_i)) then
			if(CC_up_i = '1') then			
				m1 <= m1 + 1;
				
				if m1 = 9 then
					m10 <= m10 + 1;
					m1 <= 0;
				
					if m10 = 5 then
						h1 	<= h1 + 1;
						m10 <= 0;
						m1 	<= 0;

						if h1 = 9 then
						  h10 <= h10 + 1;
						  h1  <= 0;						  
						end if; -- h1
						
						if h10 = 2 and h1 = 3 then
							 h10 <= 0;
							 h1 <= 0;
						end if; -- h10 h1 == 23
					end if; -- m10
				end if; -- m1
			end if; -- CC_up_i = '1'
			
		
			if(CC_down_i = '1') then			
				m1 <= m1 - 1;
				
				if m1 = 0 then
					m10 <= m10 - 1;
					m1 <= 9;
				
					if m10 = 0 then
						h1 	<= h1 - 1;
						m10 <= 5;
						m1 	<= 9;

						if h1 = 0 then
						  h10 <= h10 - 1;
						  h1  <= 9;						  
						end if; -- h1
						
						if h10 = 0 and h1 = 0 then
							 h10 <= 2;
							 h1 <= 3;
						end if; -- h10 h1 == 24
					end if; -- m10
				end if; -- m1
			end if; -- CC_down_i = '1'
			
		end if; -- rising_edge(CC_clk_i)
	end process;
	
	CC_time_o(3 downto 0) 	<= std_logic_vector(to_unsigned(m1, 4));
	CC_time_o(7 downto 4) 	<= std_logic_vector(to_unsigned(m10, 4));
	CC_time_o(11 downto 8) 	<= std_logic_vector(to_unsigned(h1, 4));
	CC_time_o(15 downto 12)	<= std_logic_vector(to_unsigned(h10, 4));

end Behavioral;