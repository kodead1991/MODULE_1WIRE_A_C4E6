library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- TODO 
-- 1) В модуле 1_WIRE убрать старый код
-- 2) В модуле 1_WIRE добавить чтение ID из BRAM
-- 3) В модуле 1_WIRE добавить формирование слова TEMP (с флагом и TEMP)
-- 4) В модуле 1_WIRE добавить запись TEMP в BRAM
-- 4) В модуле TOP добавить модуль 1_WIRE

library work;
use work.pack.all;

entity TOP is
  port (
    CLK_50MHz : in std_logic;
    CLK_16MHz : in std_logic;

    -- Светодиоды
    LED_D3 : out std_logic := '1';
    LED_D4 : out std_logic := '1';
    LED_D5 : out std_logic := '1';
    LED_D6 : out std_logic := '1';
    LED_D7 : out std_logic := '1';
    LED_D8 : out std_logic := '1';

    -- Отладочные ножки
    p28 : inout std_logic := 'Z';
    p30 : out std_logic   := '1';
    p32 : out std_logic   := '1';
    p33 : out std_logic   := '1';
    p38 : out std_logic   := '1';
    p39 : out std_logic   := '1';
    p42 : out std_logic   := '1';
    p43 : out std_logic   := '1';
    p44 : out std_logic   := '1';
    p46 : out std_logic   := '1';
    p49 : out std_logic   := '1';

    -- UART
    p113 : out std_logic := '1'; -- TX
    p114 : in std_logic;         -- RX

    -- 7-сегментный дисплей
    p127 : out std_logic := '1'; -- A
    p126 : out std_logic := '1'; -- B
    p125 : out std_logic := '1'; -- C
    p124 : out std_logic := '1'; -- D
    p121 : out std_logic := '1'; -- E
    p120 : out std_logic := '1'; -- F
    p119 : out std_logic := '1'; -- G
    p115 : out std_logic := '1'; -- DP
    p128 : out std_logic := '1'; -- BIT0
    p129 : out std_logic := '1'; -- BIT1
    p132 : out std_logic := '1'; -- BIT2
    p133 : out std_logic := '1'; -- BIT3
    p135 : out std_logic := '1'; -- BIT4
    p136 : out std_logic := '1'; -- BIT5
    p137 : out std_logic := '1'; -- BIT6
    p138 : out std_logic := '1'  -- BIT7
  );
end entity;

architecture RTL of TOP is

  -- =========================================================================
  -- TEST REG
  -- =========================================================================
  signal r_Cnt  : unsigned(15 downto 0)         := (others => '0');
  signal r_Test : std_logic_vector(15 downto 0) := (others => '0');

  -- =========================================================================
  -- MHz & kHz GENERATOR
  -- =========================================================================
  signal r_MHz_1 : std_logic := '0';
  signal r_kHz_1 : std_logic := '0';

  -- =========================================================================
  -- 1-WIRE
  -- =========================================================================
  type sens_array is array (0 to 7) of std_logic_vector(7 downto 0);
  signal r_SENS_RAM : sens_array                    := (x"10", x"45", x"FA", x"E8", x"01", x"08", x"00", x"F6");
  signal r_ID_DATA  : std_logic_vector(31 downto 0) := (others => '0');
  signal r_ID_ADDR  : std_logic_vector(6 downto 0)  := (others => '0');

  signal r_TEMP_DATA : std_logic_vector(31 downto 0) := (others => '0');
  signal r_TEMP_ADDR : std_logic_vector(5 downto 0)  := (others => '0');
  signal r_TEMP_WE   : std_logic                     := '0';

  signal r_LINE1_1WIRE_IN  : std_logic := 'Z';
  signal r_LINE1_1WIRE_OUT : std_logic := 'Z';

  -- =========================================================================
  -- 7-сегментный дисплей
  -- =========================================================================
  type digit_array is array (0 to 15) of std_logic_vector(3 downto 0);
  constant c_Digit_Data : digit_array := (x"0", x"1", x"2", x"3", x"4", x"5", x"6", x"7", x"8", x"9", x"A", x"B", x"C", x"D", x"E", x"F");
  type seg_array is array (0 to 15) of std_logic_vector(7 downto 0);
  constant c_SEG_Data : seg_array := (c_SEG_0, c_SEG_1, c_SEG_2, c_SEG_3, c_SEG_4, c_SEG_5, c_SEG_6, c_SEG_7, c_SEG_8, c_SEG_9, c_SEG_A, c_SEG_B, c_SEG_C, c_SEG_D, c_SEG_E, c_SEG_F);
  signal r_SEG_Pos    : seg_array := (others => (others => '0'));

  signal r_Data : std_logic_vector(31 downto 0) := (x"12345678");

  signal r_ClkDivCnt : unsigned(9 downto 0)         := (others => '0');
  signal r_BitNum    : unsigned(7 downto 0)         := x"FE";
  signal r_Segment   : std_logic_vector(7 downto 0) := (others => '0');
