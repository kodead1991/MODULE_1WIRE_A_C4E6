library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Описание
-- Чтение ID происходит из 4 стоблцов памяти одновременно. 
-- Необходима память х32 бит (4 байта) * 8 байт на датчик * 16 дачиков.
-- Это эквивалентно 512 байтам или 1 блоку BRAM => DPRAM_x32_128

-- Запись происходит построчно, 1 адрес - 1 датчик.
-- Необходима память х32 бит (4 байта) * 4 байта на датчик * 16 датчиков.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

library work;
use work.pack.all;

entity ONE_WIRE_BLOCK_v5_1 is

  port (
    i_Clk   : in std_logic;
    i_MHz_1 : in std_logic;
    i_kHz_1 : in std_logic;
    ---
    i_ID_RAM_DATA : in std_logic_vector(31 downto 0) := (others => '0');
    o_ID_RAM_ADDR : out std_logic_vector(6 downto 0) := (others => '0');
    ---
    o_TEMP_RAM_WE   : out std_logic                     := '0';
    o_TEMP_RAM_DATA : out std_logic_vector(31 downto 0) := (others => '0');
    o_TEMP_RAM_ADDR : out std_logic_vector(5 downto 0)  := (others => '0');
    ---
    i_LINE1_1WIRE : in std_logic;
    i_LINE2_1WIRE : in std_logic;
    i_LINE3_1WIRE : in std_logic;
    i_LINE4_1WIRE : in std_logic;
    ---
    o_LINE1_1WIRE : out std_logic := '1';
    o_LINE2_1WIRE : out std_logic := '1';
    o_LINE3_1WIRE : out std_logic := '1';
    o_LINE4_1WIRE : out std_logic := '1';
    ---
    o_Test : out std_logic_vector(15 downto 0) := (others => '0')
  );
end entity;

