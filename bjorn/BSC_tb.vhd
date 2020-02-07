----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2020 13:13:31
-- Design Name: 
-- Module Name: BSC_tb - Behavioral
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

entity BSC_tb is
--  Port ( );
end BSC_tb;

architecture Behavioral of BSC_tb is


component BSC is
    Port ( Pin : in STD_LOGIC;
           Pout : out STD_LOGIC;
           Sin : in STD_LOGIC;
           Sout : out STD_LOGIC;
           CtrSC : in std_logic;
           CtrL : in std_logic;
           CLK: in std_logic
           
           );
end component;

constant clock_period : time := 10ns;
signal Pin, Pout, Sin, Sout, CtrSC, CtrL, CLK : std_logic;


begin

uut: BSC
port map(
pin=>pin,pout=>pout,sin=>sin,sout=>sout, ctrsc=>ctrsc, ctrl=>ctrl
, clk=>clk);

clk_proc : process
begin
clk <= '0';
wait for clock_period/2;
clk<='1';
wait for clock_period/2;
end process;

process
begin
CtrSC<='0';
CtrL<='0';
wait for clock_period;
pin<='0';
sin<='1';
wait for clock_period*2;
ctrsc<='1';
ctrL<='1';
wait for clock_period*10;
end process;


end Behavioral;
