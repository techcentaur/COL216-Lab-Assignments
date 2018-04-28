

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2018 12:17:30 PM
-- Design Name: 
-- Module Name: master - Behavioral
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

entity master is
    Port ( Hready : in STD_LOGIC;
           Hreset : in STD_LOGIC;
           Hclk : in STD_LOGIC;
           Hrdata : in STD_LOGIC_VECTOR (31 downto 0);
           Haddr : out STD_LOGIC_VECTOR (11 downto 0);
           Hwrite : out STD_LOGIC;
           Hsize : out STD_LOGIC_VECTOR (3 downto 0);
           Htrans : out STD_LOGIC_VECTOR (1 downto 0);
           Hwdata : out std_logic_vector(31 downto 0));
end master;

architecture Behavioral of master is
signal addr, memaddr_M : std_logic_vector(31 downto 0);
signal state : std_logic_vector(1 downto 0):= "00";
signal size: std_logic_vector(3 downto 0);
signal MR_M, MW_M: std_logic;
signal regfile: std_logic_vector(511 downto 0);
signal write: std_logic;
signal wrdata_M: std_logic_vector(31 downto 0);
signal writeen_M: std_logic_vector(3 downto 0);
signal logic: std_logic;

begin

proc: entity work.PROCESSOR port map(Hclk, regfile, memaddr_M, wrdata_M, MW_M, MR_M, Hrdata, writeen_M);

logic <= '1' when MR_M ='0' else
        '0' when MR_M='1';
Hwdata <= wrdata_M;
Haddr <= memaddr_M(11 downto 0) when state="01";
Hsize <= size;
Htrans <= "10" when state="01" else "00";
Hwrite <= '1' when MR_M='0' else '0';


          
-- terminology of states : according to occurence in slides
process(Hclk)
begin
    if (Hclk='1' and Hclk'event) then
	case state is
		when "00" => state <="01";
		when "01" => state <= "10";
		when "10" => if (Hready = '1' and logic = '0') then state <= "11";
							elsif (Hready = '1' and logic = '1') then state <="00";
							end if;
		when others => state <= "00";
	end case;
    end if;
end process;

end Behavioral;
