--------------------------
-- Miguel Gonzalez      --
-- CS341                --
-- March 9, 2019        --
--------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Performs addition on 32 bit inputs
entity full_adder_32 is
    Port ( a : in  STD_LOGIC_VECTOR(31 downto 0);
           b : in  STD_LOGIC_VECTOR(31 downto 0);
			  carry_in: in STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR(31 downto 0);
           carry_out : out  STD_LOGIC);
end full_adder_32;

architecture Behavioral of full_adder_32 is

-- Performs addition on 1 bit inputs
component full_adder is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           sum : out  STD_LOGIC;
           cout : out  STD_LOGIC);
end component;

signal c: STD_LOGIC_VECTOR (32 downto 0);

begin

	-- Uses 32 instances of 1 bit input adder to perform operation
	gen: for i in 0 to 31 generate
				uut: full_adder port map (a => a(i), b => b(i), cin => c(i), sum => sum(i), cout => c(i+1));
	end generate;
	
	c(0) <= carry_in;
	carry_out <= c(32);

end Behavioral;