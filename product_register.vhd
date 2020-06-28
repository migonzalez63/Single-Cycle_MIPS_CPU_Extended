library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Performs long multiplication with the help of a Control and an ALU
entity Product_Register is
    Port ( reset, clk : in STD_LOGIC;
			  write_enable: in STD_LOGIC;
			  sum, multiplier : in  STD_LOGIC_VECTOR (31 downto 0);
           upper, lower : out  STD_LOGIC_VECTOR (31 downto 0));
end Product_Register;

architecture Behavioral of Product_Register is
signal temp, product: STD_LOGIC_VECTOR (63 downto 0);
signal lower_bits: STD_LOGIC_VECTOR (31 downto 0);

begin
	
	-- Stores a temp value of the multiplier and the sum of the multiplicand
	-- and the 32 upper bits of the product register
	temp <= sum & product(31 downto 0);
	
	-- When we reset the register, we will set the product register with just the
	-- multipllier on it. When we recieve a write signal, we will take the sum
	-- of the multiplicand and the previous value of the upper 32 bits (temp), 
	-- and shift them to the right. We will always shift to the right, no matter what.
	process(clk)
		begin
			if reset = '1' then
				product <= X"00000000" & multiplier;
			elsif (clk'event and clk = '1' and write_enable = '1') then
				product <= STD_LOGIC_VECTOR(shift_right(unsigned(temp), 1));
			elsif (clk'event and clk = '1' and write_enable = '0') then
				product <= STD_LOGIC_VECTOR(shift_right(unsigned(product), 1));
			end if;
	end process;
	
	-- Split the register in two and output the results
	upper <= product(63 downto 32);
	lower <= product(31 downto 0);

end Behavioral;

