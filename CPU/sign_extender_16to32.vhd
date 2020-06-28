--------------------------
-- Miguel Gonzalez      --
-- CS341                --
-- March 9, 2019        --
--------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Sign extends a 16 bit input
-- Changed naming convention to differntiate from other component inputs
entity sign_extender_16to32 is
    Port ( a_16 : in  STD_LOGIC_VECTOR (15 downto 0);
           z : out  STD_LOGIC_VECTOR (31 downto 0));
end sign_extender_16to32;

architecture Behavioral of sign_extender_16to32 is

signal MSB: STD_LOGIC;
signal s_16: STD_LOGIC_VECTOR(15 downto 0);
signal s_32: STD_LOGIC_VECTOR(31 downto 0);

begin
	
	s_16 <= a_16;
	
	-- We check the sign bit for the input
	MSB <= s_16(15);
	
	-- If it is 1, we know it is negative and concatonate 16 1's to it
	-- else, we know it is positive and we concactonate 16 0's to it
	s_32 <= X"ffff" & s_16 when (MSB = '1') else X"0000" & s_16;
	
	z <= s_32;
	
end Behavioral;

