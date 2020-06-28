--------------------------
-- Miguel Gonzalez      --
-- CS341                --
-- March 9, 2019        --
--------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Creates Multiplexer used to split signals depending on a given
-- selector, in order to properly execute instructions
entity Multiplexer_2to1 is
    Port ( First_input : in  STD_LOGIC_VECTOR (31 downto 0);
           Second_input : in  STD_LOGIC_VECTOR (31 downto 0);
           Selector : in  STD_LOGIC;
           Mux_out : out  STD_LOGIC_VECTOR (31 downto 0));
end Multiplexer_2to1;

architecture Behavioral of Multiplexer_2to1 is

begin
	
	-- Gets the first input if selector is low, else we get the second input
	Mux_out <= First_input when Selector = '0' else Second_input;
	
end Behavioral;

