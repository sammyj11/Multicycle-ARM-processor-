library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.MyTypes.all;


entity shifter is
port( 
   shift : in std_logic_vector(4 downto 0);
  inputRec : in std_logic_vector(31 downto 0 );
  instruction : in std_logic_vector(31 downto 0);
  carry_out5 : out std_logic_vector(0 downto 0);
  rorCheck : in std_logic;
  outputt : out std_logic_vector(31 downto 0);


);

end entity;

architecture beh_shifter of shifter is 


signal  carry1 :  std_logic;
signal  carry2 :  std_logic;
signal  carry3 :  std_logic;
signal  carry4 :  std_logic;
signal  carry5 :  std_logic;
signal inpout2 : std_logic_vector(31 downto 0);
signal inpout3 : std_logic_vector(31 downto 0);
signal inpout4 : std_logic_vector(31 downto 0);
signal inpout5 : std_logic_vector(31 downto 0);



begin
  
  
  inpout2 <= inputRec(0) & inputRec(31 downto 1)   when rorCheck = '1' and shift(0)= '1' else
             inputRec(30 downto 0) & "0" when  instruction(6 downto 5) = "00" and shift(0)= '1' else
             inputRec(31 downto 0) when  instruction(6 downto 5) = "00" and shift(0)= '0' else
             "0" & inputRec(31 downto 1)   when  instruction(6 downto 5) = "01" and shift(0)= '1' else
             inputRec(31 downto 0)   when  instruction(6 downto 5) = "01" and shift(0)= '0' else
             "0" & inputRec(31 downto 1)   when  instruction(6 downto 5) = "10" and shift(0)= '1' and inputRec(31) = '0' else
             "1"& inputRec(31 downto 1)   when  instruction(6 downto 5) = "10" and shift(0)= '1' and inputRec(31) = '1' else
             inputRec(0) & inputRec(31 downto 1)   when  instruction(6 downto 5) = "11" and shift(0)= '1'  else
               inputRec(31 downto 0);

 inpout3 <=  inpout2(1 downto 0) & inpout2(31 downto 2)   when rorCheck = '1' and shift(1)= '1' else
             inpout2(29 downto 0) & "00" when  instruction(6 downto 5) = "00" and shift(1)= '1' else
             inpout2(31 downto 0) when  instruction(6 downto 5) = "00" and shift(1)= '0' else
             "00" & inpout2(31 downto 2)   when  instruction(6 downto 5) = "01" and shift(1)= '1' else
             inpout2(31 downto 0)   when  instruction(6 downto 5) = "01" and shift(1)= '0' else
             "00" & inpout2(31 downto 2)   when  instruction(6 downto 5) = "10" and shift(1)= '1' and inpout2(31) = '0' else
             "11" &inpout2(31 downto 2)   when  instruction(6 downto 5) = "10" and shift(1)= '1' and inpout2(31) = '1' else
             inpout2(1 downto 0) & inpout2(31 downto 2)   when  instruction(6 downto 5) = "11" and shift(1)= '1'  else
               inpout2(31 downto 0);
        
 inpout4 <=   inpout3(3 downto 0) & inpout3(31 downto 4)   when rorCheck = '1' and shift(2)= '1' else
             inpout3(27 downto 0) & "0000" when  instruction(6 downto 5) = "00" and shift(2)= '1' else
             inpout3(31 downto 0) when  instruction(6 downto 5) = "00" and shift(2)= '0' else
             "0000" & inpout3(31 downto 4)   when  instruction(6 downto 5) = "01" and shift(2)= '1' else
             inpout3(31 downto 0)   when  instruction(6 downto 5) = "01" and shift(2)= '0' else
             "0000" & inpout3(31 downto 4)   when  instruction(6 downto 5) = "10" and shift(2)= '1' and inpout3(31) = '0' else
             "1111"& inpout3(31 downto 4)   when  instruction(6 downto 5) = "10" and shift(2)= '1' and inpout3(31) = '1' else
             inpout3(3 downto 0) & inpout3(31 downto 4)   when  instruction(6 downto 5) = "11" and shift(2)= '1'  else
               inpout3(31 downto 0);

 inpout5 <=  inpout4(7 downto 0) & inpout4(31 downto 8)   when rorCheck = '1' and shift(3)= '1' else
             inpout4(23 downto 0) & "00000000" when  instruction(6 downto 5) = "00" and shift(3)= '1' else
             inpout4(31 downto 0) when  instruction(6 downto 5) = "00" and shift(3)= '0' else
             "00000000" & inpout4(31 downto 8)   when  instruction(6 downto 5) = "01" and shift(3)= '1' else
             inpout4(31 downto 0)   when  instruction(6 downto 5) = "01" and shift(3)= '0' else
             "00000000" & inpout4(31 downto 8)   when  instruction(6 downto 5) = "10" and shift(3)= '1' and inpout4(31) = '0' else
             "11111111"& inpout4(31 downto 8)   when  instruction(6 downto 5) = "10" and shift(3)= '1' and inpout4(31) = '1' else
             inpout4(7 downto 0) & inpout4(31 downto 8)   when  instruction(6 downto 5) = "11" and shift(3)= '1'  else
             inpout4(31 downto 0);


 outputt <=  inpout5(15 downto 0) & inpout5(31 downto 16) when rorCheck = '1' and shift(4)= '1' else
             inpout5(15 downto 0) & "0000000000000000" when  instruction(6 downto 5) = "00" and shift(4)= '1' else
             inpout5(31 downto 0) when  instruction(6 downto 5) = "00" and shift(4)= '0' else
             "0000000000000000" & inpout5(31 downto 16)   when  instruction(6 downto 5) = "01" and shift(4)= '1' else
             inpout5(31 downto 0)   when  instruction(6 downto 5) = "01" and shift(4)= '0' else
             "0000000000000000" & inpout5(31 downto 16)   when  instruction(6 downto 5) = "10" and shift(4)= '1' and inpout5(31) = '0' else
             "1111111111111111"& inpout5(31 downto 16)   when  instruction(6 downto 5) = "10" and shift(4)= '1' and inpout5(31) = '1' else
             inpout5(15 downto 0) & inpout5(31 downto 16)   when  instruction(6 downto 5) = "11" and shift(4)= '1'  else
             inpout5(31 downto 0);
  
  carry1 <= '0' when rorCheck = '1' and shift(0)= '1' and  inputRec(0 downto 0) = "0" else
  '1' when rorCheck = '1' and shift(0)= '1' and  inputRec(0 downto 0) = "1" else 
  '0' when instruction(6 downto 5) = "11" and shift(0)= '1' and  inputRec(0 downto 0) = "0" else
  '1' when instruction(6 downto 5) = "11" and shift(0)= '1' and  inputRec(0 downto 0) = "1" else
  '0' when instruction(6 downto 5) = "00" and inputRec(31 downto 31) = "0" and shift(0)= '1' else
  '1' when instruction(6 downto 5) = "00" and inputRec(31 downto 31) = "1" and shift(0)= '1' else
  '0' when instruction(6 downto 5) = "01" and inputRec(0 downto 0) = "0" and shift(0)= '1' else
  '1' when instruction(6 downto 5) = "01" and inputRec(0 downto 0) = "1" and shift(0)= '1' else
  '0' when instruction(6 downto 5) = "10" and inputRec(0 downto 0) = "0" and shift(0)= '1' else
  '1' when instruction(6 downto 5) = "10" and inputRec(0 downto 0) = "1" and shift(0)= '1' else
  '0';
  
  carry2 <= '0' when rorCheck = '1' and shift(1)= '1' and  inputRec(1 downto 1) = "0" else
  '1' when  rorCheck = '1' and shift(1)= '1' and  inputRec(1 downto 1) = "1" else
  '0' when instruction(6 downto 5) = "11" and shift(1)= '1' and  inputRec(1 downto 1) = "0" else
  '1' when instruction(6 downto 5) = "11" and shift(1)= '1' and  inputRec(1 downto 1) = "1" else
  '0' when instruction(6 downto 5) = "00" and inpout2(30 downto 30) = "0" and shift(1)= '1' else
  '1' when instruction(6 downto 5) = "00" and inpout2(30 downto 30) = "1" and shift(1)= '1' else
  '0' when instruction(6 downto 5) = "01" and inpout2(1 downto 1) = "0" and shift(1)= '1' else
  '1' when instruction(6 downto 5) = "01" and inpout2(1 downto 1) = "1" and shift(1)= '1' else
  '0' when instruction(6 downto 5) = "10" and inpout2(1 downto 1) = "0" and shift(1)= '1' else
  '1' when instruction(6 downto 5) = "10" and inpout2(1 downto 1) = "1" and shift(1)= '1' else
  carry1;
  
  carry3 <= '0' when rorCheck = '1' and shift(2)= '1' and  inputRec(3 downto 3) = "0" else
  '1' when rorCheck = '1' and shift(2)= '1' and  inputRec(3 downto 3) = "1" else
  '0' when instruction(6 downto 5) = "11" and shift(2)= '1' and  inputRec(3 downto 3) = "0" else
  '1' when instruction(6 downto 5) = "11" and shift(2)= '1' and  inputRec(3 downto 3) = "1" else
  '0' when instruction(6 downto 5) = "00" and inpout3(28 downto 28) = "0" and shift(2)= '1' else
  '1' when instruction(6 downto 5) = "00" and inpout3(28 downto 28) = "1" and shift(2)= '1' else
  '0' when instruction(6 downto 5) = "01" and inpout3(3 downto 3) = "0" and shift(2)= '1' else
  '1' when instruction(6 downto 5) = "01" and inpout3(3 downto 3) = "1" and shift(2)= '1' else
  '0' when instruction(6 downto 5) = "10" and inpout3(3 downto 3) = "0" and shift(2)= '1' else
  '1' when instruction(6 downto 5) = "10" and inpout3(3 downto 3) = "1" and shift(2)= '1' else
  carry2;
  
  carry4 <= '0' when  rorCheck = '1' and shift(3)= '1' and  inputRec(7 downto 7) = "0" else
  '1' when   rorCheck = '1' and shift(3)= '1' and  inputRec(7 downto 7) = "1" else
  '0' when instruction(6 downto 5) = "11" and shift(3)= '1' and  inputRec(7 downto 7) = "0" else
  '1' when instruction(6 downto 5) = "11" and shift(3)= '1' and  inputRec(7 downto 7) = "1" else
  '0' when instruction(6 downto 5) = "00" and inpout4(24 downto 24) = "0" and shift(3)= '1' else
  '1' when instruction(6 downto 5) = "00" and inpout4(24 downto 24) = "1" and shift(3)= '1' else
  '0' when instruction(6 downto 5) = "01" and inpout4(7 downto 7) = "0" and shift(3)= '1' else
  '1' when instruction(6 downto 5) = "01" and inpout4(7 downto 7) = "1" and shift(3)= '1' else
  '0' when instruction(6 downto 5) = "10" and inpout4(7 downto 7) = "0" and shift(3)= '1' else
  '1' when instruction(6 downto 5) = "10" and inpout4(7 downto 7) = "1" and shift(3)= '1' else
  carry3;

   carry5 <= '0' when rorCheck = '1' and shift(4)= '1' and  inputRec(15 downto 15) = "0" else
  '1' when rorCheck = '1' and shift(4)= '1' and  inputRec(15 downto 15) = "1" else
   '0' when instruction(6 downto 5) = "11" and shift(4)= '1' and  inputRec(15 downto 15) = "0" else
  '1' when instruction(6 downto 5) = "11" and shift(4)= '1' and  inputRec(15 downto 15) = "1" else
  '0' when instruction(6 downto 5) = "00" and inpout4(16 downto 16) = "0" and shift(4)= '1' else
  '1' when instruction(6 downto 5) = "00" and inpout4(16 downto 16) = "1" and shift(4)= '1' else
  '0' when instruction(6 downto 5) = "01" and inpout4(15 downto 15) = "0" and shift(4)= '1' else
  '1' when instruction(6 downto 5) = "01" and inpout4(15 downto 15) = "1" and shift(4)= '1' else
  '0' when instruction(6 downto 5) = "10" and inpout4(15 downto 15) = "0" and shift(4)= '1' else
  '1' when instruction(6 downto 5) = "10" and inpout4(15 downto 15) = "1" and shift(4)= '1' else
  carry4;
  
  carry_out5(0) <= carry5;


    
  
  
  
end beh_shifter;


--functional hai
