----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2020 10:26:05
-- Design Name: 
-- Module Name: MUX_tb - Behavioral
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

entity MUX_tb is
--  Port ( );
end MUX_tb;

architecture Behavioral of MUX_tb is

component MUX is
  Port ( DIN1 : in STD_LOGIC;
           DIN2 : in STD_LOGIC;
           SEL : in STD_LOGIC;
           DOUT : out STD_LOGIC);
end component;

constant clk_period : time := 10ns;
signal data1,data2,selector,dataOut : std_logic;




begin

uut: MUX
port map(
DIN1=>data1, DIN2=>data2, SEL=>selector, DOUT=>dataOut
);

process
begin
data1<='1';
data2<='0';

selector<='0';
wait for 100ns;
selector<='1';

data2<='1';
wait for 10ns;
data2<='0';
wait for 10ns;

data2<='1';
wait for 10ns;
data2<='0';
wait for 10ns;


data2<='1';
wait for 10ns;
data2<='0';
wait for 10ns;


data2<='1';
wait for 10ns;
data2<='0';
wait for 10ns;

selector<='1';
wait for 50ns;
data1<='0';
wait for 50ns;

end process;


end Behavioral;
