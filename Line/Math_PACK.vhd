-- Package Declaration Section
package Math_PACK is
   constant VGA_Color_Depth : natural := 4;

   function f_log2 (x : positive) return natural;

end package Math_PACK;



-- Package Body Section
package body Math_PACK is
 
   function f_log2 (x : positive) return natural is
      variable i : natural;
     begin
      i := 0;  
      while (2**i < x) and i < 31 loop
         i := i + 1;
      end loop;
      return i;
   end function;
 
end package body Math_PACK;