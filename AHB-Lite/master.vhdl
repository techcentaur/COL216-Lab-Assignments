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
           Haddr : out STD_LOGIC_VECTOR (15 downto 0);
           Hwrite : out STD_LOGIC;
           Hsize : out STD_LOGIC_VECTOR (2 downto 0);
           Htrans : out STD_LOGIC_VECTOR (1 downto 0);
           Hwdata : out std_logic_vector(31 downto 0));
end master;

architecture Behavioral of master is
signal addr : std_logic_vector(31 downto 0);
signal state : std_logic_vector(1 downto 0):= "00";
signal size: std_logic_vector(2 downto 0);
signal strldr: std_logic;

begin

Haddr <= addr;
Hsize <= size;
Htrans <= "10" when state="01" else "00";

process(hclk)
begin

	case state is
		when "00" => state<="01",
		when "01" => state <= "10",
		when "10" => (if (Hready='1' and strldr='0') then
							state <= "11"
							elsif (Hready='1' and strldr='1') then state <="00";
							end if;
						)
		when others => state <= "00";
	end case;

end process;
end Behavioral;
