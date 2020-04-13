----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.01.2020 14:29:19
-- Design Name: 
-- Module Name: TopBlock - Behavioral
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



---TODO

--Add reset port to BScell








library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;





entity TopBlock is
  Port (
  TDI,TMS, TCK : in std_logic;
  DIN : in std_logic_vector(5 downto 0);
  DOUT : out std_logic_vector( 5 downto 0);
  TDO : out std_logic
 
   );
end TopBlock;

architecture Behavioral of TopBlock is


component FF is
 Port ( D : in STD_LOGIC;
           Q : out STD_LOGIC;
           rst : in std_logic;
           CLK : in STD_LOGIC);
end component;

component MUX is
port
( DIN1 : in STD_LOGIC;
           DIN2 : in STD_LOGIC;
           SEL : in STD_LOGIC;
           DOUT : out STD_LOGIC);
end component;


component instructiondecoder is
  port (
    data_in, clock, set, shift, reset: in std_logic;
    data_out: out std_logic;
    -- Data multiplexer out -> '0' for selecting BSR, '1' for Bypass Register
    data_mux_out: out std_logic;
    -- Cell control outputs
    cell_test_mode_out: out std_logic;
    cell_capture_out, cell_keep_capture_out: out std_logic

 );
end component;

component TAP is
Port (TMS : in   std_logic;
TCK : in  std_logic;

TLR, capt_DR, shift_DR, updt_DR, capt_IR, shift_IR, updt_IR  : out std_logic
);
end component;




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


-- Universal Signals
signal BSR_OUT_TO_DATA_MUX,
BP_OUT_TO_DATA_MUX,
DEC_CTR_TO_DATA_MUX,
DATA_MUX_OUT_TO_DATA_INST_MUX,

IR_OUT_TO_DATA_INST_MUX,
TAP_CTR_TO_DATA_INST_MUX : std_logic;




--signal TLS : std_logic; 

-- signals from TAP CTR
signal TLR:std_logic;
signal  capt_DR, shift_DR, updt_DR, capt_IR, shift_IR, updt_IR :std_logic;

-- signals from BSR
signal Ctr_BSR_CS, Ctr_BSR_L, Hold_BSR_CS, Hold_BSR_L : std_logic;


-- signals from IR + Decoder
signal cell_keep_test_mode_out,cell_capture_out, cell_keep_capture_out, cell_test_mode_out : std_logic;
--signal holdDataTMP : std_logic;
begin

---- TAP & IR --> BSR interface --------------

Ctr_BSR_CS <= shift_DR;

Ctr_BSR_L <= cell_test_mode_out;

Hold_BSR_CS <= cell_keep_capture_out AND (capt_DR OR shift_DR); 

Hold_BSR_L <= cell_keep_test_mode_out AND updt_DR ;

dataMux: MUX
port map(
DIN1=>BSR_OUT_TO_DATA_MUX , DIN2=>BP_OUT_TO_DATA_MUX,
 SEL=>DEC_CTR_TO_DATA_MUX, DOUT=>DATA_MUX_OUT_TO_DATA_INST_MUX
);

dataInstMux: MUX
port map(
DIN1=>DATA_MUX_OUT_TO_DATA_INST_MUX,
 DIN2=>IR_OUT_TO_DATA_INST_MUX,
  DOUT=>TDO, 
   SEL=>shift_IR
);


BP: FF
port map(
D=>TDI, Q=>BP_OUT_TO_DATA_MUX,rst=>TLR,clk=>tck
);




IR: instructiondecoder
port map(
data_in => TDI, data_out=>IR_OUT_TO_DATA_INST_MUX, clock=>tck, 
set=>updt_IR,
 data_mux_out=>DEC_CTR_TO_DATA_MUX,
shift=>shift_IR,cell_test_mode_out=>cell_test_mode_out,
--cell_keep_test_mode_out=>cell_keep_test_mode_out,
cell_capture_out=>cell_capture_out,
cell_keep_capture_out=>cell_keep_capture_out,

reset=>TLR

);

BSReg: BSR 
port map(
TDI=>TDI, TDO=>BSR_OUT_TO_DATA_MUX, DIN=>DIN, DOUT=>DOUT, TCK=>TCK, CtrSC=>Ctr_BSR_CS,
CtrL=>Ctr_BSR_L, HoldCS=>Hold_BSR_CS, HoldL=>Hold_BSR_L, rst=>TLR
);

TAPCtr : TAP
port map(
TMS=>TMS, TCK=>TCK, TLR=>TLR, capt_DR=>capt_DR, shift_DR=>shift_DR,
updt_DR=>updt_DR, shift_IR => shift_IR, capt_IR => capt_IR, updt_IR=>updt_IR
);





end Behavioral;
