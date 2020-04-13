----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2020 20:36:44
-- Design Name: 
-- Module Name: BSR - Behavioral
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

entity BSR is
    Port ( TDI : in STD_LOGIC;
           TDO : out STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR (5 downto 0);
           DOUT : out STD_LOGIC_VECTOR (5 downto 0);
           TCK : in std_logic;
           CtrSC, CtrL,rst : in std_logic;
           HoldCS,HoldL : in std_logic
           );
end BSR;

architecture Behavioral of BSR is


component BSC is
    Port ( Pin : in STD_LOGIC;
           Pout : out STD_LOGIC;
           Sin : in STD_LOGIC;
           Sout : out STD_LOGIC;
           CtrSC : in std_logic;
           CtrL : in std_logic;
           HoldCS, HoldL ,rst: in std_logic;
           CLK: in std_logic
           
           
           );
end component;
type state is (
ObservabilityCapture,
ObservabilityShift,
TestCapture,
TestShift

);

signal operatingMode : state;


signal Cell1_to_Cell2 : std_logic;

signal Cell2_to_Cell3 : std_logic;

signal Cell3_to_Cell4 : std_logic;

signal Cell4_to_Cell5 : std_logic;

signal Cell5_to_Cell6 : std_logic;

begin

process (CtrSC,CtrL)
begin
if CtrSC ='1' AND CtrL = '1' then
operatingMode<=TestShift;
elsif CtrSC ='1' AND CtrL = '0' then
operatingMode<=ObservabilityShift;
elsif CtrSC ='0' AND CtrL = '1' then
operatingMode<=TestCapture;
elsif CtrSC ='0' AND CtrL = '0' then
operatingMode<=ObservabilityCapture;

end if;
end process ;


Cell1: BSC
port map(Pin=>DIN(0), Pout=>DOUT(0), Sin=>TDI, Sout=>Cell1_to_Cell2, CtrSC=>CtrSC, CtrL=>CtrL, CLK=>TCK, rst=>rst,
        HoldCS=>HoldCS, HoldL=>HoldL);


Cell2: BSC
port map(Pin=>DIN(1), Pout=>DOUT(1), Sin=>Cell1_to_Cell2, Sout=>Cell2_to_Cell3, CtrSC=>CtrSC, CtrL=>CtrL, CLK=>TCK, HoldCS=>HoldCS,
rst=>rst,
         HoldL=>HoldL);

Cell3: BSC
port map(Pin=>DIN(2), Pout=>DOUT(2), Sin=>Cell2_to_Cell3, Sout=>Cell3_to_Cell4, CtrSC=>CtrSC, CtrL=>CtrL, CLK=>TCK,rst=>rst,
        HoldCS=>HoldCS, HoldL=>HoldL);

Cell4: BSC
port map(Pin=>DIN(3), Pout=>DOUT(3), Sin=>Cell3_to_Cell4, Sout=>Cell4_to_Cell5, CtrSC=>CtrSC, CtrL=>CtrL, CLK=>TCK,rst=>rst,
        HoldCS=>HoldCS, HoldL=>HoldL);

Cell5: BSC
port map(Pin=>DIN(4), Pout=>DOUT(4), Sin=>Cell4_to_Cell5, Sout=>Cell5_to_Cell6, CtrSC=>CtrSC, CtrL=>CtrL, CLK=>TCK,rst=>rst,
        HoldCS=>HoldCS, HoldL=>HoldL);

Cell6: BSC
port map(Pin=>DIN(5), Pout=>DOUT(5), Sin=>Cell5_to_Cell6, Sout=>TDO, CtrSC=>CtrSC, CtrL=>CtrL, CLK=>TCK, rst=>rst,
    HoldCS=>HoldCS, HoldL=>HoldL);



end Behavioral;
