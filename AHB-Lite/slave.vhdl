library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity slave is
    Port ( Hsel : in STD_LOGIC;
           Haddr : in STD_LOGIC_VECTOR (15 downto 0);
           Hwrite : in STD_LOGIC;
           Hsize : in STD_LOGIC_VECTOR (2 downto 0);
           Htrans : in STD_LOGIC_VECTOR (1 downto 0);
           Hready : in STD_LOGIC;
           Hwdata : in STD_LOGIC_VECTOR (31 downto 0);
           Hreset : in STD_LOGIC;
           Hclk : in STD_LOGIC;
           Hreadyout : out STD_LOGIC;
           Hrdata : out STD_LOGIC_VECTOR (31 downto 0));
end slave;

architecture Behavioral of slave is
signal state : STD_LOGIC_VECTOR (2 downto 0);
signal MemSelect : STD_LOGIC;

signal addr: STD_LOGIC_VECTOR(15 downto 0);
signal W, we: STD_LOGIC;
signal mem_out: STD_LOGIC_VECTOR(31 downto 0);

-- terminology : according to occurence in slides
begin
Hreadyout <= '0' when state = "001" or state ="010" or state ="011" else
             '1' when state = "100";
addr <= Haddr when state ="001";
W <= Hwrite when state = "001";
Hrdata <= mem_out when state ="101";
we <= '1' when state ="110";

process(Hclk)
begin
  case state is
    when "000" => if (Htrans="00") then state<="00";
              elsif (Htrans="01" and MemSelect='0') then state<="00";
              elsif (Htrans="01" and MemSelect='1') then state<="01";
              end if;
    when "001" => state <= "010";
    when "010" => state <= "011"; 
    when "011" => state <= "100";
    when "100" => if W='1' then state<="110";
                  else state<="101";
                  end if;
    when "110" => state<="000";
    when "101" => state<="000";
    when others => state<="000";
  end case;
end process;
end Behavioral;
