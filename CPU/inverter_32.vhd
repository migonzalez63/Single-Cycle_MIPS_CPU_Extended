--------------------------
-- Miguel Gonzalez      --
-- CS341                --
-- March 9, 2019        --
--------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Gets the 2's comp of a number
entity inverter_32 is
    Port ( num : in  STD_LOGIC_VECTOR(31 downto 0);
           z : out  STD_LOGIC_VECTOR(31 downto 0));
end inverter_32;

architecture Behavioral of inverter_32 is

component full_adder_32 is
    Port ( a : in  STD_LOGIC_VECTOR(31 downto 0);
           b : in  STD_LOGIC_VECTOR(31 downto 0);
			  carry_in: in STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR(31 downto 0);
           carry_out : out  STD_LOGIC);
end component;

signal ones_comp: STD_LOGIC_VECTOR(31 downto 0);
signal twos_comp: STD_LOGIC_VECTOR(31 downto 0);

begin
	
	-- Gets the 1's comp of input
	ones_comp <= NOT num;

	-- Gets 2's comp by adding 1 to 1's comp
	uut: full_adder_32 port map (a => ones_comp,
										b => X"00000000",
										carry_in => '1',
										sum => twos_comp);
										
	z <= twos_comp;
	
end Behavioral;

