----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2018 01:41:07 PM
-- Design Name: 
-- Module Name: Controller - Behavioral
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

entity Controller is
--  Port ( );
end Controller;

architecture Behavioral of Controller is
--type STATE_TYPE IS(fetch, rdAB, arith, addr, brn, wrRF, wrM, rdM, M2RF);
signal state: std_logic_vector(3 downto 0);
begin


end Behavioral;

-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BCtrl is
  Port ( flags: in std_logic_vector(3 downto 0);
        ins: in std_logic_vector(3 downto 0);
        p: out std_logic );
end BCtrl;

architecture Behavioral of BCtrl is

begin
-- flags 3-CVNZ-0
with ins select p <=
    flags(0) when "0000",
    (not flags(0)) when "0001",
    (flags(3)) when "0010",
    (not flags(3)) when "0011",
    (flags(1)) when "0100",
    (not flags(1)) when "0101",
    (flags(2)) when "0110",
    (not flags(2)) when "0111",
    (flags(2) and (not flags(0))) when "1000",
    (not (flags(2) and (not flags(0)))) when "1001",
    (not (flags(2) xor flags(1))) when "1010",
    ((flags(2) xor flags(1))) when "1011",
    ((not flags(0)) and (not (flags(2) xor flags(1)))) when "1100",
    (not ((not flags(0)) and (not (flags(2) xor flags(1))))) when "1101",
    '1' when "1110";

end Behavioral;

------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--type STATE_TYPE IS(fetch, rdAB, arith, addr, brn, wrRF, wrM, rdM, M2RF);

entity next_state is
  Port ( clock: in std_logic;
        state: in std_logic_vector(3 downto 0);
        ins2726: in std_logic_vector(1 downto 0);
        ins20: in std_logic;
         outstate: out std_logic_vector(3 downto 0));
end next_state;

architecture Behavioral of next_state is
begin
process(clock) is
begin
    if clock='1' and clock'event then
        if state="0000" then outstate<="0001";
        elsif state="0001" then
            if ins2726 = "00" then outstate<="0010";
            elsif ins2726="01" then outstate<="0011";
            elsif ins2726="10" then outstate<="0100";
            end if;
        elsif state="0010" then outstate<="0101";
        elsif state="0011" then
            if ins20='0' then outstate<="0111";
            else outstate<="1000";
            end if;
        elsif state="0100" then outstate<="0000";
        elsif state="0101" then outstate<="0000";
        elsif state="0111" then outstate<="0000";
        elsif state="1000" then outstate<="1001";
        elsif state="1001" then outstate<="0000";
        end if;
    end if;
end process;
end Behavioral;

-----------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--type STATE_TYPE IS(fetch, rdAB, arith, addr, brn, wrRF, wrM, rdM, M2RF);


entity control_state is
  Port ( clock: in std_logic;
        state: in std_logic_vector(3 downto 0);
        outstate: out std_logic_vector(3 downto 0));
end control_state;

architecture Behavioral of control_state is
begin
process(clock) is
begin
    if clock='1' and clock'event then
        outstate<=state;
    end if;
end process;
end Behavioral;


-----------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--type STATE_TYPE IS(fetch, rdAB, arith, addr, brn, wrRF, wrM, rdM, M2RF);

entity ACtrl is
  Port ( state: in std_logic_vector(3 downto 0);
         ins: in std_logic_vector(3 downto 0);
         op: out std_logic_vector(3 downto 0));
end ACtrl;

architecture Behavioral of ACtrl is
begin

    with state select op<=
        "0100" when "0101",
        ins when "0011",
        "0100"  when "0100";

end Behavioral;



-----------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--type STATE_TYPE IS(fetch, rdAB, arith, addr, brn, wrRF, wrM, rdM, M2RF);

entity main_control is
  Port ( 
        state: in std_logic_vector(3 downto 0);
        ins: in std_logic_vector(7 downto 0);
        Rsrc, MR, M2R, Asrc1, Asrc2, IoD, IW, DW, AW, BW, ResW: out std_logic
  );
end main_control;

architecture Behavioral of main_control is
begin

end Behavioral;

----------------------------------------------------------------------------------