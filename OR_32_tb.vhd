LIBRARY ieee  ; 
LIBRARY std  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE std.textio.all  ; 
ENTITY OR_32_tb  IS 
END ; 
 
ARCHITECTURE OR_32_tb_arch OF OR_32_tb IS
  SIGNAL A_or   :  std_logic_vector (31 downto 0)  ; 
  SIGNAL Z_or   :  std_logic_vector (31 downto 0)  ; 
  SIGNAL B_or   :  std_logic_vector (31 downto 0)  ; 
  COMPONENT OR_32  
    PORT ( 
      A_or  : in std_logic_vector (31 downto 0) ; 
      Z_or  : out std_logic_vector (31 downto 0) ; 
      B_or  : in std_logic_vector (31 downto 0) ); 
  END COMPONENT ; 
BEGIN
  DUT  : OR_32  
    PORT MAP ( 
      A_or   => A_or  ,
      Z_or   => Z_or  ,
      B_or   => B_or   ) ; 



-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 A_or  <= "00000000000000000001011010011010"  ;
	wait for 1 ns ;
-- dumped values till 1 ns
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 B_or  <= "00000000000000000001101011011010"  ;
	wait for 1 ns ;
-- dumped values till 1 ns
	wait;
 End Process;
END;
