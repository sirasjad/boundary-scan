-- D-Latch flipflop
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_latch is
    port(
        d: in std_logic;
        clk: in std_logic;
        q: out std_logic
    );
end d_latch;

architecture arch of d_latch is
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            q <= d;
        end if;
    end process;
end arch;
