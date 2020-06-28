--------------------------
-- Miguel Gonzalez      --
-- CS341                --
-- March 9, 2019        --
--------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Perfomrs or operation on 32 bit inputs
entity OR_32 is
    Port ( A_or, B_or : in  STD_LOGIC_VECTOR (31 downto 0);
           Z_or : out  STD_LOGIC_VECTOR (31 downto 0));
end OR_32;

architecture Behavioral of OR_32 is

begin

	gen: for i in 0 to 32 generate
		Z_or <= A_or OR B_OR;
	end generate;

end Behavioral;

