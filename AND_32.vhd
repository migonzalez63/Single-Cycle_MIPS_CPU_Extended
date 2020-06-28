--------------------------
-- Miguel Gonzalez      --
-- CS341                --
-- March 9, 2019        --
--------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Performs and on 32 bit inputs
entity AND_32 is
    Port ( A_and, B_and  : in  STD_LOGIC_VECTOR (31 downto 0);
           Z_and : out  STD_LOGIC_VECTOR (31 downto 0));
end AND_32;

architecture Behavioral of AND_32 is

begin
	
	-- Using generate, we will iterate through every bit and perform operation
	gen: for i in 0 to 31 generate
		Z_and(i) <= A_and(i) AND B_and(i);
	end generate;

end Behavioral;

