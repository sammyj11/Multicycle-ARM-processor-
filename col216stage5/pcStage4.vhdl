library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity PC is
port(
  clk : in std_logic;
  psrc :  in std_logic;
  reset : in std_logic;
   offset : in std_logic_vector (23 downto 0); 
  oute : inout std_logic_vector(31 downto 0);
  PW: in std_logic;
  res1:in  std_logic_vector(31 downto 0)
);
end PC;

architecture beh_PC of PC is
signal sign_ext : std_logic_vector(5 downto 0);
begin
  process(clk,psrc,reset,offset)
  begin
    sign_ext <= "111111" when offset(23) = '1' else "000000";

    if(reset = '1')  then oute <= X"00000040";
  end if;
  if(rising_edge(clk)) then
  if(PW = '1') then
  oute <= res1( 29 downto 0 ) &"00";
  end if;
  end if;
  end process;
end beh_PC;

--final PC stage 3