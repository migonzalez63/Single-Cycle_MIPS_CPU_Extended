--------------------------
-- Miguel Gonzalez      --
-- CS341                --
-- March 9, 2019        --
--------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Manages the ALU in order to perform the correct operations
entity ALU_Control is
    Port ( ALUOp : in  STD_LOGIC_VECTOR (1 downto 0);
           funct : in  STD_LOGIC_VECTOR (5 downto 0);
           Control : out  STD_LOGIC_VECTOR (4 downto 0));
end ALU_Control;

architecture Behavioral of ALU_Control is

begin
	process(ALUOp, funct)
		begin
			case ALUOp is
				when "10" => -- Executing R-instruction
					if funct = "100000" then -- Add funct code
						Control <= "00010"; -- Set ALU to add
					elsif funct = "100010" then -- Sub funct code
						Control <= "00110"; -- Set ALU to sub
					elsif funct = "100100" then -- And funct code
						Control <= "00000"; -- Set ALU to and
					elsif funct = "100101" then -- Or funct code
						Control <= "00001"; -- Set ALU to or
					elsif funct = "100111" then -- Nor funct code
						Control <= "01100"; -- Set ALU to nor
					elsif funct = "101010" then -- Set Less Than funct code
						Control <= "00111"; -- Set ALU to slt
					else -- Performing nop
						Control <= "11111"; -- Value is not defined in ALU,
												  -- will return zero
					end if;
				when "00" => -- Store word, Load Word, or Addi instruction
					Control <= "00010"; -- Need to perform add to address
				when "01" => -- Branch on Equal instruction
					Control <= "00110"; -- Need to subtract to find if equal
				when others =>
					Control <= "11111"; -- Sets control to out of bound bit, resulting
											  -- in zero in ALU
			end case;
	end process;
end Behavioral;

