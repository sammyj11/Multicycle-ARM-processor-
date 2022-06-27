library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.MyTypes.all;

entity cond_checker is
port(
 N_in :in std_logic;
   C_in :in std_logic;
   V_in :in std_logic;
   Z_in :in std_logic;
  cond :in std_logic_vector(3 downto 0);
  cond_out : out std_logic
);
end cond_checker;

architecture beh_cond_checker of cond_checker is
begin
  process( N_in,C_in,V_in,Z_in, cond)
  begin
     if(cond = "0000") then
      if(Z_in = '1') then
        cond_out <= '1';
       else 
cond_out <= '0';  
    end if;
      elsif(cond = "0001") then
       if(Z_in = '0') then
cond_out <= '1';
    else
cond_out <= '0';
    end if;
    elsif(cond = "1110") then
    cond_out <= '1';
      end if;
  end process;
end beh_cond_checker;

--cond checker
