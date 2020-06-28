library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Control Unit for our Productr Register in order to know when to 
-- write into it
entity Control is
    Port ( clk, Mult_Bit, start : in  STD_LOGIC;
           write_enable, reset : out  STD_LOGIC;
           ALU_Op : out  STD_LOGIC_VECTOR (4 downto 0));
end Control;

architecture Behavioral of Control is
	begin
		--When we first read a Mult instruction, we will send a reset signal
		reset <= '1' when start = '1' else '0';
		
		-- We will send a write signal whenever our Mult_bit is one and 
		-- set our ALU to add
		write_enable <= '1' when Mult_Bit = '1' else '0';
		ALU_Op <= "00010" when Mult_Bit = '1' else "11111";
	
end Behavioral;

