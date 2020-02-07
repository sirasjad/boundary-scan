-- Top-level design
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    port(
        TDI: in std_logic; -- Test Data In
        TCK: in std_logic; -- Test Clock
        TMS: in std_logic; -- Test Mode Select
        TDO: out std_logic; -- Test Data Out
        --BP: in std_logic -- Bypass register
        dataOutFromIR: out std_logic
    );
end top_level;

architecture arch of top_level is
    component instructiondecoder is
        port(
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
        port(
            TMS: in std_logic;
            TCK: in std_logic;
            TLR, capt_DR, shift_DR, updt_DR, capt_IR, shift_IR, updt_IR : out std_logic
        );
    end component;

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
        sel => dataOutFromIR; -- 1 for bypass?
        out0 => datamux_to_instrmux
    );

    instr_mux: mux port map(
        in0 => datamux_to_instrmux;
        in1 => IR -- ?
        sel => BP_mode;
        out0 => TDO
    );

    IR: instructiondecoder port map(
        data_in => TDI, data_out => dataOutFromIR, clock=>tck, set=>updt_IR, 
        shift => shift_IR, cell_test_mode_out => cell_test_mode_out,
        --cell_keep_test_mode_out=>cell_keep_test_mode_out,
        cell_capture_out => cell_capture_out,
        cell_keep_capture_out => cell_keep_capture_out, reset => TLR
    );

begin
    process(TCK)
    begin
        --if(BP = '1') then
        if(dataOutFromIR = '1') then
            TDO <= TDI;
        end if;
    end process;
end arch;