architecture RTL of ONE_WIRE_BLOCK_v5_1 is

  -- Тестовый счётчик
  signal r_Cnt : unsigned(15 downto 0) := (others => '0');

  -- Основной автомат
  type state_main is (
    s_IDLE,           -- ожидание старта
    s_RESET,          -- начало сброса
    s_PRESENCE,       -- ожидание presence impulse 
    s_PRESENCE_CHECK, -- Проверка ответа

    -- Для CONVERT (общая команда)
    s_SKIP_ROM,     -- Отправка 0xCC (обращение ко всем датчикам)
    s_CONVERT,      -- Отправка 0x44 (подготовка данных)
    s_CONVERT_WAIT, -- Ожидание 750 мс

    -- Для READ (по ID)
    s_MATCH_ROM,                -- Отправка 0x55
    s_SEND_ROM_BYTE,            -- Цикл отправки 8 байт ID
    s_WAIT_ID_RAM_DATA,         -- Ожидание данных от ID RAM
    s_READ_SCRATCHPAD,          -- Отправка 0xBE
    s_READ_DATA,                -- Чтение 9 байт
    s_TEMP_RAM_WRITE_ENABLE,    -- Разрешение на запись в TEMP RAM
    s_TEMP_RAM_DATA_PREPARE_1,  -- Подготовка данных (Ст.) для записи в TEMP RAM
    s_TEMP_RAM_DATA_SET_WE_1,   -- Установка сигнала WE для TEMP RAM
    s_TEMP_RAM_DATA_RESET_WE_1, -- Сброс сигнала WE для TEMP RAM
    s_TEMP_RAM_DATA_PREPARE_2,  -- Подготовка данных (Мл.) для записи в TEMP RAM
    s_TEMP_RAM_DATA_SET_WE_2,   -- Установка сигнала WE для TEMP RAM
    s_TEMP_RAM_DATA_RESET_WE_2, -- Сброс сигнала WE для TEMP RAM
    s_TEMP_RAM_ADDR_INCR        -- Сброс сигнала WE для TEMP RAM
  );
  signal r_State_1WIRE : state_main := s_IDLE;

  -- Направление цикла основного автомата
  signal r_CMD_type : std_logic := '0'; -- convert = 0, read = 1

  -- Автомат передачи данных
  type state_xfer is (
    s_XFER_IDLE,           -- Ожидание старта
    s_XFER_START_SLOT,     -- Начало слота
    s_XFER_DRIVE_LOW,      -- Сброс линии в 0
    s_XFER_READ_DATA,      -- Считывание данных
    s_XFER_RELEASE_BUS_TX, -- Отпуск шины после записи
    s_XFER_RELEASE_BUS_RX, -- Отпуск шины после чтения
    s_XFER_DONE            -- Завершение слота
  );
  signal r_State_Xfer : state_xfer := s_XFER_IDLE;

  -- 1WIRE входы
  signal r_LINE_1WIRE_IN : std_logic_vector(c_LINE_NUM - 1 downto 0) := (others => '1');

  -- 1WIRE выходы
  signal r_LINE_1WIRE_OUT : std_logic_vector(c_LINE_NUM - 1 downto 0) := (others => '1');

  -- Handshake для выдачи/приёма байт (XFER - transfer)
  type word_array is array (0 to c_LINE_NUM - 1) of std_logic_vector(7 downto 0);
  type temp_array is array (0 to c_LINE_NUM - 1) of std_logic_vector(71 downto 0);

  signal r_XFER_Data_Tx : word_array := (others => (others => '0'));
  signal r_XFER_Rx_Data : temp_array := (others => (others => '0'));
  -- signal r_XFER_Start   : std_logic  := '0';
  -- signal r_XFER_Done    : std_logic  := '0';
  signal r_XFER_RW : std_logic := '0'; -- write = 0, read = 1
  -- Проверка PRESENCE
  signal r_Presence_Buf : std_logic_vector(c_LINE_NUM - 1 downto 0) := (others => '0');
  signal r_Presence_OK  : std_logic_vector(c_LINE_NUM - 1 downto 0) := (others => '0');

  -- ID RAM
  signal r_ID_RAM_Addr : unsigned(6 downto 0) := (others => '0');

  -- Буферы хранения CRC8
  type crc8_array is array (0 to c_LINE_NUM - 1) of std_logic_vector(7 downto 0);
  signal r_CRC8      : crc8_array                                := (others => (others => '0'));
  signal r_CRC8_Flag : std_logic_vector(c_LINE_NUM - 1 downto 0) := (others => '0');

  -- TEMP RAM
  -- Автомат передачи данных
  type state_temp is (
    s_TEMP_IDLE, -- Ожидание старта
    s_TEMP_LINE1_SetData,
    s_TEMP_LINE1_SetWe,
    s_TEMP_LINE1_ResetWe,
    s_TEMP_LINE2_SetData,
    s_TEMP_LINE2_SetWe,
    s_TEMP_LINE2_ResetWe,
    s_TEMP_LINE3_SetData,
    s_TEMP_LINE3_SetWe,
    s_TEMP_LINE3_ResetWe,
    s_TEMP_LINE4_SetData,
    s_TEMP_LINE4_SetWe,
    s_TEMP_LINE4_ResetWe,
    s_TEMP_DONE -- Завершение
  );
  signal r_State_Temp        : state_temp           := s_TEMP_IDLE;
  signal r_TEMP_RAM_Addr_Buf : unsigned(3 downto 0) := (others => '0');
  signal r_TEMP_RAM_Addr     : unsigned(5 downto 0) := (others => '0');

  signal r_TEMP_RAM_WE_Start : std_logic                     := '0';
  signal r_TEMP_RAM_Data     : std_logic_vector(31 downto 0) := (others => '0');
  signal r_TEMP_SENS_CNT     : unsigned(3 downto 0)          := (others => '0');
  signal r_TEMP_RAM_WE       : std_logic                     := '0';

