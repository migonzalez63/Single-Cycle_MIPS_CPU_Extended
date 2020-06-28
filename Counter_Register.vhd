library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Counter_Register is
    Port ( set, reset : in  STD_LOGIC;
           zero : out  STD_LOGIC);
end Counter_Register;

architecture Behavioral of Counter_Register is

component Counter is
    Port ( set, reset : in  STD_LOGIC;
           new_count : in  STD_LOGIC_VECTOR (31 downto 0);
           old_count : out  STD_LOGIC_VECTOR (31 downto 0);
           zero : out  STD_LOGIC);
end component;

component Decreaser is
    Port ( old_count : in  STD_LOGIC_VECTOR (31 downto 0);
           enable : in  STD_LOGIC;
           new_count : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

signal old_count: STD_LOGIC_VECTOR (31 downto 0);
signal new_count: STD_LOGIC_VECTOR (31 downto 0);
signal is_zero: STD_LOGIC;

begin

	Counter_Regi: Counter port map (set => set,
											  reset => reset,
											  new_count => new_count,
											  old_count => old_count,
											  zero => is_zero);
  
  Decrementer: Decreaser port map (old_count => old_count,
											  enable => is_zero,
											  new_count => new_count);
											  
  zero <= is_zero;
											  
end Behavioral;

