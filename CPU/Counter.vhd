library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Creates a counter register that stores a number and updates it every
-- clock cycle.
entity Counter is
    Port ( set, reset, clk : in  STD_LOGIC;
           new_count : in  STD_LOGIC_VECTOR (31 downto 0);
           old_count : out  STD_LOGIC_VECTOR (31 downto 0);
           zero : out  STD_LOGIC);
end Counter;

architecture Behavioral of Counter is
-- Signal used to store the intermediate value of our counter
signal counter: STD_LOGIC_VECTOR (31 downto 0);

begin
	
	-- Process that sets the counter to a different value depending on the signals
	-- it recieves
	process(clk, set, reset)
		begin
			if reset = '1' then
				counter <= X"00000000";
			elsif set = '1' then
				counter <= X"00000020";
			elsif(clk'event and clk = '1') then
				counter <= new_count;
			end if;
	end process;
	
	old_count <= counter;
	
	-- Will output a 1 when our counter is zero
	zero <= '1' when counter = X"00000000" else '0';

end Behavioral;

