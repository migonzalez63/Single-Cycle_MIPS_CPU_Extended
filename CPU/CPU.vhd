library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity CPU is
    Port ( main_clk : in  STD_LOGIC;
           main_reset : in  STD_LOGIC;
			  Instruction: out STD_LOGIC_VECTOR (31 downto 0);
			  PC_out: out STD_LOGIC_VECTOR(31 downto 0);
			  ALU_result: out STD_LOGIC_VECTOR (31 downto 0));
end CPU;

architecture Behavioral of CPU is

-- PC used to perform instructions
component program_counter is
    Port ( clk, reset : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (31 downto 0);
           data_out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- ALU used to perform operations on registers and addresses
component ALU is
    Port ( A, B : in  STD_LOGIC_VECTOR (31 downto 0);
           C : in  STD_LOGIC_VECTOR (4 downto 0);
           R : out  STD_LOGIC_VECTOR (31 downto 0);
           E : out  STD_LOGIC);
end component;

-- Instruction Memory used to store the program
component instr_mem is
    Port ( addr : in  STD_LOGIC_VECTOR (31 downto 0);
			  enable : in STD_LOGIC;
           instruction : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Data Memory used to store data from registers
component mem is
    Port ( clk, reset : in  STD_LOGIC;
           addr, data_in : in  STD_LOGIC_VECTOR (31 downto 0);
           write_enable : in  STD_LOGIC;
           read_enable : in  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Register file used to store the CPU's registers data
component registers is
    Port ( read_regi1, read_regi2 , write_register : in  STD_LOGIC_VECTOR (4 downto 0);
           write_data, mfhi, mflo : in  STD_LOGIC_VECTOR (31 downto 0);
           read_data1, read_data2 : out  STD_LOGIC_VECTOR (31 downto 0);
           regi_write, clk, reset, m_write, mfhi_read, mflo_read : in  STD_LOGIC);
end component;

-- Sign extender used to extend the signs of immediate values
component sign_extender_16to32 is
    Port ( a_16 : in  STD_LOGIC_VECTOR (15 downto 0);
           z : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Multiplexer
component Multiplexer_2to1 is
    Port ( First_input : in  STD_LOGIC_VECTOR (31 downto 0);
           Second_input : in  STD_LOGIC_VECTOR (31 downto 0);
           Selector : in  STD_LOGIC;
           Mux_out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Main Control Unit that will let us know what operations to
-- perform on th registers
component control_unit is
    Port ( opcode, funct : in  STD_LOGIC_VECTOR (5 downto 0);
			  reset: in STD_LOGIC;
           RegDst : out  STD_LOGIC;
           Jump : out  STD_LOGIC;
           Branch : out  STD_LOGIC_VECTOR (1 downto 0);
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUOp : out  STD_LOGIC_VECTOR (1 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
			  stall, mfhi_read, mflo_read : out STD_LOGIC);
end component;

-- ALU Control Unit that specifies what operation to set on our ALU 
component ALU_Control is
    Port ( ALUOp : in  STD_LOGIC_VECTOR (1 downto 0);
           funct : in  STD_LOGIC_VECTOR (5 downto 0);
           Control : out  STD_LOGIC_VECTOR (4 downto 0));
end component;

-- Used to determine what branch function we need to execute
component Branch_Funct is
    Port ( Branch_op : in  STD_LOGIC_VECTOR (1 downto 0);
           Zero : in  STD_LOGIC;
           branch_ex : out  STD_LOGIC);
end component;

component Mult_Unit is
    Port ( regi_1, regi_2 : in  STD_LOGIC_VECTOR (31 downto 0);
           stall, reset, clk : in  STD_LOGIC;
           mfhi_main, mflo_main : out  STD_LOGIC_VECTOR (31 downto 0);
           enable, m_write : out  STD_LOGIC);
end component;

-- Signals used to determine the state of PC.
signal Current_PC, New_PC, Next_PC, Jump_PC: STD_LOGIC_VECTOR (31 downto 0);

-- Output signals for the top-level components
signal instruct_out, regi_out, ALU_out, data_mem_out: STD_LOGIC_VECTOR (31 downto 0);

-- Signal that sets the ALU to a specified mode
signal ALU_C: STD_LOGIC_VECTOR (4 downto 0);

-- Outputs of the Multiplexers
-- Will be used as inputs for other components
signal Branch_PC, write_regi, ALU_A, ALU_B, sign_ext_out, mem_out: STD_LOGIC_VECTOR (31 downto 0);

-- Addreses that will help determine the next PC if a jump or beq instruction was called
signal branch_addr: STD_LOGIC_VECTOR (31 downto 0);
signal jump_addr: STD_LOGIC_VECTOR (27 downto 0);

-- Signal for a shifted version of sign_ext_out;
signal shift_sign_ext: STD_LOGIC_VECTOR (31 downto 0);

-- Signal used to determine if we need to execute one of our branch intructions
signal branch_ex: STD_LOGIC;

-- Control signals that will determine what each top-level module should be doing in
-- order to execute the proper instructions
signal regdest, jump, memread, memtoreg, memwrite, alusrc, regwrite: STD_LOGIC;
signal branch, aluop: STD_LOGIC_VECTOR (1 downto 0);

-- Signal that will be passed along if ALU gives a zero result.
-- Used to determine if beq will execute or not
signal Zero: STD_LOGIC;

-- Signal to begin stall for multiplication instruction
signal begin_stall: STD_LOGIC;

-- Signal to transfer data of hi and lo registers from Mult_unit to registers
signal mfhi, mflo: STD_LOGIC_VECTOR (31 downto 0);

-- 
signal write_regi_in1, write_regi_in2: STD_LOGIC_VECTOR (31 downto 0);

-- Signals used in order to see if we must write into the special HILO registers or 
-- read from them
signal m_write, mfhi_read, mflo_read: STD_LOGIC;

-- Signal used in order to enable or disable components of the CPU during a stall
signal enable: STD_LOGIC;

signal PC_Add: STD_LOGIC_VECTOR (31 downto 0);

begin
	
	-- Passes along a the address for the program
	PC: program_counter port map(clk => main_clk,
											reset => main_reset,
											data_in => Next_PC,
											data_out => Current_PC);
											
	PC_Add <= X"00000004" when enable = '1' else X"00000000";
	
	-- Gets the next address
	PC_Plus_4: ALU port map(A => Current_PC,
									B => PC_Add,
									C => "00010",
									R => New_PC); 
	
	-- Gets the current address and gives us the instruction at that address
	Instruction_Memory: instr_mem port map( addr => Current_PC,
														 enable => enable,
														 instruction => instruct_out);
	
	-- Calculates the jump address by first shifting the immediate value of the isntruction by two
	jump_addr <= "00" & STD_LOGIC_VECTOR(shift_left(unsigned(instruct_out(25 downto 0)), 2));
	
	-- Then we concatonate the top 4 bits from the program counter to the address
	Jump_PC <=  New_PC (31 downto 28) & jump_addr;
	
	-- Using the opcode from the instructions, will determine what signals to send
	-- to each component
	Main_Control: control_unit port map(opcode => instruct_out (31 downto 26),
													funct => instruct_out (5 downto 0),
													reset => main_reset,
													RegDst => regdest,
													Jump => jump,
													Branch => branch,
													MemRead => memread,
													MemtoReg => memtoreg,
													ALUOp => aluop,
													Memwrite => memwrite,
													ALUSrc => alusrc,
													Regwrite => regwrite,
													stall => begin_stall,
													mfhi_read => mfhi_read,
													mflo_read => mflo_read);
	
	-- Converts 5 bit register value into 32 bit
	write_regi_in1 <= "000000000000000000000000000" & instruct_out (20 downto 16);
	write_regi_in2 <= "000000000000000000000000000" & instruct_out (15 downto 11);
	
	-- Depending on signal, we will either be using RD or RS in order to put in our result in
	Write_Regi_MUX: Multiplexer_2to1 port map(First_Input => write_regi_in1,
															Second_Input => write_regi_in2,
															Selector => regdest,
															Mux_out => write_regi);
	
		
	-- Gets the given registers and outputs its contents in order to perform an opertaion on
	Register_File: registers port map(clk => main_clk,
												 reset => main_reset,
												 regi_write => regwrite,
												 mfhi_read => mfhi_read,
												 mflo_read => mflo_read,
												 read_regi1 => instruct_out(25 downto 21),
								             read_regi2 => instruct_out(20 downto 16),
												 write_register => write_regi(4 downto 0),
												 write_data => mem_out,
												 read_data1 => ALU_A,
												 read_data2 => regi_out,
												 mfhi => mfhi,
												 mflo => mflo,
												 m_write => m_write);
												 
	 
	
	-- Extends a 16 bit immediate value into 32 bits	
	Sign_Extender: sign_extender_16to32 port map(a_16 => instruct_out (15 downto 0),
																z => sign_ext_out);
	
	-- Shifts the shifted value by 2 to be used in calculating the branch address
	shift_sign_ext <= STD_LOGIC_VECTOR(shift_left(unsigned(sign_ext_out), 2));
	
	-- Will determine whether to use Immediate value or register content in order to perfomr
	-- the operation 
	ALU_B_MUX: Multiplexer_2to1 port map(First_Input => regi_out,
													 Second_Input => sign_ext_out,
													 Selector => alusrc,
													 Mux_out => ALU_B);
	
	-- Calculates the branch address
	Branch_Adder: ALU port map(A => New_PC,
									  B => shift_sign_ext, 
									  C => "00010",
									  R => branch_addr);
	
	-- Checks to see if the conditions for our branch are met
	Branch_Functionality: Branch_Funct port map(Branch_Op => branch,
															  Zero => Zero,
															  branch_ex => branch_ex);
	
	-- Depending on signal, will determine if the new PC will be the next address
	-- or if we will use our branch addres
	Branch_MUX: Multiplexer_2to1 port map(First_input => New_PC,
													  Second_input => branch_addr,
													  Selector => branch_ex,
													  Mux_out => Branch_PC);
	
	-- Depending on signal, will determine if we will perform a jump or just use the next PC address
	PC_MUX: Multiplexer_2to1 port map(First_input => Branch_PC,
												 Second_input => Jump_PC,
												 Selector => jump,
												 Mux_out => Next_PC);
	
	-- Manages the control input for the ALU depending on the funct code from the instruction and ALUop
	Main_ALU_Control: ALU_Control port map(ALUOp => aluop,
														funct => instruct_out (5 downto 0),
														Control => ALU_C);
	
	-- Performs operations in values  using the control input to determine what operation to use
	Main_ALU: ALU port map(A => ALU_A,
								  B => ALU_B,
								  C => ALU_C,
								  R => ALU_out,
								  E => Zero);
	
	-- Manages the data in memory to be accessed through sw or lw instructions
	Data_Memory: mem port map(clk => main_clk,
									  reset => main_reset,
									  addr => ALU_out,
									  data_in => regi_out,
									  write_enable => memwrite,
									  read_enable => memread,
									  data_out => data_mem_out);
	
	-- Will determine if we need to output the data in memory or just the ALU output
	Data_Mem_MUX: Multiplexer_2to1 port map(First_input => ALU_out,
														 Second_input => data_mem_out,
														 Selector => memtoreg,
														 Mux_out => mem_out);
														 
	Multiplier_Unit: Mult_Unit port map(regi_1 => ALU_A,
													regi_2 => regi_out,
													stall => begin_stall,
													clk => main_clk,
													reset => main_reset,
													mfhi_main => mfhi,
													mflo_main => mflo,
													enable => enable,
													m_write => m_write);
													 

	 	
	Instruction <= instruct_out;
	PC_out <= Current_PC;
	ALU_result <= ALU_out;
														 								 
end Behavioral;

