----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2020 10:20:00
-- Design Name: 
-- Module Name: FF - Behavioral
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

entity FF is
    Port ( RST,D : in STD_LOGIC;
           Q : out STD_LOGIC;    
           CLK : in STD_LOGIC);
end FF;

architecture Behavioral of FF is

begin
process(CLK)
begin

if(RST='1') then
Q <='0';
elsif(clk'event and clk='1') then
Q<=D;
end if;
end process;

end Behavioral;
