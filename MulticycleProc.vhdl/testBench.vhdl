
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity tb_proc is

end entity;

architecture beh_tb_proc of tb_proc is 

component procc
port (
clk: in std_logic;
resete: in std_logic
);
end component;

--inputs
signal clk : std_logic := '0';
signal resete : std_logic := '1';


begin
uut: procc port map(

  clk => clk,
resete => resete
);

  process is 
begin


wait for 3ns;
clk <= '1';
  wait for 2ns;
  resete <= '0';

 for i in 0 to 200 loop
   clk <= not clk;
  wait for 2ns;
    end loop;
  
  wait;
    end process;
end;

--tb final
