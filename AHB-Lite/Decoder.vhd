
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2018 12:32:57 PM
-- Design Name: 
-- Module Name: Decoder - Behavioral
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

entity Decoder is
  Port ( 
  address: in std_logic_vector(11 downto 0);
  select_decoder: out std_logic_vector(4 downto 0);
  mux_decoder: out std_logic_vector(2 downto 0)
  );
end Decoder;

architecture Behavioral of Decoder is
signal inp: std_logic;
signal select_temp : std_logic_vector(4 downto 0);
begin

inp <= address(2) and address(3) and address(4) and address(5) and address(6) and address(7) and address(8) and address(9) and address(10) and address(11);

mux_decoder <= "000" when select_temp = "00001" else
                "001" when select_temp = "00010" else
               "010" when select_temp = "00100" else
               "011" when select_temp = "01000" else
               "100" when select_temp = "10000";
         
select_decoder <= select_temp;

select_temp <= "00001" when inp='0' else
        "00010" when inp='1' and address(1 downto 0)="00" else
        "00100" when inp='1' and address(1 downto 0)="01" else
        "01000" when inp='1' and address(1 downto 0)="10" else
        "10000" when inp='1' and address(1 downto 0)="11";
        
        
end Behavioral;
