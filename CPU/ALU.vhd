--------------------------
-- Miguel Gonzalez      --
-- CS341                --
-- March 9, 2019        --
--------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Creates the Arithmetic Logic Unit used in our CPU. Can perform operations
-- such as logical and, or, & nor, add, sub and set less than
-- Used capital naming convection in order to differentiate from other component input
entity ALU is
    Port ( A, B : in  STD_LOGIC_VECTOR (31 downto 0);
           C : in  STD_LOGIC_VECTOR (4 downto 0);
           R : out  STD_LOGIC_VECTOR (31 downto 0);
           E : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

-- Components used to add and subtract
component full_adder_32 is
    Port ( a : in  STD_LOGIC_VECTOR(31 downto 0);
           b : in  STD_LOGIC_VECTOR(31 downto 0);
			  carry_in: in STD_LOGIC;
           sum : out  STD_LOGIC_VECTOR(31 downto 0);
           carry_out : out  STD_LOGIC);
end component;

-- takes the 1's complement of a number
component inverter_32 is
    Port ( num : in  STD_LOGIC_VECTOR(31 downto 0);
           z : out  STD_LOGIC_VECTOR(31 downto 0));
end component;
 -- Component to do logical and on 32-bit numbers
component AND_32 is
    Port ( A_and, B_and  : in  STD_LOGIC_VECTOR (31 downto 0);
           Z_and : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Component to do logical or on 32-bit numbers
component OR_32 is
    Port ( A_or, B_or : in  STD_LOGIC_VECTOR (31 downto 0);
           Z_or : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Component to do logical nor on 32-bit numbers
component NOR_32 is
    Port ( A_nor, B_nor : in  STD_LOGIC_VECTOR (31 downto 0);
           Z_nor : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Gets the sign bit of a number
signal MSB: STD_LOGIC;

-- Signals used to connect components
signal subtractor, comparator, result, temp: STD_LOGIC_VECTOR(31 downto 0);
signal addA, addB, subA, subB, andA, andB, orA, orB, norA, norB, lessThanA, lessThanB: STD_LOGIC_VECTOR(31 downto 0):= X"00000000";
signal resultAdd, resultSub, resultOr, resultAnd, resultLessThan, resultNor: STD_LOGIC_VECTOR(31 downto 0):= X"00000000";
begin	
	
	-- We will check what C is and set values to our signals based on that
	andA <= A when (C = "00000") else X"00000000";
	andB <= B when (C = "00000") else X"00000000";
	orA <= A when (C = "00001") else X"00000000";
	orB <= B when (C = "00001") else X"00000000";
	addA <= A when (C = "00010") else X"00000000";
	addB <= B when (C = "00010") else X"00000000";
	subA <= A when (C = "00110") else X"00000000";
	subB <= B when (C = "00110") else X"00000000";
	lessThanA <= A when (C = "00111") else X"00000000";
	lessThanB <= B when (C = "00111") else X"00000000";
	norA <= A when (C = "01100") else X"00000000";
	norB <= B when (C = "01100") else X"00000000";
		
	-- Performs logical and 
	logi_and: AND_32 port map(A_and => andA,
								B_and => andB,
								Z_and => resultAnd);
	
	-- Performs logical or
	logi_or: OR_32 port map(A_or => orA,
									B_or => orB,
									Z_or => resultOr);
	
	-- Performs addition
	add: full_adder_32 port map(a => addA,
										b => addB,
										carry_in => '0',
										sum => resultAdd);
	
	-- Takes 2's comp for a number in order to turn it negative
	set_sub: inverter_32 port map(num => subB,
											z => subtractor);
										
	-- Performs addition by using the subtractor
	sub: full_adder_32 port map(a => subA,
										 b => subtractor,
										 carry_in => '0',
										 sum => resultSub);
	
	-- Takes 2's comp of number
	set_comparator: inverter_32 port map(num => lessThanB,
													 z => comparator);
	
	-- Performs comparison by subtracting 2 numbers and checking its sign bit
	less_than: full_adder_32 port map(a => lessThanA,
											   b => comparator,
												carry_in => '0',
												sum => temp);
	
	-- Performs logical nor
	logi_nor: NOR_32 port map(A_nor => norA,
									  B_nor => norB,
									  Z_nor => resultNor);
	
	-- Takes sign bit of the result of slt
	MSB <= temp(31);
	
	-- Slt is 1 if number is negative, else 0
	resultLessThan(0) <= '1' when (MSB = '1') else '0';
	
	-- Use the C in order to know what value to output
	with C select
		result <= resultAnd when "00000",
				resultOR when "00001",
				resultAdd when "00010",
				resultSub when "00110",
				resultLessThan when "00111",
				resultNor when "01100",
				X"00000000" when others;

	-- If the result is 0, we set E to 1, else 0
	E <= '1' when result = X"00000000" else '0';
	
	-- Output
	R <= result;
end Behavioral;

