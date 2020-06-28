library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Determines what type of branch instruction to execute and sets the selector
-- for the multiplexer
entity Branch_Funct is
    Port ( Branch_op : in  STD_LOGIC_VECTOR (1 downto 0);
           Zero : in  STD_LOGIC;
           branch_ex : out  STD_LOGIC);
end Branch_Funct;

architecture Behavioral of Branch_Funct is

signal A, B: STD_LOGIC;

begin

A <= Branch_op(1);
B <= Branch_op(0);

branch_ex <= ((NOT Zero) AND (NOT A) AND B) OR (Zero AND A AND B);

end Behavioral;

