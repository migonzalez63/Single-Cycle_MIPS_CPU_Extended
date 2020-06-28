--------------------------
-- Miguel Gonzalez      --
-- CS341                --
-- March 9, 2019        --
--------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- Creates the component Instruction memory which stores the program that our 
-- CPU will run 
entity instr_mem is
    Port ( addr : in  STD_LOGIC_VECTOR (31 downto 0);
			  enable : in STD_LOGIC;
           instruction : out  STD_LOGIC_VECTOR (31 downto 0));
end instr_mem;

architecture Behavioral of instr_mem is

-- Creates the array to hold instructions 
signal instr_addr: STD_LOGIC_VECTOR (31 downto 0);

-- Since our PC increases by 4 each time, wee need to ensure that our instructions
-- are byte addresable in order to get the full instruction
type instr_type is array (0 to 400) of STD_LOGIC_VECTOR (7 downto 0);

constant instructions: instr_type :=(
		-- type instructions here
		-- Model Program from Lab
		X"00", X"00", X"00", X"00",
		X"20", X"09", X"00", X"05",
		X"20", X"0A", X"00", X"04",
		X"20", X"08", X"00", X"00",
		X"15", X"40", X"00", X"03",
		X"01", X"09", X"40", X"20",
		X"21", X"4A", X"ff", X"ff",
		X"08", X"00", X"00", X"04",
		X"00", X"00", X"00", X"00",
		X"01", X"2A", X"00", X"18",
		X"00", X"00", X"00", X"00",
		X"00", X"00", X"58", X"10",
		X"00", X"00", X"00", X"00",
		X"00", X"00", X"58", X"12",
		others => X"00"
	);

begin

	-- Reads in the PC and outputs the instruction at that PC
	instr_addr <= addr;
	instruction <= instructions(to_integer(unsigned(instr_addr))+0) &
						instructions(to_integer(unsigned(instr_addr))+1) &
						instructions(to_integer(unsigned(instr_addr))+2) &
						instructions(to_integer(unsigned(instr_addr))+3) when enable = '1' else X"00000000";

end Behavioral;