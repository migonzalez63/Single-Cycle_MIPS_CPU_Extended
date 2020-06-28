library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- The Main Control Unit for the CPU. Will let the components know what 
-- to do on each instruction
entity control_unit is
    Port ( opcode, funct : in  STD_LOGIC_VECTOR (5 downto 0);
			  reset: in STD_LOGIC;
           RegDst : out  STD_LOGIC;
           Jump : out  STD_LOGIC;
           Branch : out  STD_LOGIC_VECTOR(1 downto 0);
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUOp : out  STD_LOGIC_VECTOR (1 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
			  stall, mfhi_read, mflo_read : out STD_LOGIC);
end control_unit;

architecture Behavioral of control_unit is

begin

	process(opcode, funct, reset)
		begin
			if (reset = '1') then -- Resets all values to zero
				RegDst <= '0';
				Jump <= '0';
				Branch <= "00";
				MemRead <= '0';
				MemtoReg <= '0';
				ALUOp <= "00";
				MemWrite <= '0';
				ALUSrc <= '0';
				RegWrite <= '0';
				stall <= '0';
				mfhi_read <= '0';
				mflo_read <= '0';
			else
				case opcode is
					when "000000" =>-- R-type Instruction
						case funct is
							when "011000" => -- Multiply Instruction
								RegDst <= '0';
								Jump <= '0';
								Branch <= "00";
								MemRead <= '0';
								MemtoReg <= '0';
								ALUOp <= "11"; -- Don't want our ALU to do an operation on the register values
								MemWrite <= '0';
								ALUSrc <= '0';
								RegWrite <= '0'; 
								stall <= '1'; -- Need to begin stall to perform the multiplication
								mfhi_read <= '0';
								mflo_read <= '0';
							when "010000" => -- mfhi Instruction
								RegDst <= '1'; -- Has a destination register
								Jump <= '0';
								Branch <= "00";
								MemRead <= '0';
								MemtoReg <= '0';
								ALUOp <= "00"; -- Wan't to output the contents of the HILO register 
								MemWrite <= '0';
								ALUSrc <= '0';
								RegWrite <= '1'; -- Will be writing the contents of the HI register into an accessible register 
								stall <= '0'; 
								mfhi_read <= '1'; -- Need to read from HI register
								mflo_read <= '0';
							when "010010" => -- mflo Instruction
								RegDst <= '1'; -- Has a destination register
								Jump <= '0';
								Branch <= "00";
								MemRead <= '0';
								MemtoReg <= '0';
								ALUOp <= "00"; -- Wan't to output the contents of the HILO register
								MemWrite <= '0';
								ALUSrc <= '0';
								RegWrite <= '1'; -- Will be writing the contents of the HI register into an accessible register 
								stall <= '0'; 
								mfhi_read <= '0'; 
								mflo_read <= '1'; -- Need to read from LO register
							when others => -- Regular R instruction such as add or sub.
								RegDst <= '1'; -- Has a dest register
								Jump <= '0';
								Branch <= "00";
								MemRead <= '0';
								MemtoReg <= '0';
								ALUOp <= "10"; -- specefied by book
								MemWrite <= '0';
								ALUSrc <= '0';
								RegWrite <= '1'; -- Need to put answer in register 
								stall <= '0'; 
								mfhi_read <= '0'; 
								mflo_read <= '0';
							end case;
					when "100011" =>-- Load Word
						RegDst <= '0';
						Jump <= '0';
						Branch <= "00";
						MemRead <= '1'; -- Reads content from memory
						MemtoReg <= '1'; -- Puts content in a register
						ALUOp <= "00";
						MemWrite <= '0';
						ALUSrc <= '1'; -- Need to do operation on immediate
						RegWrite <= '1';
						stall <= '0'; 
						mfhi_read <= '0'; 
						mflo_read <= '0';
					when "101011" => -- Store Word
						RegDst <= '0';
						Jump <= '0';
						Branch <= "00";
						MemRead <= '0'; 
						MemtoReg <= '0';
						ALUOp <= "00";
						MemWrite <= '1'; -- Writes contents of register to memory
						ALUSrc <= '1'; -- Need to do operation on immediate
						RegWrite <= '0';
						stall <= '0'; 
						mfhi_read <= '0'; 
						mflo_read <= '0';
					when "000100" => -- Branch on Equal
						RegDst <= '0';
						Jump <= '0';
						Branch <= "11"; -- Branch Flag
						MemRead <= '0'; -- Reads content from memory
						MemtoReg <= '0'; 
						ALUOp <= "01";
						MemWrite <= '0';
						ALUSrc <= '0';
						RegWrite <= '0';
						stall <= '0'; 
						mfhi_read <= '0'; 
						mflo_read <= '0';
					when "000101" => -- Branch on Not Equal
						RegDst <= '0';
						Jump <= '0';
						Branch <= "01"; -- Branch Flag
						MemRead <= '0'; -- Reads content from memory
						MemtoReg <= '0'; 
						ALUOp <= "01";
						MemWrite <= '0';
						ALUSrc <= '0';
						RegWrite <= '0';
						stall <= '0'; 
						mfhi_read <= '0'; 
						mflo_read <= '0';
					when "000010" => -- Jump
						RegDst <= '0';
						Jump <= '1'; -- Performs jumo
						Branch <= "00";
						MemRead <= '0'; 
						MemtoReg <= '0'; 
						ALUOp <= "00";
						MemWrite <= '0';
						ALUSrc <= '0';
						RegWrite <= '0';
						stall <= '0'; 
						mfhi_read <= '0'; 
						mflo_read <= '0';
					when others => -- Add Immediate
						RegDst <= '0';
						Jump <= '0';
						Branch <= "00";
						MemRead <= '0'; 
						MemtoReg <= '0';
						ALUOp <= "00";
						MemWrite <= '0';
						ALUSrc <= '1'; -- Need to do operation on immediate
						RegWrite <= '1'; -- Write back to register 
						stall <= '0'; 
						mfhi_read <= '0'; 
						mflo_read <= '0';
				end case;
			end if;
	end process;	
end Behavioral;

