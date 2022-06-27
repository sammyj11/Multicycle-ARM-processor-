-- Simple ALU 
library IEEE;
use IEEE.std_logic_1164.all;
use work.MyTypes.all;

use IEEE.numeric_std.all;
 







entity ALU is
port (
a : in std_logic_vector(31 downto 0);
b : in std_logic_vector(31 downto 0);
Sel : in std_logic_vector(3 downto 0);
carry_in : in std_logic_vector(0 downto 0);
carry_out :out std_logic_vector(0 downto 0);
result : out std_logic_vector(31 downto 0)
);
end ALU;

architecture ALU_beh of ALU is 
signal x1: std_logic;
signal x2: std_logic;
signal check: std_logic_vector(32 downto 0);
signal check1: std_logic_vector(32 downto 0);
begin
x1 <= '0';
x2 <= '0' ;

process(a,b,Sel,carry_in)
variable result_full: std_logic_vector(32 downto 0);

begin
check <= result_full;
check1 <= std_logic_vector(signed(not(x1&b)) + signed(x1&a));
case Sel is
when "0000" =>       -- and implement
result <= a and b;
carry_out <= carry_in;

when "0001" =>        -- xor implement
result <=  a xor b ;
carry_out <= carry_in;

when "0010" =>        -- sub implement
  result_full  := std_logic_vector(signed(x1&a)-signed(x2&b));
  result <= std_logic_vector(result_full(31 downto 0));
  carry_out <= std_logic_vector(result_full(32 downto 32));

when "0011" =>      -- rsb implement
  result_full  := std_logic_vector(signed(b)-signed(x1&a));
  result <= std_logic_vector(result_full(31 downto 0));
  carry_out <= std_logic_vector(result_full(32 downto 32));

when "0100" =>          -- add implement
  result_full  := std_logic_vector(signed(x1&a)+signed(x2&b));
  result <= std_logic_vector(result_full(31 downto 0));
  carry_out <= std_logic_vector(result_full(32 downto 32));

when  "0101" =>          -- adc implement
  result_full  := std_logic_vector(unsigned(x1&a)+ unsigned(x2&b)+ unsigned(carry_in));
  result <= std_logic_vector(result_full(31 downto 0));
  carry_out <= std_logic_vector(result_full(32 downto 32));  

when "0110" =>         --sbc
  result_full  := std_logic_vector(unsigned(x1&a)+ unsigned(x2&(not(b)))+ unsigned(carry_in));
  result <= std_logic_vector(result_full(31 downto 0));
  carry_out <= std_logic_vector(result_full(32 downto 32));     -- to assign


when "0111" =>      --rsc
    result_full  := std_logic_vector(unsigned(x2&b)+ unsigned(x2&(not(a))) + unsigned(carry_in));
  result <= std_logic_vector(result_full(31 downto 0));
  carry_out <= std_logic_vector(result_full(32 downto 32));    --to assign

when "1000" =>     --tst
result <=  a and b;
carry_out <= std_logic_vector(result_full(32 downto 32)); 

when "1001" =>  --teq
result <= a xor b;
carry_out <= std_logic_vector(result_full(32 downto 32)); 

when "1010"=>   --cmp
 result_full  := std_logic_vector(signed(x1&a) + signed(x2&(not(b))) + 1);
  result <= std_logic_vector(result_full(31 downto 0));
  carry_out <= std_logic_vector(result_full(32 downto 32)); 

when "1011"=> --cmn
  result_full  := std_logic_vector(signed(x1&a)+signed(x2&b));
  result <= std_logic_vector(result_full(31 downto 0));
 carry_out <= std_logic_vector(result_full(32 downto 32)); 

when "1100" => --orr
result <= a or b        ;
carry_out <=  carry_in     ;

when "1101"=> --mov
result <=    b     ;
carry_out <=  carry_in  ;

when "1110"=>        --bic
result <= a and not(b)        ;
carry_out <= carry_in   ;

when "1111"=>             --mvn
result <=    not(b)     ;
carry_out <=  carry_in   ;
 when others => 
        result <= (others => 'X');

  end case;
  
  end process;
  end ALU_beh;

--alu final