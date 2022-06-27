library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity flag_setter is
port(
   N :out std_logic;
   C :out std_logic;
   V :out std_logic;
   Z :out std_logic;
   op1: in std_logic_vector(31 downto 0);
   op2: in std_logic_vector(31 downto 0);
   res: in std_logic_vector(31 downto 0);
   S_bit : in std_logic;
   carry_out : in std_logic_vector(0 downto 0);
   clk : in std_logic
);
end flag_setter;


architecture beh_flag_setter of flag_setter is
begin
  process(op1,op2,res,S_bit,  carry_out,clk)
  begin
    if(S_bit= '1') then
      N<= res(31);
      V <= (op1(31) and op2(31) and (not res(31))) or ((not op1(31)) and (not op2(31)) and res(31));
      C <= carry_out(0);
    if(res = X"00000000") then
      Z<= '1';
    else
      Z<= '0';
      end if;
      end if;
  end process;
end beh_flag_setter;
      
      --flag setter stage3