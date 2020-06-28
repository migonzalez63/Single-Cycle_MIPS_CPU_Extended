LIBRARY ieee  ; 
LIBRARY std  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE std.textio.all  ; 
ENTITY ALU_tb  IS 
END ; 
 
ARCHITECTURE ALU_tb_arch OF ALU_tb IS
  SIGNAL E   :  STD_LOGIC  ; 
  SIGNAL A   :  std_logic_vector (31 downto 0)  ; 
  SIGNAL R   :  std_logic_vector (31 downto 0)  ; 
  SIGNAL B   :  std_logic_vector (31 downto 0)  ; 
  SIGNAL C   :  std_logic_vector (4 downto 0)  ; 
  COMPONENT ALU  
    PORT ( 
      E  : out STD_LOGIC ; 
      A  : in std_logic_vector (31 downto 0) ; 
      R  : out std_logic_vector (31 downto 0) ; 
      B  : in std_logic_vector (31 downto 0) ; 
      C  : in std_logic_vector (4 downto 0) ); 
  END COMPONENT ; 
BEGIN
  DUT  : ALU  
    PORT MAP ( 
      E   => E  ,
      A   => A  ,
      R   => R  ,
      B   => B  ,
      C   => C   ) ; 



-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 A  <= "00000011110101110111110101110111"  ;
	wait for 1 ns ;
-- dumped values till 1 ns
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 B  <= "00011110111101010011110101011100"  ;
	wait for 1 ns ;
-- dumped values till 1 ns
	wait;
 End Process;


-- "Counter Pattern"(Range-Up) : step = 1 Range(00000-01111)
-- Start Time = 0 ps, End Time = 1 ns, Period = 50 ps
  Process
	variable VARC  : std_logic_vector (4 downto 0);
	Begin
	VARC  := "00000" ;
	for repeatLength in 1 to 16
	loop
	    C  <= VARC  ;
	   wait for 50 ps ;
	   VARC  := VARC  + 1 ;
	end loop;
-- 800 ps, repeat pattern in loop.
	VARC  := "00000" ;
	for repeatLength in 1 to 4
	loop
	    C  <= VARC  ;
	   wait for 50 ps ;
	   VARC  := VARC  + 1 ;
	end loop;
-- 1 ns, periods remaining till edit start time.
	wait;
 End Process;
END;
