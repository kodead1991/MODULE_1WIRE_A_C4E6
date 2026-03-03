library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TOP is
  port (
    CLK_50MHz : in std_logic;
    CLK_16MHz : in std_logic;

    -- Светодиоды
    LED_D3 : out std_logic;
    LED_D4 : out std_logic;
    LED_D5 : out std_logic;
    LED_D6 : out std_logic;
    LED_D7 : out std_logic;
    LED_D8 : out std_logic;

    -- Отладочные ножки
    p28 : out std_logic;
    p30 : out std_logic;
    p32 : out std_logic;
    p33 : out std_logic;
    p38 : out std_logic;
    p39 : out std_logic;
    p42 : out std_logic;
    p43 : out std_logic;
    p44 : out std_logic;
    p46 : out std_logic;
    p49 : out std_logic;

    -- UART
    p113 : out std_logic; -- TX
    p114 : in std_logic;  -- RX

    -- 7-сегментный дисплей
    p127 : out std_logic; -- A
    p126 : out std_logic; -- B
    p125 : out std_logic; -- C
    p124 : out std_logic; -- D
    p121 : out std_logic; -- E
    p120 : out std_logic; -- F
    p119 : out std_logic; -- G
    p115 : out std_logic; -- DP
    p128 : out std_logic; -- BIT0
    p129 : out std_logic; -- BIT1
    p132 : out std_logic; -- BIT2
    p133 : out std_logic; -- BIT3
    p135 : out std_logic; -- BIT4
    p136 : out std_logic; -- BIT5
    p137 : out std_logic; -- BIT6
    p138 : out std_logic  -- BIT7
  );
end entity;

architecture RTL of TOP is

  -- =========================================================================
  -- TEST REG
  -- =========================================================================
  signal r_Cnt  : unsigned(15 downto 0)        := (others => '0');
  signal r_Test : std_logic_vector(15 downto 0) := (others => '0');
  
  -- =========================================================================
  -- MHz & kHz GENERATOR
  -- =========================================================================
  signal r_MHz_1  : std_logic        := '0';
  signal r_kHz_1  : std_logic        := '0';
  
begin
  
  p28 <= r_Cnt(5);
  p30 <= r_Cnt(6);
  p32 <= r_Cnt(7);
  p33 <= r_Cnt(8);
  p38 <= r_Cnt(9);
  p39 <= r_Cnt(10);
  p42 <= r_Cnt(11);
  p43 <= r_Cnt(12);
  p44 <= r_Cnt(13);
  p46 <= r_Cnt(14);
  p49 <= r_Cnt(15);
  
  process (CLK_16MHz)
  begin
    if rising_edge(CLK_16MHz) then
      r_Cnt <= r_Cnt + 1;
    end if;
  end process;

    -- =========================================================================
  -- MHz & kHz GENERATOR
  -- =========================================================================  
  process (CLK_16MHz)
    constant c_MHz_1_TICKS    : integer := 16;
    constant c_kHz_1_TICKS    : integer := 1000;
    constant c_kHz_1_2_TICKS  : integer := 500;
    constant c_kHz_1_4_TICKS  : integer := 250;
    constant c_kHz_1_8_TICKS  : integer := 125;
    constant c_kHz_1_16_TICKS : integer := 68;

    variable v_MHz_Cnt : integer range 0 to c_MHz_1_TICKS    := 0;
    variable v_kHz_Cnt : integer range 0 to c_kHz_1_16_TICKS := 0;
  begin
    if rising_edge(CLK_16MHz) then
      if (v_MHz_Cnt = c_MHz_1_TICKS - 1) then
        v_MHz_Cnt := 0;
        r_MHz_1 <= '1';
        if (v_kHz_Cnt = c_kHz_1_16_TICKS - 1) then
          v_kHz_Cnt := 0;
          r_kHz_1 <= '1';
        else
          v_kHz_Cnt := v_kHz_Cnt + 1;
          r_kHz_1 <= '0';
        end if;
      else
        v_MHz_Cnt := v_MHz_Cnt + 1;
        r_MHz_1 <= '0';
      end if;
    end if;
  end process;
  
  -- =========================================================================
  -- 1-WIRE
  -- =========================================================================
ONE_WIRE_BLOCK_v5_1_inst: entity work.ONE_WIRE_BLOCK_v5_1
 port map(
    i_Clk => CLK_16MHz,
    i_1MHz => r_MHz_1,
    i_1kHz => r_kHz_1,
    i_ID_DATA => (others => '0'),
    o_ID_ADDR => open,
    o_TEMP_ADDR => open,
    o_TEMP_WR => open,
    o_LINE1_TEMP_DATA => open,
    o_LINE2_TEMP_DATA => open,
    o_LINE3_TEMP_DATA => open,
    o_LINE4_TEMP_DATA => open,
    i_LINE1_1WIRE => i_LINE1_1WIRE,
    i_LINE2_1WIRE => '0',
    i_LINE3_1WIRE => '0',
    i_LINE4_1WIRE => '0',
    o_LINE1_1WIRE => open,
    o_LINE2_1WIRE => open,
    o_LINE3_1WIRE => open,
    o_LINE4_1WIRE => open,
    o_Test => r_Test
);

end architecture;