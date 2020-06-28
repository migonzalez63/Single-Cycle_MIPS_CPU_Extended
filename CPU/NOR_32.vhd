--------------------------
-- Miguel Gonzalez      --
-- CS341                --
-- March 9, 2019        --
--------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Perfoms logical nor opertaion on 32 bit input
entity NOR_32 is
    Port ( A_nor, B_nor : in  STD_LOGIC_VECTOR (31 downto 0);
           Z_nor : out  STD_LOGIC_VECTOR (31 downto 0));
end NOR_32;

architecture Behavioral of NOR_32 is

begin

	gen: for i in 0 to 31 generate
		Z_nor(i) <= A_nor(i) NOR B_nor(i);
	end generate;

end Behavioral;

