----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2018 17:04:24
-- Design Name: 
-- Module Name: alu - Behavioral
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

entity alu is
    Port ( op1 : in STD_LOGIC_VECTOR (31 downto 0);
           op2 : in STD_LOGIC_VECTOR (31 downto 0);
           clock : in STD_LOGIC;
           opc : in STD_LOGIC_VECTOR (3 downto 0);
           carry : in STD_LOGIC_VECTOR(0 downto 0); -- conversion std_logic -> signed ??
           op3 : out STD_LOGIC_VECTOR (31 downto 0);
           flags : out STD_LOGIC_VECTOR (3 downto 0));
end alu;

--flag terminology + setF terminology -> NZVC 

architecture Behavioral of alu is
signal outtemp: std_logic_vector (31 downto 0);
signal setF: std_logic_vector(3 downto 0);
signal c31: std_logic;
signal c32: std_logic;
signal noresult: std_logic;
begin
    process (clock) is
    begin
        setF <= "0000";
        noresult <= '0';
        flags <= "0000";
        case opc is
        when "0000" =>
            outtemp <= op1 and op2;
            setF(3 downto 2) <= "11";
        when "0001" =>
            outtemp <= op1 xor op2;
            setF(3 downto 2) <= "11";
        when "0010" =>
            outtemp <= std_logic_vector(signed(op1)+signed(not op2)+1);
            setF(3 downto 0) <= "1111";    
        when "0011" =>
            outtemp <= std_logic_vector(signed(not op1)+1+signed(op2));
            setF(3 downto 0) <= "1111";    
        when "0100" =>
            outtemp <= std_logic_vector(signed(op1)+signed(op2));
            setF(3 downto 0) <= "1111";
        when "0101" =>
            outtemp <= std_logic_vector(signed(op1)+signed(op2)+signed(carry));
            setF(3 downto 0) <= "1111";
        when "0110" =>
            outtemp <= std_logic_vector(signed(op1)+signed(not op2)+signed(carry));
            setF(3 downto 0) <= "1111";
        when "0111" =>
            outtemp <= std_logic_vector(signed(not op1)+signed(op2)+signed(carry));
            setF(3 downto 0) <= "1111";
        when "1000" =>
            outtemp <= op1 and op2;
            setF(3 downto 2) <= "11";
            noresult <= '1';
        when "1001" =>
            outtemp <= op1 xor op2;
            setF(3 downto 2) <= "11";
             noresult <= '1';
        when "1010" =>
            outtemp <= std_logic_vector(signed(op1)+signed(not op2)+1);
            setF(3 downto 0) <= "1111";
            noresult <= '1';
        when "1011" =>
            outtemp <= std_logic_vector(signed(not op1)+1+signed(op2));
            setF(3 downto 0) <= "1111";
            noresult <= '1';
        when "1100" =>
            outtemp <= op1 or op2;
            setF(3 downto 2) <= "11";
        when "1101" =>
            outtemp <= op2;
            setF(3 downto 2) <= "11";
        when "1110" =>
            outtemp <= op1 and (not op2);
            setF(3 downto 2) <= "11";
        when others => 
            outtemp <= (not op2);
            setF(3 downto 2) <= "11";
        end case;
     
     if setF(3)='1' then
        if outtemp(31)<='1' then
            flags(3) <= '1';
        end if;
     end if;
     
     if setF(2)='1' then
        if outtemp = "0000000000000000000000000000000" then
            flags(2) <= '1';
        end if;
     end if;
     
     -- since in some cases I can't compute c32 and c31
     -- will that cause an error in this statement????
     -- and should I put it after checking that 
     -- I have to calculate the flags overflow and carry;
     c31 <= op1(31) xor op2(31) xor outtemp(31);
     c32 <= ((op1(31) and c31) xor (op2(31) and c31) xor (op2(31) and op1(31)));
     -- type conversion -> don't know how to do it?
     
     if setF(0) = '1' then
        flags(0) <= c32;
     end if;
     
     if setF(1)='1' then
        flags(1) <= (c32 xor c31);
     end if;
 
    if noresult = '0' then
        op3 <= outtemp;
    end if;
    
    end process;    
end Behavioral;
