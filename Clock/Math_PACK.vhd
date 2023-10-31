--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--use ieee.numeric_std.all;

package Math_PACK is
	function f_log2(x: positive) return natural;
end package Math_PACK;

package body Math_PACK is
	function f_log2(x: positive) return natural is
		variable i: natural;
	begin
		i := 0;
		-- integer - 32bit => max i = 31.
		while (2**i < x) and i < 31 loop
			i := i+1;
		end loop;
		return i;
	end function f_log2;
end package body Math_PACK;
