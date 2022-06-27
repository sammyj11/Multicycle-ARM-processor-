library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.MyTypes.all;


entity data_memory is 
 port(
   data_in : in std_logic_vector(31 downto 0);
   read_address : in std_logic_vector(6 downto 0);
    write_e : in std_logic_vector(3 downto 0);
   clk : in std_logic;
    data_out : out std_logic_vector(31 downto 0)
       );
end entity;


architecture beh_DM of data_memory is
type MEM is array (127 downto 0) of std_logic_vector(31 downto 0);
signal reg_mem : MEM := (0 => X"00000000",
1 => X"00000000",
2 =>X"00000000",
3 => X"00000000",
4 => X"00000000",
5 =>X"00000000",
6 => X"00000000",
7 => X"00000000",
             64 => X"E3A00002",
        68 => X"E3A01003",
        72 => X"E1510000",
        76 => X"12800001",
         80=> X"E1500001",
         84 => X"00400001",


others => X"00000000"
);

signal addr1 : integer range 0 to 127;


begin
    addr1 <= conv_integer(read_address);
    data_out <= reg_mem(addr1);
    
  process(clk, data_in,read_address, write_e)
  begin
   
    if(rising_edge(clk) ) then
      if(write_e(0) = '1') then
        reg_mem(addr1)(7 downto 0) <= data_in(7 downto 0);
  end if;
      if(write_e(1) = '1') then
        reg_mem(addr1)(15 downto 8) <= data_in(15 downto 8);
  end if;
  if(write_e(2) = '1') then
        reg_mem(addr1)(23 downto 16) <= data_in(23 downto 16);
  end if;
  if(write_e(3) = '1') then
        reg_mem(addr1)(31 downto 24) <= data_in(31 downto 24);
  end if;
    end if;
      end process;
      end beh_DM;

--data mem final