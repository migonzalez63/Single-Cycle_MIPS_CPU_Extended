----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:54:19 04/25/2019 
-- Design Name: 
-- Module Name:    Mult - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Brings in the Multiplier and a Counter mechanism in order to stall
-- the CPU for us to calculate the multiplication
entity Mult_Unit is
    Port ( regi_1, regi_2 : in  STD_LOGIC_VECTOR (31 downto 0);
           stall, reset, clk : in  STD_LOGIC;
           mfhi_main, mflo_main : out  STD_LOGIC_VECTOR (31 downto 0);
           enable, m_write : out  STD_LOGIC);
end Mult_Unit;

architecture Behavioral of Mult_Unit is

-- Performs multiplication algorithm
component Multiplier is
    Port ( Multiplicand, Multiplier : in  STD_LOGIC_VECTOR (31 downto 0);
           clk, write_enable: in  STD_LOGIC;
           mfhi, mflo : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Keeps track of how many cycles we have left to stall our CPU
component Counter is
    Port ( set, reset,clk : in  STD_LOGIC;
           new_count : in  STD_LOGIC_VECTOR (31 downto 0);
           old_count : out  STD_LOGIC_VECTOR (31 downto 0);
           zero : out  STD_LOGIC);
end component;

-- Will generate the next cycle iteration for our stall
component Decreaser is
    Port ( old_count : in  STD_LOGIC_VECTOR (31 downto 0);
           enable : in  STD_LOGIC;
           new_count : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

signal main_zero, counter_zero: STD_LOGIC;
signal current_count, next_count, new_count: STD_LOGIC_VECTOR(31 downto 0);

begin
			
	-- Source registers are inputed into the Multiplier to begin algorithm
	Multiplier_Unit: Multiplier port map(Multiplicand => regi_1,
													 Multiplier => regi_2,
													 clk => clk,
													 write_enable => stall,
													 mfhi => mfhi_main,
													 mflo => mflo_main);
	
	-- Stall signal is given in order to start the algorithm. We will either
	-- set our product register to 32 if starting a multiply or a reset to 0 if
	-- CPU is reseted. Counter will output its current iteration of cycles to Decreaser
	-- and it will generate the next iteration.
	Counter_Register: Counter port map(set => stall,
												  reset => reset,
												  clk => clk,
												  new_count => next_count,
												  old_count => current_count,
												  zero => counter_zero);
												  												  
	Counter_Subtractor: Decreaser port map(old_count => current_count,
														enable => main_zero,
														new_count => new_count);
	
	-- On every clock cycle, we will check if our Counter register is 0. If it is
	-- then we can reenable our PC and Intruction memory and allow the CPU to continue
	-- where it left off. If it is not zero, we will continue to stall and allow for the
	-- results of our product tom be written into their appropiate registers
	process(clk, counter_zero)
		begin
			if(clk'event and clk = '1' and counter_zero = '0') then
				main_zero <= '1';
			elsif(clk'event and clk = '1' and counter_zero = '1') then
				main_zero <= '0';
			end if;
	end process;
	
	-- When our Counter register is 0, our next iteration will be -1 and begin to oscillate. This helps
	-- prevent that from happening by forcing next_count to 0.
	next_count <= X"00000000" when counter_zero = '1' else new_count;
	
	-- Allows for the hi and lo product result to be read into their appropiate registers.
	m_write <= main_zero;
	
	-- Signal to enable components of our CPU
	enable <= NOT main_zero;
													 

end Behavioral;

