---------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2018 01:35:28 PM
-- Design Name: 
-- Module Name: ahbdatapath - Behavioral
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

entity ahbdatapath is
  Port ( Hclk: in std_logic);
end ahbdatapath;

architecture Behavioral of ahbdatapath is

-- master signals
signal Hready : STD_LOGIC;
signal Hreset : STD_LOGIC;
signal Hrdata, Hrdata1 : STD_LOGIC_VECTOR (31 downto 0);
signal Haddr : STD_LOGIC_VECTOR (11 downto 0);
signal Hwrite : STD_LOGIC;
signal Hsize : STD_LOGIC_VECTOR (3 downto 0);
signal Htrans : STD_LOGIC_VECTOR (1 downto 0);
signal Hwdata : std_logic_vector(31 downto 0);
signal Hsel: std_logic_vector(4 downto 0);
signal Hready1: std_logic;
signal Mux: std_logic_vector(2 downto 0);

begin
-- mapping master, slave1, slave2, and slave3
master: entity work.master port map(Hready, '0', Hclk, Hrdata, Haddr, Hwrite, Hsize, Htrans, Hwdata);
slave1: entity work.slave port map(Hsel(0), Haddr, Hwrite, Hsize, Htrans, Hready, Hwdata, '0', Hclk, Hready1, Hrdata1);
decoder: entity work.decoder port map(Haddr, Hsel, mux);


Hready <= Hready1 when mux="000";
Hrdata <= Hrdata1 when Mux="000";

end Behavioral;