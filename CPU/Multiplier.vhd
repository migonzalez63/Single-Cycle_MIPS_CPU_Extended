library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Brings the Control Unit and the Product Register together in order to
-- perform long multiplication
entity Multiplier is
    Port ( Multiplicand, Multiplier : in  STD_LOGIC_VECTOR (31 downto 0);
           clk, write_enable: in  STD_LOGIC;
           mfhi, mflo : out  STD_LOGIC_VECTOR (31 downto 0));
end Multiplier;

architecture Behavioral of Multiplier is

-- Used to give the product register control signals
component Control is
    Port ( clk, Mult_Bit, start : in  STD_LOGIC;
           write_enable, reset : out  STD_LOGIC;
           ALU_Op : out  STD_LOGIC_VECTOR (4 downto 0));
end component;

-- Stores the results of each step of our product
component Product_Register is
    Port ( reset, clk : in STD_LOGIC;
			  write_enable: in STD_LOGIC;
			  sum, multiplier : in  STD_LOGIC_VECTOR (31 downto 0);
           upper, lower : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Calculates the next sum of the upper bits and multiplicand
component ALU is
    Port ( A, B : in  STD_LOGIC_VECTOR (31 downto 0);
           C : in  STD_LOGIC_VECTOR (4 downto 0);
           R : out  STD_LOGIC_VECTOR (31 downto 0);
           E : out  STD_LOGIC);
end component;

signal ALU_Op: STD_LOGIC_VECTOR (4 downto 0);
signal upper_product, lower_product, sum, regi1, regi2: STD_LOGIC_VECTOR(31 downto 0);
signal mult_bit, write_signal, reset: STD_LOGIC;

begin

	-- When we first start of our Multiplication, we will read in the values
	-- given to us
	regi1 <= Multiplicand when write_enable = '1';
	regi2 <= Multiplier when write_enable = '1';
	
	Partial_Product: ALU port map(A => upper_product,
										   B => regi1,
											C => ALU_Op,
											R => sum);
											
	Product: Product_Register port map(reset => reset,
												  clk => clk,
												  write_enable => write_signal,
												  sum => sum,
												  multiplier => regi2,
												  upper => upper_product,
												  lower => lower_product);
	
	-- If the LSB of the lower product is 1, we will perform the sum of the multiplicand
	-- and the previous upper bits of our product, else, we will just shift.
	mult_bit <= lower_product(0);
	
	Control_Test: Control port map(clk => clk,
											 Mult_Bit => mult_bit,
											 start => write_enable,
											 write_enable => write_signal,
											 reset => reset,
											 ALU_Op => ALU_Op);
											 
	
	-- Output result
	mfhi <= upper_product;
	mflo <= lower_product;
end Behavioral;

