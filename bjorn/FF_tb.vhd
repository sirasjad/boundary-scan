----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2020 11:42:52
-- Design Name: 
-- Module Name: FF_tb - Behavioral
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

entity FF_tb is
   -- Port ( k : in STD_LOGIC);
end FF_tb;

architecture Behavioral of FF_tb is



component FF is
    Port ( D : in STD_LOGIC;
           Q : out STD_LOGIC;
           CLK : in STD_LOGIC);
end component;
constant clock_time : time := 10ns;
signal CLK,D,Q : std_logic;
begin

uut: FF
port map(
D=>D,Q=>Q,CLK=>CLK
);

clk_proc : process
begin
clk<='0';
wait for clock_time/2;
clk<='1';
wait for clock_time/2;
end process;



process
begin
D<='0';
wait for clock_time;
D<='0';
wait for clock_time;
D<='0';
wait for clock_time;
D<='0';
wait for clock_time;
D<='0';
wait for clock_time;
D<='1';
wait for clock_time*10;

D<='0';
wait for clock_time*10;

end process;


end Behavioral;