begin

  main_process : process (i_Clk)
    -- Основной автомат
    variable v_Cnt_MHz_1 : unsigned(15 downto 0) := (others => '0');
    variable v_Cnt_kHz_1 : unsigned(15 downto 0) := (others => '0');
    -- Автомат обмена байтами
    variable v_Cnt_Slot   : unsigned(5 downto 0) := c_BITSLOT_DUR;
    variable v_Cnt_Bit    : unsigned(6 downto 0) := (others => '0');
    variable v_XFER_Start : bit                  := '0';
    variable v_XFER_Done  : bit                  := '0';

  begin

    if rising_edge(i_Clk) then
      if (i_MHz_1 = '1') then

        -- ================================================================================
        -- Основной автомат
        -- ================================================================================
        case (r_State_1WIRE) is
            --------------------------------------------------------------------------------
          when s_IDLE =>
            if (i_kHz_1 = '1') then
              r_State_1WIRE    <= s_RESET;
              r_ID_RAM_Addr    <= (others => '0'); -- Сброс адресной шины ID RAM
              r_LINE_1WIRE_OUT <= (others => '0'); -- Выставление '0' на линии (сигнал сброса)
            end if;
            --------------------------------------------------------------------------------
          when s_RESET =>
            if (i_kHz_1 = '1') then
              -- Установка линий в ожидание приёма PRESENCE
              r_LINE_1WIRE_OUT <= (others => '1');
              r_State_1WIRE    <= s_PRESENCE;
            end if;
            --------------------------------------------------------------------------------
          when s_PRESENCE =>
            if (v_Cnt_MHz_1 >= c_PRESENCE_WAIT_ZERO) then
              -- Фиксация значения на линиях через период ожидания '0'
              r_Presence_Buf <= r_LINE_1WIRE_IN;
              r_State_1WIRE  <= s_PRESENCE_CHECK;
              v_Cnt_MHz_1 := (others => '0');
            else
              v_Cnt_MHz_1 := v_Cnt_MHz_1 + 1;
            end if;
            --------------------------------------------------------------------------------
          when s_PRESENCE_CHECK =>
            if (v_Cnt_MHz_1 >= c_PRESENCE_WAIT_ONE) then

              -- Проверка смены состояния (с 0 на 1) на линиях через период ожидания '1'
              for i in 0 to c_LINE_NUM - 1 loop
                if (r_Presence_Buf(i) = '0' and r_LINE_1WIRE_IN(i) = '1') then
                  r_Presence_OK(i) <= '1';
                else
                  r_Presence_OK(i) <= '0';
                end if;
              end loop;

              -- Проверка направления "дерева" процесса
              if (r_CMD_type = '0') then
                r_State_1WIRE <= s_SKIP_ROM;
              else
                r_State_1WIRE <= s_MATCH_ROM;
              end if;

              -- Сброс малого счётчика
              v_Cnt_MHz_1 := (others => '0');

            else
              v_Cnt_MHz_1 := v_Cnt_MHz_1 + 1;
            end if;
            --------------------------------------------------------------------------------
          when s_SKIP_ROM =>
            -- Старт выдачи байта SKIP_ROM по линиям
            v_XFER_Start := '1';
            r_XFER_Data_Tx <= (others => c_CMD_SKIP_ROM);
            r_XFER_RW      <= '0'; -- write = 0, read = 1

            -- Ожидание завершения выдачи байта
            if (v_XFER_Done = '1') then
              v_XFER_Start := '0';
              r_State_1WIRE <= s_CONVERT;
            end if;
            --------------------------------------------------------------------------------
          when s_CONVERT =>
            -- Старт выдачи байта CONVERT по линиям
            v_XFER_Start := '1';
            r_XFER_Data_Tx <= (others => c_CMD_CONVERT);
            r_XFER_RW      <= '0'; -- write = 0, read = 1

            -- Ожидание завершения выдачи байта
            if (v_XFER_Done = '1') then
              v_XFER_Start := '0';
              r_State_1WIRE <= s_CONVERT_WAIT;
            end if;
            --------------------------------------------------------------------------------
          when s_CONVERT_WAIT =>
            -- Ожидание подготовки данных температуры
            if (i_kHz_1 = '1') then
              if (v_Cnt_kHz_1 >= c_CONVERT_TIME) then
                r_State_1WIRE <= s_IDLE;
                v_Cnt_kHz_1 := (others => '0');
                r_CMD_type <= '1'; -- переход на ветку считывания данных температуры
              else
                v_Cnt_kHz_1 := v_Cnt_kHz_1 + 1;
              end if;
            end if;
            --------------------------------------------------------------------------------
          when s_MATCH_ROM =>
            -- Старт выдачи байта MATCH_ROM по линиям
            v_XFER_Start := '1';
            r_XFER_Data_Tx <= (others => c_CMD_MATCH_ROM);
            r_XFER_RW      <= '0'; -- write = 0, read = 1

            -- Ожидание завершения выдачи байта
            if (v_XFER_Done = '1') then
              v_XFER_Start := '0';
              r_State_1WIRE <= s_SEND_ROM_BYTE;
            end if;
            --------------------------------------------------------------------------------
          when s_SEND_ROM_BYTE =>
            -- Выдача ID (8 байт в цикле) по линиям

            -- Старт выдачи байта
            v_XFER_Start := '1';
            -- Подготовка байта
            for i in 0 to c_LINE_NUM - 1 loop
              r_XFER_Data_Tx(i) <= i_ID_RAM_DATA(i * 8 + 7 downto i * 8);
            end loop;
            r_XFER_RW <= '0'; -- флаг чтения/записи (write = 0, read = 1)

            -- Ожидание завершения выдачи байта
            if (v_XFER_Done = '1') then
              v_XFER_Start := '0';

              -- Проверка на выдачу всех байт ID
              if (r_ID_RAM_Addr(2 downto 0) /= "111") then
                r_State_1WIRE <= s_WAIT_ID_RAM_DATA; -- Продолжаем выдавать ID
              else
                r_State_1WIRE <= s_READ_SCRATCHPAD; -- Переход к вычитыванию данных с линий
              end if;

              -- Инкремент адреса ID RAM
              r_ID_RAM_Addr <= r_ID_RAM_Addr + 1;
            end if;

            --------------------------------------------------------------------------------
          when s_WAIT_ID_RAM_DATA =>
            -- Ожидание данных от ID RAM
            r_State_1WIRE <= s_SEND_ROM_BYTE;
            --------------------------------------------------------------------------------
          when s_READ_SCRATCHPAD =>
            -- Старт выдачи байта READ_SCRATCHPAD по линиям
            v_XFER_Start := '1';
            r_XFER_Data_Tx <= (others => c_CMD_READ_SCRATCHPAD);
            r_XFER_RW      <= '0'; -- флаг чтения/записи (write = 0, read = 1)

            -- Ожидание завершения выдачи байта
            if (v_XFER_Done = '1') then
              v_XFER_Start := '0';
              r_State_1WIRE <= s_READ_DATA;
            end if;
            --------------------------------------------------------------------------------
          when s_READ_DATA =>
            -- Старт чтения данных по линиям
            v_XFER_Start := '1';
            r_XFER_RW <= '1'; -- флаг чтения/записи (write = 0, read = 1)

            -- Ожидание завершения приёма данных
            if (v_XFER_Done = '1') then
              v_XFER_Start := '0';
              r_CMD_type    <= '0'; -- переход на ветку записи
              r_State_1WIRE <= s_TEMP_RAM_WRITE_ENABLE;
            end if;
            --------------------------------------------------------------------------------
            -- Разрешение на запись в TEMP RAM
          when s_TEMP_RAM_WRITE_ENABLE =>
            r_TEMP_RAM_WE_Start <= '1';
            r_TEMP_RAM_Addr_Buf <= r_TEMP_SENS_CNT;
            r_State_1WIRE       <= s_TEMP_RAM_ADDR_INCR;
            --   --------------------------------------------------------------------------------
            -- Сброс сигнала WE_START для TEMP RAM + проверка на проход всех датчиков
          when s_TEMP_RAM_ADDR_INCR =>
            r_TEMP_RAM_WE_Start <= '0'; -- сброс сигнала разрешения записи в TEMP RAM

            r_TEMP_SENS_CNT <= r_TEMP_SENS_CNT + 1;

            if (r_ID_RAM_Addr(6 downto 3) = to_unsigned(c_SENS_NUM, 4)) then
              r_State_1WIRE <= s_IDLE;
            else
              r_State_1WIRE <= s_MATCH_ROM;
            end if;
            --------------------------------------------------------------------------------
          when others => r_State_1WIRE <= s_IDLE;
        end case;

        -- --------------------------------------------------------------------------------
        -- --------------------------------------------------------------------------------
        -- --------------------------------------------------------------------------------

        -- ================================================================================
        -- Автомат обмена байтами
        -- ================================================================================
        case (r_State_Xfer) is
            --------------------------------------------------------------------------------
          when s_XFER_IDLE =>
            -- Ожидание сигнала старта
            if (v_XFER_Start = '1') then
              v_XFER_Done := '0';
              r_CRC8 <= (others => (others => '0')); -- сброс буфера CRC 
              v_Cnt_Slot := (others => '0');         -- Сброс таймера слота
              v_Cnt_Bit  := (others => '0');         -- Сброс счётчика бит
              r_State_Xfer <= s_XFER_START_SLOT;
            end if;
            --------------------------------------------------------------------------------
          when s_XFER_START_SLOT =>
            v_Cnt_Slot := v_Cnt_Slot + 1;

            for i in 0 to c_LINE_NUM - 1 loop
              r_LINE_1WIRE_OUT(i) <= '0'; -- начало слота (выдача 0)
            end loop;

            if (v_Cnt_Slot = to_unsigned(5, 6)) then
              if (r_XFER_RW = '0') then
                r_State_Xfer <= s_XFER_DRIVE_LOW; -- Выдача данных
              else
                r_State_Xfer <= s_XFER_READ_DATA; -- Приём данных
              end if;
            end if;
            --------------------------------------------------------------------------------
            -- ПЕРЕДАЧА: Сброс линии в 0
          when s_XFER_DRIVE_LOW =>

            v_Cnt_Slot := v_Cnt_Slot + 1;

            for i in 0 to c_LINE_NUM - 1 loop

              -- Формирование данных на линии
              if (v_Cnt_Slot = c_BITSLOT_START_LOW - 1) then
                if (r_XFER_Data_Tx(i)(to_integer(v_Cnt_Bit(2 downto 0))) = '1') then
                  r_LINE_1WIRE_OUT(i) <= '1'; -- отпускаем линию (выдача 1)
                else
                  r_LINE_1WIRE_OUT(i) <= '0'; -- удерживаем линию (выдача 0)
                end if;
              end if;

              -- Удержание линии до конца слота
              if (v_Cnt_Slot >= c_BITSLOT_DUR) then
                -- Отпускаем линии
                r_LINE_1WIRE_OUT <= (others => '1');
                r_State_Xfer     <= s_XFER_RELEASE_BUS_TX;
              end if;

            end loop;
            --------------------------------------------------------------------------------
            -- ПЕРЕДАЧА: Отпуск шины после записи
          when s_XFER_RELEASE_BUS_TX =>
            -- for i in 0 to c_LINE_NUM - 1 loop
            --   -- подготовка след. бита
            --   r_XFER_Data_Tx(i) <= '0' & r_XFER_Data_Tx(i)(7 downto 1);
            -- end loop;

            -- Проверка на конец передачи байта
            if (v_Cnt_Bit = to_unsigned(7, 7)) then
              r_State_Xfer <= s_XFER_DONE;
            else
              v_Cnt_Bit := v_Cnt_Bit + 1;
              r_State_Xfer <= s_XFER_START_SLOT;
            end if;

            --------------------------------------------------------------------------------
            -- ПРИЁМ: Считывание данных
          when s_XFER_READ_DATA =>
            v_Cnt_Slot := v_Cnt_Slot + 1;

            -- Отпускаем линии
            r_LINE_1WIRE_OUT <= (others => '1');

            -- Проверка таймера на момент считывания бита
            if (v_Cnt_Slot >= c_BITSLOT_READTIME) then
              for i in 0 to c_LINE_NUM - 1 loop
                r_XFER_Rx_Data(i) <= r_LINE_1WIRE_IN(i) & r_XFER_Rx_Data(i)(71 downto 1);

                -- Подсчёт CRC8
                r_CRC8(i)(0) <= r_CRC8(i)(1);
                r_CRC8(i)(1) <= r_CRC8(i)(2);
                r_CRC8(i)(2) <= r_CRC8(i)(3) xor r_CRC8(i)(0) xor r_LINE_1WIRE_IN(i);
                r_CRC8(i)(3) <= r_CRC8(i)(4) xor r_CRC8(i)(0) xor r_LINE_1WIRE_IN(i);
                r_CRC8(i)(4) <= r_CRC8(i)(5);
                r_CRC8(i)(5) <= r_CRC8(i)(6);
                r_CRC8(i)(6) <= r_CRC8(i)(7);
                r_CRC8(i)(7) <= r_CRC8(i)(0) xor r_LINE_1WIRE_IN(i);

                r_State_Xfer <= s_XFER_RELEASE_BUS_RX;
              end loop;
            end if;
            --------------------------------------------------------------------------------
            -- ПРИЁМ: Отпуск шины после чтения
          when s_XFER_RELEASE_BUS_RX =>

            r_LINE_1WIRE_OUT <= (others => '1'); -- отпускаем линии

            -- Проверка на конец слота
            if (v_Cnt_Slot >= c_BITSLOT_DUR - 1) then
              if (v_Cnt_Bit = to_unsigned(71, 7)) then

                -- Проверка CRC8
                for i in 0 to c_LINE_NUM - 1 loop
                  if (r_CRC8(i) = x"00") then
                    r_CRC8_Flag(i) <= '0';
                  else
                    r_CRC8_Flag(i) <= '1';
                  end if;
                end loop;

                r_State_Xfer <= s_XFER_DONE;

              else
                v_Cnt_Bit := v_Cnt_Bit + 1;
                r_State_Xfer <= s_XFER_START_SLOT;
                v_Cnt_Slot := (others => '0');
              end if;
            else
              v_Cnt_Slot := v_Cnt_Slot + 1;
            end if;
            --------------------------------------------------------------------------------
            -- Завершение слота
          when s_XFER_DONE =>

            v_XFER_Done := '1';

            if (v_XFER_Start = '0') then -- завершение Handshake
              v_XFER_Done := '0';
              r_State_Xfer <= s_XFER_IDLE;
            end if;
            --------------------------------------------------------------------------------
          when others => r_State_Xfer <= s_XFER_IDLE;
        end case;

      end if;
    end if;

  end process;

  -- --------------------------------------------------------------------------------
  -- Автомат записи данных в TAMP RAM
  -- --------------------------------------------------------------------------------
  process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      case r_State_Temp is
          --------------------------------------------------------------------------------
        when s_TEMP_IDLE =>
          if (r_TEMP_RAM_WE_Start = '1') then
            r_State_Temp <= s_TEMP_LINE1_SetData;
          end if;
          --------------------------------------------------------------------------------
        when s_TEMP_LINE1_SetData =>
          r_TEMP_RAM_Addr <= "00" & r_TEMP_RAM_Addr_Buf;
          if (r_Presence_OK(0) = '1') then
            r_TEMP_RAM_Data <= "000" & r_CRC8_Flag(0) & x"0000" & r_XFER_Rx_Data(0)(11 downto 0);
          else
            r_TEMP_RAM_Data <= x"80000000";
          end if;
          r_State_Temp <= s_TEMP_LINE1_SetWe;
          --------------------------------------------------------------------------------
        when s_TEMP_LINE1_SetWe =>
          r_TEMP_RAM_WE <= '1';
          r_State_Temp  <= s_TEMP_LINE1_ResetWe;
          --------------------------------------------------------------------------------
        when s_TEMP_LINE1_ResetWe =>
          r_TEMP_RAM_WE <= '0';
          r_State_Temp  <= s_TEMP_LINE2_SetData;
          --------------------------------------------------------------------------------
        when s_TEMP_LINE2_SetData =>
          r_TEMP_RAM_Addr <= "01" & r_TEMP_RAM_Addr_Buf;
          if (r_Presence_OK(1) = '1') then
            r_TEMP_RAM_Data <= "000" & r_CRC8_Flag(1) & x"0000" & r_XFER_Rx_Data(1)(11 downto 0);
          else
            r_TEMP_RAM_Data <= x"80000000";
          end if;
          r_State_Temp <= s_TEMP_LINE2_SetWe;
          --------------------------------------------------------------------------------
        when s_TEMP_LINE2_SetWe =>
          r_TEMP_RAM_WE <= '1';
          r_State_Temp  <= s_TEMP_LINE2_ResetWe;
          --------------------------------------------------------------------------------
        when s_TEMP_LINE2_ResetWe =>
          r_TEMP_RAM_WE <= '0';
          r_State_Temp  <= s_TEMP_LINE3_SetData;
          --------------------------------------------------------------------------------
        when s_TEMP_LINE3_SetData =>
          r_TEMP_RAM_Addr <= "10" & r_TEMP_RAM_Addr_Buf;
          if (r_Presence_OK(2) = '1') then
            r_TEMP_RAM_Data <= "000" & r_CRC8_Flag(2) & x"0000" & r_XFER_Rx_Data(2)(11 downto 0);
          else
            r_TEMP_RAM_Data <= x"80000000";
          end if;
          r_State_Temp <= s_TEMP_LINE3_SetWe;
          --------------------------------------------------------------------------------
        when s_TEMP_LINE3_SetWe =>
          r_TEMP_RAM_WE <= '1';
          r_State_Temp  <= s_TEMP_LINE3_ResetWe;
          --------------------------------------------------------------------------------
        when s_TEMP_LINE3_ResetWe =>
          r_TEMP_RAM_WE <= '0';
          r_State_Temp  <= s_TEMP_LINE4_SetData;
          --------------------------------------------------------------------------------
        when s_TEMP_LINE4_SetData =>
          r_TEMP_RAM_Addr <= "11" & r_TEMP_RAM_Addr_Buf;
          if (r_Presence_OK(3) = '1') then
            r_TEMP_RAM_Data <= "000" & r_CRC8_Flag(3) & x"0000" & r_XFER_Rx_Data(3)(11 downto 0);
          else
            r_TEMP_RAM_Data <= x"80000000";
          end if;
          r_State_Temp <= s_TEMP_LINE4_SetWe;
          --------------------------------------------------------------------------------
        when s_TEMP_LINE4_SetWe =>
          r_TEMP_RAM_WE <= '1';
          r_State_Temp  <= s_TEMP_LINE4_ResetWe;
          --------------------------------------------------------------------------------
        when s_TEMP_LINE4_ResetWe =>
          r_TEMP_RAM_WE <= '0';
          r_State_Temp  <= s_TEMP_IDLE;
          --------------------------------------------------------------------------------
        when others =>
          r_State_Temp <= s_TEMP_IDLE;
      end case;
    end if;
  end process;

  -- --------------------------------------------------------------------------------
  -- Внешние сигналы сигналы
  -- --------------------------------------------------------------------------------
  o_ID_RAM_ADDR <= std_logic_vector(r_ID_RAM_Addr);

  o_TEMP_RAM_ADDR <= std_logic_vector(r_TEMP_RAM_Addr);
  o_TEMP_RAM_DATA <= r_TEMP_RAM_Data;
  o_TEMP_RAM_WE   <= r_TEMP_RAM_WE;

  o_LINE1_1WIRE <= r_LINE_1WIRE_OUT(0);
  o_LINE2_1WIRE <= r_LINE_1WIRE_OUT(1);
  o_LINE3_1WIRE <= r_LINE_1WIRE_OUT(2);
  o_LINE4_1WIRE <= r_LINE_1WIRE_OUT(3);

  r_LINE_1WIRE_IN(0) <= i_LINE1_1WIRE;
  r_LINE_1WIRE_IN(1) <= i_LINE2_1WIRE;
  r_LINE_1WIRE_IN(2) <= i_LINE3_1WIRE;
  r_LINE_1WIRE_IN(3) <= i_LINE4_1WIRE;

  --     o_Test(0) <= r_LINE_1WIRE_OUT(0);
  --     o_Test(1) <= r_LINE_1WIRE_IN(0);
  --     o_Test(2) <= r_TEMP_RAM_WE;
  --     o_Test(3) <= i_MHz_1;
  --     o_Test(4) <= i_kHz_1;
  --     o_Test(5) <= '1' when r_State_1WIRE = s_IDLE else '0';
  -- --     o_Test(6) <= r_CRC0(6);
  -- --     o_Test(7) <= '1' when (r_Cnt_Bit_Rx = 72) else '0';

  o_Test(0) <= r_CRC8(0)(0);
  o_Test(1) <= r_CRC8(0)(1);
  o_Test(2) <= r_CRC8(0)(2);
  o_Test(3) <= r_CRC8(0)(3);
  o_Test(4) <= r_CRC8(0)(4);
  o_Test(5) <= r_CRC8(0)(5);
  o_Test(6) <= r_CRC8(0)(6);
  o_Test(7) <= r_CRC8(0)(7);
  o_Test(8) <= '1' when (r_CRC8(0) = x"00") else '0';

  -- o_Test(0) <= r_Cnt(1);
  -- o_Test(1) <= r_Cnt(2);
  -- o_Test(2) <= r_Cnt(3);
  -- o_Test(3) <= r_Cnt(4);
  -- o_Test(4) <= r_Cnt(5);
  -- o_Test(5) <= r_Cnt(6);
  -- o_Test(6) <= r_Cnt(7);
  -- o_Test(7) <= r_Cnt(8);
  -- o_Test(8) <= r_Cnt(9);

  -- process (i_Clk)
  -- begin
  --   if rising_edge(i_Clk) then
  --     r_Cnt <= r_Cnt + 1;
  --   end if;
  -- end process;
end RTL;