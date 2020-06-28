--------------------------
-- Miguel Gonzalez      --
-- CS341                --
-- March 9, 2019        --
--------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Creates a register called PC that keeps track of our current position
-- on the program we are trying to execute
entity program_counter is
    Port ( clk, reset : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (31 downto 0);
           data_out : out  STD_LOGIC_VECTOR (31 downto 0));
end program_counter;

architecture Behavioral of program_counter is

begin
	process(clk, reset)
		begin
			if(reset = '1') then -- Resets value of PC
				data_out <= X"00000000";
			elsif(clk'event and clk = '1') then -- Updates value of PC on every rising edge
				data_out <= data_in;
			end if;
	end process;
end Behavioral;

