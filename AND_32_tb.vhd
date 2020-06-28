LIBRARY ieee  ; 
LIBRARY std  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_textio.all  ; 
USE ieee.std_logic_unsigned.all  ; 
USE std.textio.all  ; 
ENTITY AND_32_tb  IS 
END ; 
 
ARCHITECTURE AND_32_tb_arch OF AND_32_tb IS
  SIGNAL Z_and   :  std_logic_vector (31 downto 0)  ; 
  SIGNAL B_and   :  std_logic_vector (31 downto 0)  ; 
  SIGNAL A_and   :  std_logic_vector (31 downto 0)  ; 
  COMPONENT AND_32  
    PORT ( 
      Z_and  : out std_logic_vector (31 downto 0) ; 
      B_and  : in std_logic_vector (31 downto 0) ; 
      A_and  : in std_logic_vector (31 downto 0) ); 
  END COMPONENT ; 
BEGIN
  DUT  : AND_32  
    PORT MAP ( 
      Z_and   => Z_and  ,
      B_and   => B_and  ,
      A_and   => A_and   ) ; 



-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 A_and  <= "00000000000000000001101010111101"  ;
	wait for 1 ns ;
-- dumped values till 1 ns
	wait;
 End Process;


-- "Constant Pattern"
-- Start Time = 0 ps, End Time = 1 ns, Period = 0 ps
  Process
	Begin
	 B_and  <= "00000000000000000001011011010110"  ;
	wait for 1 ns ;
-- dumped values till 1 ns
	wait;
 End Process;
END;
