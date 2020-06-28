--------------------------
-- Miguel Gonzalez      --
-- CS341                --
-- March 9, 2019        --
--------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Performs less than operation on 32 bit value
entity less_than_32 is
    Port ( A_LT, B_LT : in  STD_LOGIC_VECTOR (31 downto 0);
           Z_LT : out  STD_LOGIC_VECTOR (31 downto 0));
end less_than_32;

architecture Behavioral of less_than_32 is

begin

	gen: for i in 0 to 31 generate
		Z_LT(i) <= '1' when A_LT(i) < B_LT(i) else '0';
	end generate;

end Behavioral;

