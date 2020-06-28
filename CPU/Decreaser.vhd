library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Acts as a subtractor for our Counter Register by always adding one to 
-- its input
entity Decreaser is
    Port ( old_count : in  STD_LOGIC_VECTOR (31 downto 0);
           enable : in  STD_LOGIC;
           new_count : out  STD_LOGIC_VECTOR (31 downto 0));
end Decreaser;

architecture Behavioral of Decreaser is

component ALU is
    Port ( A, B : in  STD_LOGIC_VECTOR (31 downto 0);
           C : in  STD_LOGIC_VECTOR (4 downto 0);
           R : out  STD_LOGIC_VECTOR (31 downto 0);
           E : out  STD_LOGIC);
end component;

-- Will determine what operation our ALU needs to performed based
signal ALU_Op: STD_LOGIC_VECTOR (4 downto 0);

begin

	ALU_Op <= "00010" when enable = '1' else "11111";
	
	-- Will add -1 to our input
	Count_Sub: ALU port map(A => old_count,
									B => X"FFFFFFFF",
									C => ALU_Op,
									R => new_count);
	
end Behavioral;

