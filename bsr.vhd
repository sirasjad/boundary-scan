-- Boundary-scan cell
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bsr is
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
end bsr;

architecture arch of bsr is
    component bsc is
        port(
            pIn: in std_logic;
            pOut: out std_logic;
            sIn: in std_logic;
            sOut: out std_logic;
            clockDR: in std_logic;
            updateDR: in std_logic;
            shiftDR: in std_logic;
            mode: in std_logic;
            clk: in std_logic
        );
    end component;

    signal cell1_to_cell2: std_logic;
    signal cell2_to_cell3: std_logic;
    signal cell3_to_cell4: std_logic;
    signal cell4_to_cell5: std_logic;
    signal cell5_to_cell6: std_logic;

begin
    cell1: bsc port map(
        pIn => DIN(0),
        pOut => DOUT(0),
        sIn => TDI,
        sOut => cell1_to_cell2,
        clockDR => clockDR,
        updateDR => updateDR,
        shiftDR => shiftDR,
        mode => mode,
        clk => TCK
    );

    cell2: bsc port map(
        pIn => DIN(1),
        pOut => DOUT(1),
        sIn => cell1_to_cell2,
        sOut => cell2_to_cell3,
        clockDR => clockDR,
        updateDR => updateDR,
        shiftDR => shiftDR,
        mode => mode,
        clk => TCK
    );

    cell3: bsc port map(
        pIn => DIN(2),
        pOut => DOUT(2),
        sIn => cell2_to_cell3,
        sOut => cell3_to_cell4,
        clockDR => clockDR,
        updateDR => updateDR,
        shiftDR => shiftDR,
        mode => mode,
        clk => TCK
    );

    cell4: bsc port map(
        pIn => DIN(3),
        pOut => DOUT(3),
        sIn => cell3_to_cell4,
        sOut => cell4_to_cell5,
        clockDR => clockDR,
        updateDR => updateDR,
        shiftDR => shiftDR,
        mode => mode,
        clk => TCK
    );

    cell5: bsc port map(
        pIn => DIN(4),
        pOut => DOUT(4),
        sIn => cell4_to_cell5,
        sOut => cell5_to_cell6,
        clockDR => clockDR,
        updateDR => updateDR,
        shiftDR => shiftDR,
        mode => mode,
        clk => TCK
    );

    cell6: bsc port map(
        pIn => DIN(5),
        pOut => DOUT(5),
        sIn => cell5_to_cell6,
        sOut => TDO,
        clockDR => clockDR,
        updateDR => updateDR,
        shiftDR => shiftDR,
        mode => mode,
        clk => TCK
    );
end arch;
