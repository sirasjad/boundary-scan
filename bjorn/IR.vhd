library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instructiondecoder is
  port (
    data_in, clock, set, shift, reset: in std_logic;
    data_out: out std_logic;
    -- Data multiplexer out -> '0' for selecting BSR, '1' for Bypass Register
    data_mux_out: out std_logic;
    -- Cell control outputs
    cell_test_mode_out,cell_keep_test_mode_out: out std_logic;
    cell_capture_out, cell_keep_capture_out: out std_logic

 );
end instructiondecoder;

architecture arch of instructiondecoder is
  constant EXTEST_CODE: std_logic_vector(1 downto 0) := "00";
  constant SAMPLE_CODE: std_logic_vector(1 downto 0) := "01";
  constant PRELOAD_CODE: std_logic_vector(1 downto 0) := "10";
  constant BYPASS_CODE: std_logic_vector(1 downto 0) := "11";
  type state_type is (extest, sample, preload, bypass);

  signal state: state_type;
  -- signal instruction_register: std_logic_vector(1 downto 0);
  signal data_buffer: std_logic_vector(1 downto 0);

  -- The numeric_std functions `shit_left` and `shift_right` do not allow one
  -- to shift a value in and return it.
  -- impure function shift_in(value: std_logic) return std_logic is
  --   signal temporary: std_logic;
  -- begin
  --   temporary <= data_buffer(0);
  --   data_buffer(0) <= data_buffer(1);
  --   data_buffer(1) <= value;
  --   return temporary;
  -- end function;

begin
  process(clock, reset, set)
  begin
    if rising_edge(clock) then
      if shift <= '1' then
        -- shift data_in into data_buffer
        data_out <= data_buffer(0);
        data_buffer(0) <= data_buffer(1);
        data_buffer(1) <= data_in;
      -- data_out <= shift_in(data_in);
      end if;
    end if;
    if reset = '1' then
      state <= bypass;
      data_buffer <= "01"; -- to shift out 01 at the end according to
                           -- the standard
      data_out <= '0';
    end if;
    if rising_edge(set) then
      if data_buffer = EXTEST_CODE then state <= extest;
        elsif data_buffer = SAMPLE_CODE then state <= sample;
        elsif data_buffer = PRELOAD_CODE then state <= preload;
        elsif data_buffer = BYPASS_CODE then state <= bypass;
      end if;
    end if;
  end process;

  -- process(set)
  -- begin
  --     -- For some reason this case statement didn't work
  --     -- case data_buffer is
  --     --   when EXTEST_CODE => state <= extest;
  --     --   when SAMPLE_CODE => state <= sample;
  --     --   when PRELOAD_CODE => state <= preload;
  --     --   when BYPASS_CODE => state <= bypass;
  --     -- end case;
  --   end if;
  -- end process;

  -- Cell control based on state
  process(state)
  begin
    if state = extest then
      -- Enable test mode
      cell_capture_out <= '0';
      --cell_keep_capture_out <= '1';
      cell_keep_test_mode_out<='1';
      cell_test_mode_out <= '1';
    elsif state = sample then
      cell_capture_out <= '1';
      cell_keep_capture_out <= '0';
      cell_test_mode_out <= '0';
    elsif state = preload then
      cell_capture_out <= '1';
      cell_keep_capture_out <= '0';
      cell_test_mode_out <= '0';
    elsif state = bypass then
      cell_capture_out <= '0';
      cell_test_mode_out <= '0';
      cell_keep_capture_out <= '1';
    end if;
  end process;

  -- Enable or disable bypass stuff
  data_mux_out <= '1' when state = bypass else '0';
end arch;
