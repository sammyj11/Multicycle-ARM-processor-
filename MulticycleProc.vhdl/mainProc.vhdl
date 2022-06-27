USE work.MyTypes.ALL;

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD_UNSIGNED.ALL;

ENTITY procc IS
  PORT (

    clk : IN STD_LOGIC;
    resete : IN STD_LOGIC
  );
END procc;

ARCHITECTURE beh_proc OF procc IS

  -- ALU component
  COMPONENT ALU IS
    PORT (
      a : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
      b : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
      Sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      carry_in : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      carry_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000"
    );
  END COMPONENT;

  --Register File Component
  COMPONENT register_file IS
    PORT (
      data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      read_address_f : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      read_address_s : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      write_address : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      write_e : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      data_out_f : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      data_out_s : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;

  -- DataMem component
  COMPONENT data_memory IS
    PORT (
      data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      read_address : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      write_e : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      clk : IN STD_LOGIC;
      data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;

  -- Flag setter
  COMPONENT flag_setter IS
    PORT (
      N : INOUT STD_LOGIC;
      C : INOUT STD_LOGIC;
      V : INOUT STD_LOGIC;
      Z : INOUT STD_LOGIC;
      op1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      op2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      res : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      S_bit : IN STD_LOGIC;
      carry_out : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      clk : STD_LOGIC
    );
  END COMPONENT;

  -- PC
  COMPONENT PC IS
    PORT (
      clk : STD_LOGIC;
      psrc : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      offset : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
      oute : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
      PW : IN STD_LOGIC;
      res1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000"
    );
  END COMPONENT;

  -- condition checker
  COMPONENT cond_checker IS
    PORT (
      N_in : IN STD_LOGIC;
      C_in : IN STD_LOGIC;
      V_in : IN STD_LOGIC;
      Z_in : IN STD_LOGIC;
      cond : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      cond_out : OUT STD_LOGIC
    );
  END COMPONENT;

  --decoder
  COMPONENT Decoder IS
    PORT (
      instruction : IN word;
      instr_class : OUT instr_class_type;
      operation : OUT optype;
      DP_subclass : OUT DP_subclass_type;
      DP_operand_src : OUT DP_operand_src_type;
      load_store : OUT load_store_type;
      DT_offset_sign : OUT DT_offset_sign_type
    );
  END COMPONENT;

   COMPONENT shifter IS
    PORT (
        shift : in std_logic_vector(4 downto 0);
        inputRec : in std_logic_vector(31 downto 0 );
        instruction : in std_logic_vector(31 downto 0);
        rorCheck : in std_logic;
        carry_out5 : out std_logic_vector(0 downto 0);
        outputt : out std_logic_vector(31 downto 0)
      
    );
  END COMPONENT;

  --main fsm signal
  SIGNAL FSM_controller : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
  -- aluinputs signals
  SIGNAL a : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
  SIGNAL b : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";
  SIGNAL Sel : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL carry_in : STD_LOGIC_VECTOR(0 DOWNTO 0);
  SIGNAL carry_out : STD_LOGIC_VECTOR(0 DOWNTO 0);

  -- DM signals
  SIGNAL didm : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL radm : STD_LOGIC_VECTOR(6 DOWNTO 0);
  SIGNAL wedm : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL dodm : STD_LOGIC_VECTOR(31 DOWNTO 0);

  --RF signals
  SIGNAL direg : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL raregf : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL raregs : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL wareg : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL wereg : STD_LOGIC;
  SIGNAL doregf : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL doregs : STD_LOGIC_VECTOR(31 DOWNTO 0);

  --flag setter
  SIGNAL N : STD_LOGIC;
  SIGNAL C : STD_LOGIC;
  SIGNAL V : STD_LOGIC;
  SIGNAL Z : STD_LOGIC;
  SIGNAL op1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL op2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL ress : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL S_bit : STD_LOGIC;

  --cond checker

  SIGNAL cond : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL cond_out : STD_LOGIC := '0';

  --PC
  SIGNAL psrc : STD_LOGIC := '0';
  SIGNAL pcoffset : STD_LOGIC_VECTOR (23 DOWNTO 0);
  SIGNAL pcout : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000040";

  --decoder
  SIGNAL instruction : word;
  SIGNAL instr_class : instr_class_type;
  SIGNAL operation : optype;
  SIGNAL DP_subclass : DP_subclass_type;
  SIGNAL DP_operand_src : DP_operand_src_type;
  SIGNAL load_store : load_store_type;
  SIGNAL DT_offset_sign : DT_offset_sign_type;

  --signal for shifter
  SIGNAL shift : std_logic_vector(4 downto 0);
  SIGNAL inputRec : std_logic_vector(31 downto 0);
  SIGNAL carry_out5 : std_logic;
  SIGNAL rorCheck : std_logic;
  SIGNAL outputt : std_logic_vector(31 downto 0);
  SIGNAL carry_out55 : std_logic_vector(0 downto 0);

  --signals for register

  SIGNAL Aa : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Bb : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Cc : STD_LOGIC_VECTOR(31 downto 0);
  SIGNAL IR : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL DR : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL RES : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL res1 : STD_LOGIC_VECTOR(31 DOWNTO 0); -- alu result, data memory in, 
  SIGNAL F : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL Lbit, Ubit : STD_LOGIC;
  SIGNAL Rd, Rn, Rm : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL temp : STD_LOGIC_VECTOR(0 DOWNTO 0);

  --control signal
  --state mix
  SIGNAL IorD : STD_LOGIC;
  SIGNAL PW : STD_LOGIC;
  SIGNAL asrc1 : STD_LOGIC;
  SIGNAL asrc2 : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL IW : STD_LOGIC;
  SIGNAL DW : STD_LOGIC;
  SIGNAL AW : STD_LOGIC;
  SIGNAL BW : STD_LOGIC;
  SIGNAL RW : STD_LOGIC;
  SIGNAL ReW : STD_LOGIC;
  SIGNAL CW : STD_LOGIC;
  SIGNAL M2R : STD_LOGIC;
  SIGNAL rsrc : STD_LOGIC;

BEGIN
  u1 : Decoder PORT MAP(instruction, instr_class, operation, DP_subclass, DP_operand_src, load_store, DT_offset_sign);
  u2 : register_file PORT MAP(direg, raregf, raregs, wareg, wereg, clk, doregf, doregs);
  u3 : ALU PORT MAP(a, b, Sel, carry_in, carry_out, res1);
  u4 : flag_setter PORT MAP(N, C, V, Z, a, b, res1, S_bit, carry_out, clk);
  u5 : cond_checker PORT MAP(N, C, V, Z, cond, cond_out);
  u6 : data_memory PORT MAP(didm, radm, wedm, clk, dodm);
  u7 : PC PORT MAP(clk, psrc, resete, pcoffset, pcout, PW, res1);
  u8 : shifter PORT MAP(shift, inputRec  ,instruction,  rorCheck, carry_out55 , outputt ); --check once
  -- Extracting PM address from PC and getting the instruction

  a <= Aa WHEN asrc1 = '1' ELSE
    "00" & pcout(31 DOWNTO 2);

  b <= Cc when (instruction(25) ='1' and FSM_controller ="0011") else   -- immediate case for DP_1
  x"00000000" when FSM_controller = "0001" else  --0 for PC+4
     ("11111111"&pcoffset) when asrc2 = "11" and cond_out ='1' and pcoffset(23) ='1' else -- setting up for PCoffset when branching is known
     "00000000"&pcoffset when asrc2 = "11" and pcoffset(23) ='0' and cond_out ='1' else
      x"00000000" when asrc2 = "11" and cond_out = '0' else -- when bne beq case fail, do normal PC+4
      Cc when asrc2 = "00" else  
        "00000000000000000000"&instruction(11 downto 0) when asrc2 = "10" and instruction(11) = '0' and instruction(25) = '0' else --signed offset ext of instruction in DT case
          "11111111111111111111"&instruction(11 downto 0) when asrc2 = "10" and instruction(11) = '1' and instruction(25) = '0' else
             Cc when asrc2 = "10" and instruction(25) = '1' else --dt and reg wala check

            x"00000000";

  Sel <= "0101" WHEN (FSM_controller = "0001" OR FSM_controller = "1001") ELSE
    "0101" WHEN asrc2 = "11" ELSE
    instruction(24 DOWNTO 21) WHEN FSM_controller = "0011" ELSE
    "0100" WHEN (Ubit = '1' AND rsrc = '1') ELSE
    "0010" WHEN (Ubit = '0' AND rsrc = '1') ELSE
    "1111";

  carry_in <= "1" WHEN asrc1 = '0' AND asrc2 = "01" ELSE
    "1" WHEN asrc2 = "11" ELSE
    "1" WHEN C = '1' AND FSM_controller = "0011" ELSE
    "0" WHEN C = '0' AND FSM_controller = "0011" ELSE
    "0";
    temp<=carry_out55;
shift <= instruction(11 downto 7) WHEN FSM_controller = "1010" and instruction(4 downto 4) = "0" and instruction(25) = '0' else
        doregs(4 downto 0) WHEN FSM_controller = "1010" and instruction(4 downto 4) = "1" and instruction(25) = '0' else
         instruction(11 downto 8) & "0" WHEN FSM_controller = "1010"  and instruction(25) = '1' else
         "00000";

rorCheck <= '1' WHEN instruction(25) = '1' and FSM_controller = "1010" else
'0';

inputRec <=          X"000000" & instruction(7 downto 0) when   FSM_controller = "1010" and instruction(25) = '1' and F = "00" else
Bb when FSM_controller = "1010"  else
          Bb;




  radm <= RES(6 DOWNTO 0) WHEN IorD = '1' ELSE
    pcout(6 DOWNTO 0);

  didm <= Bb;

  instruction <= IR;
  cond <= instruction(31 DOWNTO 28);
  F <= instruction (27 DOWNTO 26);
  Lbit <= instruction (20);
  Ubit <= instruction(23);
  pcoffset <= instruction(23 DOWNTO 0);

  Rn <= instruction(19 DOWNTO 16);
  Rd <= instruction(15 DOWNTO 12);
  Rm <= instruction(3 DOWNTO 0);
  raregf <= Rn; --read from reg
  
    raregs <= instruction(11 downto 8) when FSM_controller = "1010" and instruction(4 downto 4)= "1" else
    Rd WHEN rsrc = '1' and not(FSM_controller = "1010") else
    Rm WHEN rsrc = '0' and not(FSM_controller = "1010") else 
    
    Rm ;

  wareg <= Rd;

  direg <= DR WHEN M2R = '1' ELSE
    RES;

  --control path

  IorD <= '0' WHEN FSM_controller = "0001" ELSE
    '1' WHEN FSM_controller = "0110" ELSE
    '1' WHEN FSM_controller = "0111" ELSE
    '0';

  PW <= '1' WHEN FSM_controller = "0001" ELSE
    '1' WHEN FSM_controller = "1001" ELSE
    '0';

  IW <= '1'WHEN FSM_controller = "0001" ELSE
    '0';

  asrc1 <= '1' WHEN FSM_controller = "0011" ELSE
    '1' WHEN FSM_controller = "0101" ELSE
    '0';

  asrc2 <= "01" WHEN FSM_controller = "0001" ELSE
    "00" WHEN FSM_controller = "0011"AND instruction(25) = '0' ELSE
    "10" WHEN FSM_controller = "0101" ELSE
    "11" WHEN FSM_controller = "1001" ELSE
    "XX";

  AW <= '1' WHEN FSM_controller = "0010" ELSE
    '0';
  BW <= '1' WHEN FSM_controller = "0010" ELSE
    '1' WHEN FSM_controller = "0101" ELSE
    '0';

  CW <= '1' WHEN FSM_controller = "1010" else  --check
  '0';

  S_bit <= instruction(20) WHEN FSM_controller = "0011" ELSE
    '0';

  ReW <= '1' WHEN FSM_controller = "0011" ELSE
    '1' WHEN FSM_controller = "0101" ELSE
    '0';
  M2R <= '0' WHEN FSM_controller = "0100"
    ELSE
    '1';

  wereg <= '1' WHEN FSM_controller = "0100" AND NOT(instruction(24 DOWNTO 21) = "1010") AND NOT(instruction(24 DOWNTO 21) = "1011") AND NOT(instruction(24 DOWNTO 21) = "1000") AND NOT(instruction(24 DOWNTO 21) = "1001") ELSE
    '1' WHEN FSM_controller = "1000" ELSE
    '0';

  rsrc <= '1' WHEN FSM_controller = "0101" ELSE
    '0';

  wedm <= "1111" WHEN FSM_controller = "0110" ELSE
    "0000";

  DW <= '1' WHEN FSM_controller = "0111" ELSE
    '0';

  psrc <= cond_out WHEN FSM_controller = "1001" ELSE
    '0';

  --processes for defining various registers thru write enables

  PROCESS (clk)
  BEGIN
  if(rising_edge(clk)) then
    IF (IW = '1') THEN
      IR <= dodm;
    END IF;

    IF (DW = '1') THEN
      DR <= dodm;
    END IF;

    IF (AW = '1') THEN
      Aa <= doregf;
    END IF;

    IF (BW = '1') THEN --check for asrc2 waise once
      Bb <= doregs;

    END IF;

    IF (ReW = '1') THEN
      RES <= res1;
    END IF;

    IF(CW ='1') THEN 
    Cc <= outputt;
    END IF;
    end if;
  END PROCESS;

  PROCESS (clk, resete)

  BEGIN
    IF (rising_edge(clk)) THEN
      --resetting signals 

      CASE FSM_controller IS
        WHEN "0001" =>
          FSM_controller <= "0010";
        WHEN "0010" =>

          IF (F = "00") THEN
            FSM_controller <= "1010"; --DP
          ELSIF (F = "01") THEN
            FSM_controller <= "1010"; --DT
          ELSE
            FSM_controller <= "1001"; --b
          END IF;

        WHEN "1010" =>              -- reading for shifter
        FSM_controller <= "1011";

        WHEN "1011" =>             --doing shifter work
        IF (F = "00") THEN
            FSM_controller <= "0011"; --DP
        ELSIF (F = "01") THEN
            FSM_controller <= "0101";
         END IF;    --DT
        


        WHEN "0011" =>

          FSM_controller <= "0100";
        WHEN "0100" =>
          FSM_controller <= "0001";


        WHEN "0101" => --dt begins
          IF (Lbit = '1') THEN
            FSM_controller <= "0111";
          ELSE
            FSM_controller <= "0110";
          END IF;
        WHEN "0110" =>
          FSM_controller <= "0001";

        WHEN "0111" =>
          FSM_controller <= "1000";
        WHEN "1000" =>

          FSM_controller <= "0001";

        WHEN "1001" =>
          FSM_controller <= "0001"; --back to PC

        WHEN OTHERS =>
          psrc <= '0';
      END CASE;
    END IF;
  END PROCESS;
END beh_proc;

-- functional hai
