----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2018 01:13:28 PM
-- Design Name: 
-- Module Name: datapath - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath is
  Port ( clock : in STD_LOGIC
  );
end datapath;

architecture Behavioral of datapath is
signal IorD, IW, DW, BW, AW, Fset, ReW, Mcheck, BLcheck1, BLcheck2, MULcheck: std_logic;
signal MR: std_logic;
signal MW: std_logic;
signal M2R: std_logic;
signal RW: std_logic;
signal Rsrc: std_logic;
signal Asrc1: std_logic;
signal Asrc2: std_logic_vector (2 downto 0);

signal PC: std_logic_vector (31 downto 0);
signal RES: std_logic_vector (31 downto 0);
signal IR: std_logic_vector (31 downto 0);
signal DR: std_logic_vector (31 downto 0);
signal A: std_logic_vector (31 downto 0);
signal B: std_logic_vector (31 downto 0);
signal F: std_logic_vector (3 downto 0);
signal D: std_logic_vector (31 downto 0);

signal op1 :  STD_LOGIC_VECTOR (31 downto 0);
signal op2 :  STD_LOGIC_VECTOR (31 downto 0);
signal opc :  STD_LOGIC_VECTOR (3 downto 0);
signal carry : STD_LOGIC_VECTOR(0 downto 0);
signal op3 :  STD_LOGIC_VECTOR (31 downto 0);
signal flags : STD_LOGIC_VECTOR (3 downto 0);
signal reset: std_logic;
signal mem_addr: std_logic_vector (31 downto 0);
signal data_in: std_logic_vector (31 downto 0);
signal mem_read: std_logic_vector (31 downto 0);
signal rd1: std_logic_vector (3 downto 0);
signal rd2: std_logic_vector (3 downto 0);
signal wrData: std_logic_vector (31 downto 0);
signal wrReg: std_logic_vector (3 downto 0);
signal dout1: std_logic_vector (31 downto 0);
signal dout2: std_logic_vector (31 downto 0);
signal progC: std_logic_vector (31 downto 0);
signal opr1: std_logic_vector (31 downto 0);
signal outp1: std_logic_vector (31 downto 0);
signal carry1: std_logic;
signal amount: std_logic_vector (4 downto 0);
signal shifttype: std_logic_vector (1 downto 0);
signal opr1_m: std_logic_vector (31 downto 0);
signal opr2_m: std_logic_vector (31 downto 0);
signal outp1_m: std_logic_vector (31 downto 0);
signal writeenable: std_logic_vector(3 downto 0);

begin

mem: entity work.BRAM_wrapper port map(mem_addr,clock,data_in,mem_read,'1',reset,writeenable);
regfile: entity work.regFile port map(clock,reset,RW,rd1,rd2,wrReg,wrData,dout1,dout2,ProgC);
alu: entity work.alu port map(op1,op2,opc,carry,op3,flags);
shifter: entity work.shifter port map (opr1,outp1,carry1,amount,shifttype);
multiplier: entity work.multiplier port map (opr1_m,opr2_m,outp1_m);


-- connection of r15 from memory to PC always
    PC <= ProgC;

-- before memory unit
    with IorD select mem_addr <=
        PC when '0',
        RES when '1';
    data_in <= B;


-- before registerfile unit
    IR <= mem_read when IW = '1';
    DR <= mem_read when DR = '1';

    with M2R select wrData <= 
        RES when '0',
        DR when '1',
        PC when '2',

    rd1 <= IR(19 downto 16);
    
    with Rsrc select rd2 <=
        IR(3 downto 0) when '0',
        IR(11 downto 8) when '1',
        IR(15 downto 12) when '2';

    with Wsrc select wrReg <=
        IR(15 downto 12) when '0',
        '1110' when '1';



-- before ALU        
    A <= dout1 when AW = '1';
    B <= dout2 when BW = '1';
    C <= dout2 when CW = '1';
    
    with Asrc1 select op1 <=
        A when '0',
        PC when '1',
        "00000000000000000000000000000000" when '2';

    with Bnew select opr1 <=
        B when '0',
        "000000000000000000000000"&IR(7 downto 0) when '1';

    with Cnew select amount <=
        C(4 downto 0) when '0',
        "00000" when '1',
        IR(11 downto 7) when '2',
        IR(11 downto 8)&'0' when '3';

    shifttype <= Shiftcontrol;
    
    with Carrynew select carry <=
        '0' when '0',
        '1' when '1',
        carry1 when '2';    

    with BCnew select op2 <=
        outp1 when '0',
        "00000000000000000000000000000100" when '1',
        outp1_m when '2',
        "00000000"&IR(23 downto 0) when '3';

    select opr1_m <= B when MULnew = '1';
    select opr2_m <= C when MULnew = '1';

-- After ALU
    
    F <= flags when Fset = '1';
    RES <= op3 when ResW = '1';
    
    with PW select PC <=
        RES when '1',
 
end Behavioral;
