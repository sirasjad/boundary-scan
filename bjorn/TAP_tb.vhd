----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.02.2020 11:13:14
-- Design Name: 
-- Module Name: TAP_tb - Behavioral
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

entity TAP_tb is
--  Port ( );
end TAP_tb;

architecture Behavioral of TAP_tb is


component TAP is
Port (TMS : in   std_logic;
TCK : in  std_logic;
TLR, capt_DR, shift_DR, updt_DR, capt_IR, shift_IR, updt_IR  : out std_logic
);
end component;


signal TCK,TMS, TLR,capt_DR, shift_DR, updt_DR, capt_IR, shift_IR, updt_IR : std_logic;

constant clock_time : time := 10ns;


begin

uut : TAP
port map
(
TMS=>TMS, TCK=>TCK, TLR=>TLR, capt_DR=>capt_DR, shift_DR=>shift_DR, updt_DR=>updt_DR, capt_IR=>capt_IR, shift_IR=>shift_IR, updt_IR=>updt_IR
);



clk_proc : process
begin
TCK<='0';
wait for clock_time/2;
TCK<='1';
wait for clock_time/2;
end process;

process
begin
TMS<='0';
wait for clock_time;
TMS<='1';
wait for clock_time*2;
TMS<='0';
wait for clock_time;
TMS<='1';
wait for clock_time;
TMS<='0';
wait for clock_time;
TMS<='1';
wait for clock_time;
TMS<='0';
wait for clock_time;
TMS<='0';
wait for clock_time*10;


end process;



end Behavioral;
