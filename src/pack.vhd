library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

package pack is

  -- =========================================================================
  -- КОНСТАНТЫ ПРОЕКТА
  -- =========================================================================
  -- Default
  constant c_SysFreq  : integer := 16384000; -- 16,384 MHz
  constant c_LINE_NUM : integer := 4;        -- количество линий 1-Wire

  -- Карта памяти
  constant c_BASE_FPGA_ID : unsigned(15 downto 0) := x"0000";
  constant c_BASE_ID_RAM  : unsigned(15 downto 0) := x"1000";

  -- Константы для основного автомата
  constant c_SENS_NUM           : integer               := 16;
  constant c_PRESENCE_WAIT_ZERO : unsigned(15 downto 0) := to_unsigned(120, 16); -- us
  constant c_PRESENCE_WAIT_ONE  : unsigned(15 downto 0) := to_unsigned(480, 16); -- us
  constant c_CONVERT_TIME       : unsigned(15 downto 0) := to_unsigned(800, 16); -- ms

  -- Константы для автомата выдачи/приёма байт
  constant c_BITSLOT_START_LOW : unsigned(5 downto 0) := to_unsigned(10, 6); -- us
  constant c_BITSLOT_READTIME  : unsigned(5 downto 0) := to_unsigned(15, 6); -- us
  constant c_BITSLOT_DUR       : unsigned(5 downto 0) := to_unsigned(60, 6); -- us

  -- Команды
  constant c_CMD_SKIP_ROM        : std_logic_vector(7 downto 0) := x"CC";
  constant c_CMD_CONVERT         : std_logic_vector(7 downto 0) := x"44";
  constant c_CMD_MATCH_ROM       : std_logic_vector(7 downto 0) := x"55";
  constant c_CMD_READ_SCRATCHPAD : std_logic_vector(7 downto 0) := x"BE";

  -- ============================================================
  -- 7-сегментный дисплей (общий анод - active LOW)
  --    A
  --  F   B
  --    G
  --  E   C
  --    D   DP
  -- ============================================================
  -- Цифры
  constant c_SEG_0 : std_logic_vector(7 downto 0) := "11000000"; -- 0
  constant c_SEG_1 : std_logic_vector(7 downto 0) := "11111001"; -- 1
  constant c_SEG_2 : std_logic_vector(7 downto 0) := "10100100"; -- 2
  constant c_SEG_3 : std_logic_vector(7 downto 0) := "10110000"; -- 3
  constant c_SEG_4 : std_logic_vector(7 downto 0) := "10011001"; -- 4
  constant c_SEG_5 : std_logic_vector(7 downto 0) := "10010010"; -- 5
  constant c_SEG_6 : std_logic_vector(7 downto 0) := "10000010"; -- 6
  constant c_SEG_7 : std_logic_vector(7 downto 0) := "11111000"; -- 7
  constant c_SEG_8 : std_logic_vector(7 downto 0) := "10000000"; -- 8
  constant c_SEG_9 : std_logic_vector(7 downto 0) := "10010000"; -- 9

  -- Буквы
  constant c_SEG_A : std_logic_vector(7 downto 0) := "10001000"; -- A
  constant c_SEG_B : std_logic_vector(7 downto 0) := "10000011"; -- B
  constant c_SEG_C : std_logic_vector(7 downto 0) := "11000110"; -- C
  constant c_SEG_D : std_logic_vector(7 downto 0) := "10100001"; -- D
  constant c_SEG_E : std_logic_vector(7 downto 0) := "10000110"; -- E
  constant c_SEG_F : std_logic_vector(7 downto 0) := "10001110"; -- F

  -- Дополнительные символы
  constant c_SEG_MINUS : std_logic_vector(7 downto 0) := "10111111"; -- - (минус, только сегмент G)
  constant c_SEG_BLANK : std_logic_vector(7 downto 0) := "11111111"; -- все сегменты выключены
  constant c_SEG_DOTS  : std_logic_vector(7 downto 0) := "01111111"; -- только десятичная точка
  constant c_SEG_UNDER : std_logic_vector(7 downto 0) := "11110111"; -- нижнее подчеркивание (сегмент D)



end package;

-- package body pack is

--   -- =========================================================================
--   -- Определение констант
--   -- =========================================================================

--   -- Константы для основного автомата
--   constant c_PRESENCE_WAIT_ZERO : unsigned(15 downto 0) := to_unsigned(120, 16);
--   constant c_PRESENCE_WAIT_ONE  : unsigned(15 downto 0) := to_unsigned(480, 16);
--   constant c_CONVERT_TIME       : unsigned(15 downto 0) := to_unsigned(400, 16);

--   -- Константы для автомата выдачи/приёма байт
--   constant c_BITSLOT_DUR : unsigned(15 downto 0) := to_unsigned(60, 16);

--   -- Команды
--   constant c_CMD_SKIP_ROM        : std_logic_vector(7 downto 0) := x"CC";
--   constant c_CMD_MATCH_ROM       : std_logic_vector(7 downto 0) := x"55";
--   constant c_CMD_CONVERT         : std_logic_vector(7 downto 0) := x"44";
--   constant c_CMD_READ_SCRATCHPAD : std_logic_vector(7 downto 0) := x"BE";
-- end package body;