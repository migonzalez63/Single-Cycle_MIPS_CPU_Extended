----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:22:18 03/01/2019 
-- Design Name: 
-- Module Name:    mem - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

entity mem is
    Port ( clk, reset : in  STD_LOGIC;
           addr, data_in : in  STD_LOGIC_VECTOR (31 downto 0);
           write_enable : in  STD_LOGIC;
           read_enable : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (31 downto 0));
end mem;

architecture Behavioral of mem is
  type t_mem is array (0 to 511) of std_logic_vector(7 downto 0);
  signal array_mem : t_mem;

begin

process(clk,reset)
  
  begin
    
	 if(reset='1') then
      -- NOTE: the following functionality allows you to initialize
      -- the contents of the memory
      array_mem <= (
        "00000000","00000000","00000000","00000000", -- 32-bit word at addr 0
        "00000000","00000000","00000000","00000000", -- 32-bit word at addr 4
        "00000000","00000000","00000000","00000000", -- 32-bit word at addr 8
        -- you can add more 32-bit words here if needed...
        -- the following line sets all other bytes in the memory to 0
        others => "00000000" );
    elsif(clk'event and clk='1' and write_enable='1') then
      array_mem(to_integer(signed(addr))+0) <= data_in(31 downto 24);
      array_mem(to_integer(signed(addr))+1) <= data_in(23 downto 16);
      array_mem(to_integer(signed(addr))+2) <= data_in(15 downto 8);
      array_mem(to_integer(signed(addr))+3) <= data_in(7 downto 0);
    end if;
     
    if(read_enable='1' and reset='0') then
      data_out <= array_mem(to_integer(signed(addr))+0) &
                  array_mem(to_integer(signed(addr))+1) &
                  array_mem(to_integer(signed(addr))+2) &
                  array_mem(to_integer(signed(addr))+3);
    else
      data_out <= "00000000000000000000000000000000";
    
	 end if;
  
  end process;

end Behavioral;