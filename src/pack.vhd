library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pack is

  -- =========================================================================
  -- КОНСТАНТЫ ПРОЕКТА
  -- =========================================================================
  -- Default
  constant c_SysFreq  : integer := 16384000; -- 16,384 MHz
  constant c_LINE_NUM : integer := 4;        -- количество линий 1-Wire

  -- Константы для основного автомата
  constant c_PRESENCE_WAIT_ZERO : unsigned(15 downto 0) := to_unsigned(120, 16); -- us
  constant c_PRESENCE_WAIT_ONE  : unsigned(15 downto 0) := to_unsigned(480, 16); -- us
  constant c_CONVERT_TIME       : unsigned(15 downto 0) := to_unsigned(400, 16); -- ms

  -- Константы для автомата выдачи/приёма байт
  constant c_BITSLOT_MAX_LOW : unsigned(5 downto 0) := to_unsigned(15, 6); -- us
  constant c_BITSLOT_READTIME : unsigned(5 downto 0) := to_unsigned(15, 6); -- us
  constant c_BITSLOT_DUR     : unsigned(5 downto 0) := to_unsigned(60, 6); -- us

  -- Команды
  constant c_CMD_SKIP_ROM        : std_logic_vector(7 downto 0) := x"CC";
  constant c_CMD_CONVERT         : std_logic_vector(7 downto 0) := x"44";
  constant c_CMD_MATCH_ROM       : std_logic_vector(7 downto 0) := x"55";
  constant c_CMD_READ_SCRATCHPAD : std_logic_vector(7 downto 0) := x"BE";

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