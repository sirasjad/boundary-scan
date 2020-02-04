-- Boundary-scan cell
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bsc is
    port(
        pIn: in std_logic; -- Parallel input
        pOut: out std_logic; -- Parallel output
        sIn: in std_logic; -- Serial input
        sOut: out std_logic; -- Serial output
        clockDR: in std_logic; -- ClockDR latch
        updateDR: in std_logic; -- UpdateDR latch
        shiftDR: in std_logic; -- Left mux selector
        mode: in std_logic; -- Right mux selector
        clk: in std_logic -- Clock
    );
end bsc;

architecture arch of bsc is
    component d_latch is
        port(
            d: in std_logic;
            clk: in std_logic;
            q: out std_logic
        );
    end component;

    component mux is
        port(
            in0: in std_logic;
            in1: in std_logic;
            sel: in std_logic;
            out0: out std_logic
        );
    end component;

    signal left_mux_out: std_logic;
    signal capture_latch_out: std_logic;
    signal update_latch_out: std_logic;

begin
    left_mux: mux port map(in0 => pIn, in1 => sIn, sel => shiftDR, out0 => left_mux_out);
    capture_latch: d_latch port map(d => left_mux_out, clk => clk, q => capture_latch_out);
    sOut <= capture_latch_out;
    update_latch: d_latch port map(d => capture_latch_out, clk => clk, q => update_latch_out);
    right_mux: mux port map(in0 => pIn, in1 => update_latch_out, sel => mode, out0 => pOut);
end arch;
