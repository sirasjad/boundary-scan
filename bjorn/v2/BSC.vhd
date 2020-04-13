----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2020 10:17:00
-- Design Name: 
-- Module Name: BSC - Behavioral
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


-- Observability
---- P.in
---- S.in
-- Controllability
----P.in
----S.in

entity BSC is
    Port ( Pin : in STD_LOGIC;
           Pout : out STD_LOGIC;
           Sin : in STD_LOGIC;
           Sout : out STD_LOGIC;
           CtrSC : in std_logic;
           CtrL : in std_logic;
           HoldL,HoldCS,rst: in std_logic;
           CLK: in std_logic
           
           );
end BSC;

architecture Behavioral of BSC is

component FF is
 Port ( D : in STD_LOGIC;
           Q : out STD_LOGIC;
           rst : in std_logic;
           CLK : in STD_LOGIC);
end component;

component MUX is
  Port ( DIN1 : in STD_LOGIC;
           DIN2 : in STD_LOGIC;
           SEL : in STD_LOGIC;
           DOUT : out STD_LOGIC);
end component;

--signal MUX_CS_to_FF_CS: std_logic;
--signal FF_CS_to_FF_L : std_logic;



signal MUX_CS_to_CS_HOLD :std_logic;
signal CS_HOLD_to_FF_CS : std_logic;
signal FF_CS_to_L_HOLD : std_logic;
signal L_HOLD_to_FF_L : STD_LOGIC;
signal FF_L_to_MUX_L : std_logic;

begin

Sout<=FF_CS_to_L_HOLD; 

CS_HOLD : MUX
port map(DIN1=>FF_CS_to_L_HOLD, DIN2=>MUX_CS_to_CS_HOLD, SEL=>HoldCS, DOUT=> CS_HOLD_to_FF_CS );

L_HOLD : MUX
port map(DIN1=>FF_L_to_MUX_L, DIN2=>FF_CS_to_L_HOLD, SEL=>HoldL, DOUT=> L_HOLD_to_FF_L);



---------------

CS_MUX:MUX
port map(
DIN1=>Pin, DIN2=>Sin, SEL=>CtrSC, DOUT=>MUX_CS_to_CS_HOLD
);


CS_FF: FF
port map(
D=>CS_HOLD_to_FF_CS, CLK=>CLK, Q=>FF_CS_to_L_HOLD,rst=>rst
);



L_FF:FF
port map(
D=>L_HOLD_to_FF_L, CLK=>CLK, Q=>FF_L_to_MUX_L,rst=>rst
);

L_MUX:MUX
port map(
DIN1=>Pin , DIN2=>FF_L_to_MUX_L, SEL=>CtrL, DOUT=>Pout
);

end Behavioral;
