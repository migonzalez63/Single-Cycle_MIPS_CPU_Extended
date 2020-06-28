--------------------------
-- Miguel Gonzalez      --
-- CS341                --
-- March 9, 2019        --
--------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Creates the register file, which holds all the contents of the registers
-- in our CPU
entity registers is
    Port ( regi_write, clk, reset, m_write, mfhi_read, mflo_read : in  STD_LOGIC;
			  read_regi1, read_regi2 , write_register : in  STD_LOGIC_VECTOR (4 downto 0);
           write_data, mfhi, mflo : in  STD_LOGIC_VECTOR (31 downto 0);
           read_data1, read_data2 : out  STD_LOGIC_VECTOR (31 downto 0));
end registers;

architecture Behavioral of registers is
	
	-- forms register array to hold contents
	type t_registers is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
	signal registers : t_registers;
	
	type t_special is array (0 to 1) of STD_LOGIC_VECTOR (31 downto 0);
	signal hilo : t_special;

begin
	
	hilo(0) <= mfhi when m_write = '1'; -- Sets HI register
	hilo(1) <= mflo when m_write = '1'; -- Sets LO register
		
	process(clk, reset)
		begin
			if(reset = '1') then -- initializes values to 0
				registers <= (
					X"00000000",
					others =>  X"00000000" );
			-- If regi-write is enabled, we will write back into an array
			elsif(clk'event and clk = '1' and regi_write = '1') then
				registers(to_integer(unsigned(write_register))) <= write_data;
			end if;
	end process;
	
	-- Will immediatly output the content of each register requested
	read_data1 <= hilo(0) when mfhi_read = '1' else
						hilo(1) when mflo_read = '1' else
						registers(to_integer(unsigned(read_regi1)));
	read_data2 <= X"00000000" when (mfhi_read = '1' OR mflo_read = '1') else
						registers(to_integer(unsigned(read_regi2)));
end Behavioral;
