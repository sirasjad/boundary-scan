----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.01.2020 13:00:49
-- Design Name: 
-- Module Name: TAP - Behavioral
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

entity TAP is
Port (TMS : in   std_logic;
TCK : in  std_logic;

TLR, capt_DR, shift_DR, updt_DR, capt_IR, shift_IR, updt_IR  : out std_logic
);
end TAP;

architecture Behavioral of TAP is
---Test Logic Reset
--- Run Test/Idle
--------------
--select dr-scan
--capture dr
--shift dr
--exit-1 dr
--pause dr
--exit-2 dr
--update dr
----------------
--select ir-scan
--capture ir
--shift ir
--exit-1 ir
--pause ir
--exit-2 ir
--update ir

type state  is (
testLogicReset,
runTestIdle,
--------------------------
selectDrScan,
captureDr,
shiftDr,
exit1Dr,
pauseDr,
exit2Dr,
updateDr,
--------------------------
selectIrScan,
captureIr,
shiftIr,
exit1Ir,
pauseIr,
exit2Ir,
updateIr
);
signal preST, nxtST : state := testLogicReset;


signal ctr_BSR_CS_FF,ctr_BSR_CS_EN, ctr_BSR_L_EN, ctr_IR_L_EN, ctr_IR_CS_EN,ctr_IR_CS_FF : std_logic;
--signal ctr_BSR_L_FF : std_logic;
begin






---State Register
process(tck)
begin
if(rising_edge(tck)) then
preSt <= nxtSt;
end if;
end process;
---Next State Register
process(preSt, tms)
begin
nxtSt <= preSt; -- stay in this state if nothing else

case preSt is
when testLogicReset =>
if (tms='0') then nxtSt <= runTestIdle;

end if;
when runTestIdle =>
if (tms = '1') then nxtSt <= selectDrScan;

end if;
when selectDrScan =>
if (tms='1') then nxtSt <= selectIrScan;
else nxtSt <= captureDr;

end if;
when captureDr =>
if (tms='1') then nxtSt <= exit1Dr;
else nxtSt <= shiftDr; 
end if;
when shiftDr =>
if (tms='1') then nxtSt <= exit1Dr;
-- Remain for all bits

end if;
when exit1Dr =>
if (tms='1') then nxtSt <= updateDr;
else nxtSt <= pauseDr;

end if;
when pauseDr =>
if (tms='1') then nxtSt <= exit2Dr;

end if;
when exit2Dr =>
if (tms='1') then nxtSt <= updateDr;
else nxtSt <= shiftDr;

end if;
when updateDr =>
if (tms='1') then nxtSt <= selectDrScan;
else nxtSt <= runTestIdle;
end if;
when selectIrScan =>
if (tms='1') then nxtSt <= testLogicReset;
else nxtSt <= captureIr;

end if;
when captureIr =>
if (tms='1') then nxtSt <= exit1Ir;
else nxtSt <= shiftIr; 
end if;
when shiftIr =>
if (tms='1') then nxtSt <= exit1Ir;
-- Remain for all bits

end if;
when exit1Ir =>
if (tms='1') then nxtSt <= updateIr;
else nxtSt <= pauseIr;

end if;
when pauseIr =>
if (tms='1') then nxtSt <= exit2Ir;

end if;
when exit2Ir =>
if (tms='1') then nxtSt <= updateIr;
else nxtSt <= shiftIr;

end if;
when updateIr =>
if (tms='1') then nxtSt <= selectDrScan;
else nxtSt <= runTestIdle;
end if;
end case;

end process;




--ctr_BSR_CS_FF ctr_CS, ctr_L, capt_DR, shift_DR, updt_DR, capt_IR, shift_IR, updt_IR, TLR 
--signal ctr_BSR_CS_EN, ctr_BSR_L_EN 
-- Moore Output
process(preSt)
begin


case preSt is

when testLogicReset =>
    capt_DR<='0';
    shift_DR<='0';
    updt_DR<= '0';
    capt_IR<='0';
    shift_IR<='0';
    updt_IR<='0';
    
    ctr_BSR_CS_EN<='0';
    ctr_BSR_L_EN<='0';
    ctr_BSR_CS_FF<='0';
  --  ctr_BSR_L_FF<='0';
    
    -- Loads BP instruction
    -- BP Register ctr via data mux
    -- Data in via data/inst mux
    -- Set BSR to transparent mode
    --
    TLR<='1';
    --shift_IR<='1';
    
    

when runTestIdle =>
    -- BP Register ctr via data mux 
    -- Still BSR in Transparent mode
ctr_BSR_L_EN <='0';    
ctr_IR_L_EN<='0';
TLR<='0';
    
    
    
when selectDrScan =>
updt_DR<='0';
updt_IR<='0';
ctr_IR_L_EN<='0'; 
ctr_BSR_L_EN <='0';
ctr_IR_L_EN<='0';
    -- BP Register ctr via data mux
    
when captureDr =>
ctr_BSR_CS_EN <='1';
capt_DR<='1';
-- mux in capture/shift will select Pin,
-- test mode with Pin and Pout
-- Pout will hold value coming from latch
-- Preload any initial test value by starting with PRELOAD instead of EXTEST


when shiftDr =>
capt_DR<='0';
shift_DR<='1';
ctr_BSR_CS_EN <='1';
ctr_BSR_CS_FF <='1';
-- capture/shift will select lower input (Sin) to Pout
-- remain until next to last bit shiften in, then drive tms to 1 in last cc.
when exit1Dr =>
shift_DR<='0';
capt_DR<='0';
ctr_BSR_CS_EN <='0';
ctr_BSR_CS_FF <='0';
-- from shiftDr-- to updateDr
when pauseDr =>

when exit2Dr =>

when updateDr =>
UPDT_DR<='1';
ctr_BSR_L_EN <='1';
--P.out from latch/test values
when selectIrScan =>
    -- BP Register ctr via data/inst mux
    -- Set BSR to transparent mode
    --
when captureIr =>
ctr_IR_CS_EN<='1';
CAPT_IR<='1';
-- Switch to IR input from Data/Inst Mux

when shiftIr =>
capt_IR<='0';
SHIFT_IR<='1';
ctr_IR_CS_FF<='1';
when exit1Ir =>
capt_IR<='0';
shift_IR<='0';
ctr_IR_CS_EN<='0';
ctr_IR_CS_FF<='0';
when pauseIr =>

when exit2Ir =>

when updateIr =>
ctr_IR_L_EN<='1';
UPDT_IR<='1';
-- Change BSR if in EXTEST
--

end case;

end process;


-- Mealy output

end Behavioral;