begin

  -- =========================================================================
  -- Тестовые ножки
  -- ========================================================================= 

  p30 <= r_Test(0);
  p32 <= r_Test(1);
  p33 <= r_Test(2);
  p38 <= r_Test(3);
  p42 <= r_Test(4);
  p43 <= r_Test(5);
  p44 <= r_Test(6);
  p46 <= r_Test(7);
  p49 <= r_Test(8);

  process (CLK_16MHz)
  begin
    if rising_edge(CLK_16MHz) then
      r_Cnt <= r_Cnt + 1;
    end if;
  end process;

  --r_Test(7 downto 0) <= std_logic_vector(r_BitNum);

  --r_Test <= std_logic_vector(r_Cnt);

  -- r_Test(0) <= CLK_16MHz;
  -- r_Test(1) <= r_MHz_1;
  -- r_Test(2) <= r_kHz_1;
  -- r_Test(3) <= '0';
  -- r_Test(4) <= '0';
  -- r_Test(5) <= '0';
  -- r_Test(6) <= '0';
  -- r_Test(7) <= '0';
  -- r_Test(8) <= '0';
  -- r_Test(9) <= '0';

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

    variable v_MHz_Cnt : integer range 0 to c_MHz_1_TICKS := 0;
    variable v_kHz_Cnt : integer range 0 to c_kHz_1_TICKS := 0;
  begin
    if rising_edge(CLK_16MHz) then
      if (v_MHz_Cnt = c_MHz_1_TICKS - 1) then
        v_MHz_Cnt := 0;
        r_MHz_1 <= '1';
        if (v_kHz_Cnt = c_kHz_1_TICKS - 1) then
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
  r_ID_DATA <= x"000000" & r_SENS_RAM(to_integer(unsigned(r_ID_ADDR(2 downto 0))));

  ONE_WIRE_BLOCK_v5_1_inst : entity work.ONE_WIRE_BLOCK_v5_1
    port map
    (
      i_Clk           => CLK_16MHz,
      i_MHz_1         => r_MHz_1,
      i_kHz_1         => r_kHz_1,
      i_ID_RAM_DATA   => r_ID_DATA,
      o_ID_RAM_ADDR   => r_ID_ADDR,
      o_TEMP_RAM_WE   => r_TEMP_WE,
      o_TEMP_RAM_DATA => r_TEMP_DATA,
      o_TEMP_RAM_ADDR => r_TEMP_ADDR,
      i_LINE1_1WIRE   => r_LINE1_1WIRE_IN,
      i_LINE2_1WIRE   => '1',
      i_LINE3_1WIRE   => '1',
      i_LINE4_1WIRE   => '1',
      o_LINE1_1WIRE   => r_LINE1_1WIRE_OUT,
      o_LINE2_1WIRE   => open,
      o_LINE3_1WIRE   => open,
      o_LINE4_1WIRE   => open,
      o_Test          => r_Test
    );

  r_LINE1_1WIRE_IN <= p28;
  p28              <= '0' when (r_LINE1_1WIRE_OUT = '0') else 'Z';

  -- ======================================================
  -- 7-сегментный дисплей
  -- ======================================================
  process (CLK_16MHz)
    variable v_Scan_Cnt     : unsigned(10 downto 0)        := (others => '0');
    variable v_Digit_Select : integer                      := 0;
    variable v_Cur_Nibble   : std_logic_vector(3 downto 0) := (others => '0');
    variable v_Temp_Value   : integer range 0 to 1250; -- 0..1250 (0..125.0°C с 0.1 точностью)
    variable v_Temp_Int     : integer range 0 to 125;  -- Целая часть (0-125)
  begin

    if rising_edge(CLK_16MHz) then

      -- Фиксация данных от модуля 1-WIRE
      if (r_TEMP_WE = '1' and r_TEMP_ADDR(5 downto 0) = "000000") then
        r_Data <= r_TEMP_DATA;
        v_Temp_Value := to_integer(unsigned(r_TEMP_DATA(15 downto 0))) * 5; -- Умножаем на 5 для 0.1 точности
        v_Temp_Int   := v_Temp_Value / 10;                                  -- Целая часть
        -- десятки градусов (0-9)
        r_Data(23 downto 20) <= std_logic_vector(to_unsigned(v_Temp_Int / 10, 4));
        -- единицы градусов (0-9)
        r_Data(19 downto 16) <= std_logic_vector(to_unsigned(v_Temp_Int mod 10, 4));
      end if;

      -- Счетчик для сканирования (частота обновления ~1-2 кГц)
      v_Scan_Cnt := v_Scan_Cnt + 1;

      -- Меняем дисплей каждые 2048 тактов (16MHz/2048 ≈ 7.8kHz)
      if (v_Scan_Cnt = 0) then
        if (v_Digit_Select = 7) then
          v_Digit_Select := 0;
        else
          v_Digit_Select := v_Digit_Select + 1;
        end if;
      end if;

      -- Выбираем какой ниббл (4 бита) отображать на текущем дисплее
      -- Дисплей 0 показывает младший ниббл байта 7 (самый правый)
      -- Дисплей 7 показывает старший ниббл байта 0 (самый левый)
      case v_Digit_Select is
        when 0      => v_Cur_Nibble      := r_Data(3 downto 0);
        when 1      => v_Cur_Nibble      := r_Data(7 downto 4);
        when 2      => v_Cur_Nibble      := r_Data(11 downto 8);
        when 3      => v_Cur_Nibble      := r_Data(15 downto 12);
        when 4      => v_Cur_Nibble      := r_Data(19 downto 16);
        when 5      => v_Cur_Nibble      := r_Data(23 downto 20);
        when 6      => v_Cur_Nibble      := r_Data(27 downto 24);
        when 7      => v_Cur_Nibble      := r_Data(31 downto 28);
        when others => v_Cur_Nibble := x"0";
      end case;

      -- Преобразование 4-битного значения в 7-сегментный код (активный LOW)
      case v_Cur_Nibble is
        when x"0"   => r_Segment   <= c_SEG_0;
        when x"1"   => r_Segment   <= c_SEG_1;
        when x"2"   => r_Segment   <= c_SEG_2;
        when x"3"   => r_Segment   <= c_SEG_3;
        when x"4"   => r_Segment   <= c_SEG_4;
        when x"5"   => r_Segment   <= c_SEG_5;
        when x"6"   => r_Segment   <= c_SEG_6;
        when x"7"   => r_Segment   <= c_SEG_7;
        when x"8"   => r_Segment   <= c_SEG_8;
        when x"9"   => r_Segment   <= c_SEG_9;
        when x"A"   => r_Segment   <= c_SEG_A;
        when x"B"   => r_Segment   <= c_SEG_B;
        when x"C"   => r_Segment   <= c_SEG_C;
        when x"D"   => r_Segment   <= c_SEG_D;
        when x"E"   => r_Segment   <= c_SEG_E;
        when x"F"   => r_Segment   <= c_SEG_F;
        when others => r_Segment <= c_SEG_BLANK;
      end case;

      -- ВАЖНО: сначала ВЫКЛЮЧАЕМ ВСЕ дисплеи
      p128 <= '1';
      p129 <= '1';
      p132 <= '1';
      p133 <= '1';
      p135 <= '1';
      p136 <= '1';
      p137 <= '1';
      p138 <= '1';

      -- Выбор активного дисплея (активный НИЗКИЙ уровень)       
      case v_Digit_Select is
        when 0      => p128 <= '0'; -- DIG0 (левый дисплей)
        when 1      => p129 <= '0'; -- DIG1
        when 2      => p132 <= '0'; -- DIG2
        when 3      => p133 <= '0'; -- DIG3
        when 4      => p135 <= '0'; -- DIG4
        when 5      => p136 <= '0'; -- DIG5
        when 6      => p137 <= '0'; -- DIG6
        when 7      => p138 <= '0'; -- DIG7 (правый дисплей)
        when others => null;
      end case;

      -- for i in 0 to 7 loop
      --   if (r_Data(i * 4 + 3 downto i * 4) = c_Digit_Data(i)) then
      --     r_SEG_Pos(i) <= c_SEG_Data(i);
      --   end if;
      -- end loop;

      -- r_ClkDivCnt <= r_ClkDivCnt + 1;

      -- if (r_ClkDivCnt = 0) then
      --   r_BitNum <= r_BitNum(6 downto 0) & r_BitNum(7);
      -- end if;

      -- case (r_BitNum) is
      --   when x"FE"  => r_Segment  <= r_SEG_Pos(0);
      --   when x"FD"  => r_Segment  <= r_SEG_Pos(1);
      --   when x"FB"  => r_Segment  <= r_SEG_Pos(2);
      --   when x"F7"  => r_Segment  <= r_SEG_Pos(3);
      --   when x"EF"  => r_Segment  <= r_SEG_Pos(4);
      --   when x"DF"  => r_Segment  <= r_SEG_Pos(5);
      --   when x"BF"  => r_Segment  <= r_SEG_Pos(6);
      --   when x"7F"  => r_Segment  <= r_SEG_Pos(7);
      --   when others => r_Segment <= c_SEG_BLANK;
      -- end case;

    end if;
  end process;

  -- Подключение сегментов
  p127 <= r_Segment(0); -- A
  p126 <= r_Segment(1); -- B
  p125 <= r_Segment(2); -- C
  p124 <= r_Segment(3); -- D
  p121 <= r_Segment(4); -- E
  p120 <= r_Segment(5); -- F
  p119 <= r_Segment(6); -- G
  p115 <= r_Segment(7); -- DP

  -- -- Подключение битовых линий
  -- p128 <= r_BitNum(0); -- BIT0
  -- p129 <= r_BitNum(1); -- BIT1
  -- p132 <= r_BitNum(2); -- BIT2
  -- p133 <= r_BitNum(3); -- BIT3
  -- p135 <= r_BitNum(4); -- BIT4
  -- p136 <= r_BitNum(5); -- BIT5
  -- p137 <= r_BitNum(6); -- BIT6
  -- p138 <= r_BitNum(7); -- BIT7

end architecture;