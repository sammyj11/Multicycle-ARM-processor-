library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity register_file is 
 port(
   data_in : in std_logic_vector(31 downto 0);
   read_address_f : in std_logic_vector(3 downto 0);
       read_address_s : in std_logic_vector(3 downto 0);
   write_address : in std_logic_vector(3 downto 0);
       write_e : in std_logic;
   clk : in std_logic;
       data_out_f : out std_logic_vector(31 downto 0);
    data_out_s : out std_logic_vector(31 downto 0)
       );
end entity;
  

architecture beh_reg of register_file is
type MEM is array (15 downto 0) of std_logic_vector(31 downto 0);
signal reg_mem : MEM := (others => x"00000000");
signal addr1 : integer range 0 to 15;
signal addr2 : integer range 0 to 15;
signal addrw : integer range 0 to 15;


begin
    addr1 <= conv_integer(read_address_f);
    addr2 <= conv_integer(read_address_s);
    addrw <= conv_integer(write_address);
    data_out_f <= reg_mem(addr1);
    data_out_s <= reg_mem(addr2);
  process(clk, data_in,write_address,read_address_f, read_address_s, write_e)
  begin

    
    if(rising_edge(clk)) then
      if(write_e = '1') then
        reg_mem(addrw) <= data_in;
  end if;
    end if;
      end process;
      end beh_reg;
    
-- register file final
