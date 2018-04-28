
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2018 12:19:55 PM
-- Design Name: 
-- Module Name: slave - Behavioral
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

use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity slave is
    Port ( Hsel : in STD_LOGIC;
           Haddr : in STD_LOGIC_VECTOR (11 downto 0);
           Hwrite : in STD_LOGIC;
           Hsize : in STD_LOGIC_VECTOR (3 downto 0);
           Htrans : in STD_LOGIC_VECTOR (1 downto 0);
           Hready : in STD_LOGIC;
           Hwdata : in STD_LOGIC_VECTOR (31 downto 0);
           Hreset : in STD_LOGIC;
           Hclk : in STD_LOGIC;
           Hreadyout : out STD_LOGIC;
           Hrdata : out STD_LOGIC_VECTOR (31 downto 0));
end slave;

architecture Behavioral of slave is
signal state : STD_LOGIC_VECTOR (2 downto 0) := "000";
signal MemSelect, writee_S : STD_LOGIC;
signal datain_S: std_logic_vector(31 downto 0);
signal memaddr_S: STD_LOGIC_VECTOR(31 downto 0);
signal W, R: STD_LOGIC;
signal memout_S: STD_LOGIC_VECTOR(31 downto 0);

-- terminology : according to occurence as given in the slides
begin

datain_S <= Hwdata;
memaddr_S <= "00000000000000000000"&Haddr;
Hreadyout <= '0' when state = "001" or state ="010" or state ="011" else
             '1' when state = "100";
W <= not(Hwrite) when state = "001";
Hrdata <= memout_S;
writee_S <= '1' when state ="110";
R <= '0' when state="000" else '1';

mem: entity work.TEMP_MEM port map(Hclk, memaddr_S, datain_S, W, R, memout_S);

process(Hclk)
begin
  case state is
    when "000" => if (Htrans="00" and Hsel='1') then state<="001"; end if;
    when "001" => state <= "010";
    when "010" => state <= "011"; 
    when "011" => state <= "100";
    when "100" => if W='1' then state <="110";
                  else state<="101";
                  end if;
    when "110" => state <="000";
    when "101" => state <="000";
    when others => state <="000";
  end case;
end process;

end Behavioral;