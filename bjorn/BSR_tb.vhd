----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2020 22:20:54
-- Design Name: 
-- Module Name: BSR_tb - Behavioral
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

entity BSR_tb is
--  Port ( );
end BSR_tb;

architecture Behavioral of BSR_tb is



component BSR is
    Port ( TDI : in STD_LOGIC;
           TDO : out STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR (5 downto 0);
           DOUT : out STD_LOGIC_VECTOR (5 downto 0);
           TCK : in std_logic;
           CtrSC, CtrL,rst : in std_logic;
           HoldCS,HoldL : in std_logic
           );
end component;


constant clock_period : time := 10ns;
signal clk,TDI, CtrSC,CtrL,HoldCS,HoldL, TDO ,rst: std_logic;
signal DOUT,DIN : std_logic_vector(5 downto 0);
begin


uut: BSR
port map(
TDI=>TDI,TDO=>TDO,DIN=>DIN,DOUT=>DOUT,TCK=>clk, CtrSC=>CtrSC,
CtrL=>CtrL, HoldCS=>HoldCS, HoldL=>HoldL,rst=>rst
);


clk_proc : process
begin
clk <= '0';
wait for clock_period/2;
clk<='1';
wait for clock_period/2;
end process;

process
begin

--DIN<= (others=>'0');
rst<='1';
CtrSC<='0';
CtrL<='0';
--TDI<='0';
HoldCS<='1';
HoldL<='1';
wait for clock_period;
rst<='0';
TDI<='0';
DIN<= (others=>'0');
wait for clock_period*2;
--tdi<='0';
DIN<= (others=>'1');
rst<='1';
wait for clock_period*2;
DIN<= (others=>'0');
rst<='0';



end process;

end Behavioral;
