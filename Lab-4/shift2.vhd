----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2018 15:18:44
-- Design Name: 
-- Module Name: shift2 - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shift2 is
    Port ( op1 : in STD_LOGIC_VECTOR (31 downto 0);
           clock : in STD_LOGIC;
           amount : in STD_LOGIC;
           out1 : out STD_LOGIC_VECTOR (31 downto 0);
           carry1 : out STD_LOGIC;
           carryin: in STD_LOGIC;
           shifttype: in STD_LOGIC_VECTOR(1 downto 0));
end shift2;

architecture Behavioral of shift2 is

begin
process(clock) is
begin
if amount='1' then
    if shifttype="00" then
        out1(31 downto 2) <= op1(29 downto 0);
        out1(1 downto 0)<= "00";
        carry1 <= op1(30);
    elsif shifttype = "01" then
        out1(29 downto 0) <= op1 (31 downto 2);
        out1(31 downto 30) <= "00";
        carry1 <= op1(1);
    elsif shifttype = "10" then
        out1(29 downto 0) <= op1 (31 downto 2);
        out1(1 downto 0)<=op1(31)&op1(31);
        carry1 <= op1(1);
    elsif shifttype="11" then
        out1(29 downto 0) <= op1 (31 downto 2);
        out1(31 downto 30) <= op1 (1 downto 0);
        carry1 <= op1(2);
    end if;
else 
    out1 <= op1;
    carry1 <= carryin;
end if;

end process;
end Behavioral;
