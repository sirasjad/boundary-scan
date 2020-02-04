-- Multiplexer
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
    port (
        in0: in std_logic;
        in1: in std_logic;
        sel: in std_logic:
        out0: out std_logic;
    );
end mux;

architecture arch of mux is
begin
    process(sel, in0, in1)
    begin
        if sel = '0' then
            out0 <= in0;
        elsif sel = '1' then
            out0 <= in1;
        end if;
    end process;
end arch;
