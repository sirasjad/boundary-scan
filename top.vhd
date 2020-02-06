-- Boundary-scan cell
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    port(
        TDI: in std_logic; -- Test Data In
        TCK: in std_logic; -- Test Clock
        TMS: in std_logic; -- Test Mode Select
        TDO: out std_logic; -- Test Data Out
        BP: in std_logic -- Bypass register
    );
end top_level;

architecture arch of top_level is
    component bsr is
        port(
            TDI: in std_logic; -- Test Data In
            TCK: in std_logic; -- Test Clock
            TMS: in std_logic; -- Test Mode Select
            TDO: out std_logic; -- Test Data Out
            DIN: in std_logic_vector(5 downto 0); -- Data In
            DOUT: out std_logic_vector(5 downto 0); -- Data Out
            clockDR: in std_logic; -- ClockDR latch clock
            updateDR: in std_logic; -- UpdateDR latch clock
            shiftDR: in std_logic; -- Left mux selector
            mode: in std_logic -- Right mux selector
        );
    end component;

    component mux is
        port (
            in0: in std_logic;
            in1: in std_logic;
            sel: in std_logic;
            out0: out std_logic
        );
    end component;

    signal bsr_to_datamux: std_logic;
    signal datamux_to_instrmux: std_logic;

    bs_register: bsr port map(
        TDI => TDI;
        TDO => bsr_to_datamux
    );

    data_mux: mux port map(
        in0 => bsr_to_datamux;
        in1 => BP;
        sel => decoder -- ?
        out0 => datamux_to_instrmux
    );

    instr_mux: mux port map(
        in0 => datamux_to_instrmux;
        in1 => IR -- ?
        sel => BP_mode;
        out0 => TDO
    );

begin
    process(TCK)
    begin
        if(BP = '1') then
            TDO <= TDI;
        end if;
    end process;
end arch;
