library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pack.all;

entity ONE_WIRE_BLOCK_v5_1 is

  port (
    i_Clk   : in std_logic;
    i_MHz_1 : in std_logic;
    i_kHz_1 : in std_logic;
    ---
    i_ID_DATA : in std_logic_vector(31 downto 0) := (others => '0');
    o_ID_ADDR : out std_logic_vector(6 downto 0) := (others => '0');
    ---
    o_TEMP_ADDR       : out std_logic_vector(3 downto 0)  := (others => '0');
    o_TEMP_WR         : out std_logic                     := '0';
    o_LINE1_TEMP_DATA : out std_logic_vector(15 downto 0) := (others => '0');
    o_LINE2_TEMP_DATA : out std_logic_vector(15 downto 0) := (others => '0');
    o_LINE3_TEMP_DATA : out std_logic_vector(15 downto 0) := (others => '0');
    o_LINE4_TEMP_DATA : out std_logic_vector(15 downto 0) := (others => '0');
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
    o_Test : out std_logic_vector(7 downto 0) := (others => '0')
  );
end entity;

architecture arch of ONE_WIRE_BLOCK_v5_1 is

  --CONSTANTS
  constant c_CntMhz_Div : integer := 25;--clock divider coefficient
  constant c_SensorNum  : integer := 16; --sensor's amount

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
    s_MATCH_ROM,       -- Отправка 0x55
    s_SEND_ROM_BYTE,   -- Цикл отправки 8 байт ID
    s_READ_SCRATCHPAD, -- Отправка 0xBE
    s_READ_DATA        -- Чтение 9 байт
  );
  signal r_State_1WIRE : state_main := s_RESET;

  -- Направление цикла основного автомата
  signal r_CMD_type : std_logic := '0'; -- convert = 0, read = 1

  -- Автомат передачи данных
  type state_xfer is (
    s_XFER_IDLE,      -- Ожидание старта
    s_START_SLOT,     -- Начало слота
    s_DRIVE_LOW,      -- Сброс линии в 0
    s_READ_DATA,      -- Считывание данных
    s_RELEASE_BUS_TX, -- Отпуск шины после записи
    s_RELEASE_BUS_RX, -- Отпуск шины после чтения
    s_XFER_DONE       -- Завершение слота
  );
  signal r_State_Xfer : state_xfer := s_XFER_IDLE;

  -- 1WIRE входы
  signal r_LINE_1WIRE_IN : std_logic_vector(c_LINE_NUM - 1 downto 0) := (others => '1');

  -- 1WIRE выходы
  signal r_LINE_1WIRE_OUT : std_logic_vector(c_LINE_NUM - 1 downto 0) := (others => 'Z');

  -- Handshake для выдачи/приёма байт (XFER - transfer)
  type word_array is array (c_LINE_NUM - 1 downto 0) of std_logic_vector(7 downto 0);
  type temp_array is array (c_LINE_NUM - 1 downto 0) of std_logic_vector(71 downto 0);

  signal r_XFER_Data_Tx : word_array := (others => (others => '0'));
  signal r_XFER_Data_Rx : temp_array := (others => (others => '0'));
  signal r_XFER_Start   : std_logic  := '0';
  signal r_XFER_Done    : std_logic  := '0';
  signal r_XFER_RW      : std_logic  := '0'; -- write = 0, read = 1
  --Проверка PRESENCE
  signal r_Presence_Buf : std_logic_vector(c_LINE_NUM - 1 downto 0) := (others => '0');
  signal r_Presence_OK  : std_logic_vector(c_LINE_NUM - 1 downto 0) := (others => '0');

  --   --1WIRE OUTPUTs FROM TX
  --   signal r_1WIRE_BitLow         : std_logic := '1';
  --   signal r_1WIRE_BitHigh        : std_logic := '1';
  --   signal r_LINE1_1WIRE_WriteBit : std_logic := '1';
  --   signal r_LINE2_1WIRE_WriteBit : std_logic := '1';
  --   signal r_LINE3_1WIRE_WriteBit : std_logic := '1';
  --   signal r_LINE4_1WIRE_WriteBit : std_logic := '1';

  --   --SENS's COUNTER
  --   signal r_CntSensor : std_logic_vector(3 downto 0) := (others => '0');

  --   --BIT/BYTE COUNTERS		
  --   signal r_Cnt_Bit_Tx   : integer range 0 to 8         := 0;               --tx bit count
  --   signal r_Cnt_Bit_Rx   : integer range 0 to 73        := 0;               --rx bit count
  --   signal r_Cnt_Byte_Rom : std_logic_vector(6 downto 0) := (others => '0'); --tx byte rom code count

  --   --SENS DATA
  --   signal r_LINE1_SensID    : std_logic_vector(7 downto 0)  := (others => '0');
  --   signal r_LINE2_SensID    : std_logic_vector(7 downto 0)  := (others => '0');
  --   signal r_LINE3_SensID    : std_logic_vector(7 downto 0)  := (others => '0');
  --   signal r_LINE4_SensID    : std_logic_vector(7 downto 0)  := (others => '0');
  --   signal r_LINE1_SensData  : std_logic_vector(71 downto 0) := (others => '0'); --9 Byte from DS18B20 
  --   signal r_LINE2_SensData  : std_logic_vector(71 downto 0) := (others => '0'); --9 Byte from DS18B20 
  --   signal r_LINE3_SensData  : std_logic_vector(71 downto 0) := (others => '0'); --9 Byte from DS18B20 
  --   signal r_LINE4_SensData  : std_logic_vector(71 downto 0) := (others => '0'); --9 Byte from DS18B20 
  --   signal r_LINE1_SendBufer : std_logic_vector(7 downto 0)  := (others => '0'); --tx buffer
  --   signal r_LINE2_SendBufer : std_logic_vector(7 downto 0)  := (others => '0'); --tx buffer
  --   signal r_LINE3_SendBufer : std_logic_vector(7 downto 0)  := (others => '0'); --tx buffer
  --   signal r_LINE4_SendBufer : std_logic_vector(7 downto 0)  := (others => '0'); --tx buffer

  --   --SMALL STATE MACHINE FOR TX
  --   signal r_Write_BitLow  : integer range 0 to 1 := 0; --tx bit '0'
  --   signal r_Write_BitHigh : integer range 0 to 1 := 0; --tx bit '1'

  --   signal r_BitRecieve : integer range 0 to 3 := 0; --rx bit
  --   signal r_State      : integer range 0 to 7 := 3; --(SKIP ROM COMMAND, CONVERT TEMPERATURE COMAND, WAIT 800ms, MATCH ROM COMMAND, SET ROM COMMAND, READ SCRATCHPAD, GET SENS DATA)

  --   --CRC CALCULATION
  --   signal r_CRC0 : std_logic_vector(7 downto 0) := (others => '0');
  --   signal r_CRC1 : std_logic_vector(7 downto 0) := (others => '0');
  --   signal r_CRC2 : std_logic_vector(7 downto 0) := (others => '0');
  --   signal r_CRC3 : std_logic_vector(7 downto 0) := (others => '0');

  --   signal r_CRC0_Flag : std_logic := '0';
  --   signal r_CRC1_Flag : std_logic := '0';
  --   signal r_CRC2_Flag : std_logic := '0';
  --   signal r_CRC3_Flag : std_logic := '0';

begin
  --     --TIMER 1MHz
  --     PROCESS (i_Clk)
  --     BEGIN

  --         IF falling_edge(i_Clk) THEN
  --             IF (r_Reset_1MHz_BitLow = '1') THEN
  --                 r_Cnt_Time1MHz_BitLow <= 0;
  --             ELSE
  --                 IF (i_1MHz = '1') THEN
  --                     r_Cnt_Time1MHz_BitLow <= r_Cnt_Time1MHz_BitLow + 1;
  --                 END IF;
  --             END IF;
  --         END IF;

  --         IF falling_edge(i_Clk) THEN
  --             IF (r_Reset_1MHz_BitHigh = '1') THEN
  --                 r_Cnt_Time1MHz_BitHigh <= 0;
  --             ELSE
  --                 IF (i_1MHz = '1') THEN
  --                     r_Cnt_Time1MHz_BitHigh <= r_Cnt_Time1MHz_BitHigh + 1;
  --                 END IF;
  --             END IF;
  --         END IF;

  --     END PROCESS;

  --     --TIMER 1kHz
  --     PROCESS (i_Clk)
  --     BEGIN

  --         IF falling_edge(i_Clk) THEN
  --             IF (r_Reset_125Hz = '1') THEN
  --                 r_Cnt_Time125Hz <= 0;
  --             ELSE
  --                 IF (i_1kHz = '1') THEN
  --                     r_Cnt_Time125Hz <= r_Cnt_Time125Hz + 1;
  --                 END IF;
  --             END IF;
  --         END IF;

  --     END PROCESS;

  process (i_Clk)
    -- Основной автомат
    variable v_Cnt_MHz_1   : unsigned(15 downto 0) := (others => '0');
    variable v_Cnt_kHz_1   : unsigned(15 downto 0) := (others => '0');
    variable v_Cnt_ID_byte : unsigned(2 downto 0)  := (others => '0');
    -- Автомат обмена байтами
    variable v_Cnt_Slot : unsigned(5 downto 0) := c_BITSLOT_DUR;
    variable v_Cnt_Bit  : unsigned(6 downto 0) := (others => '0');
  begin

    if rising_edge(i_Clk) then
      if (i_MHz_1 = '1') then

        -- --------------------------------------------------------------------------------
        -- Основной автомат
        -- --------------------------------------------------------------------------------
        case (r_State_1WIRE) is
            --------------------------------------------------------------------------------
          when s_IDLE =>
            if (i_kHz_1 = '1') then
              r_State_1WIRE <= s_RESET;
            end if;
            --------------------------------------------------------------------------------
          when s_RESET                =>
            r_LINE_1WIRE_OUT <= (others => '0');
            if (i_kHz_1 = '1') then
              r_State_1WIRE    <= s_PRESENCE;
              r_LINE_1WIRE_OUT <= (others => '1');
            end if;
            --------------------------------------------------------------------------------
          when s_PRESENCE =>
            if (v_Cnt_MHz_1 >= c_PRESENCE_WAIT_ZERO) then
              r_Presence_Buf <= r_LINE_1WIRE_IN;
              r_State_1WIRE  <= s_PRESENCE_CHECK;
              v_Cnt_MHz_1 := (others => '0');
            else
              v_Cnt_MHz_1 := v_Cnt_MHz_1 + 1;
            end if;
            --------------------------------------------------------------------------------
          when s_PRESENCE_CHECK =>
            if (v_Cnt_MHz_1 >= c_PRESENCE_WAIT_ONE) then

              -- Проверка смены состояния (с 0 на 1)
              for i in 0 to c_LINE_NUM - 1 loop
                if (r_Presence_Buf(i) = '0' and r_LINE_1WIRE_IN(i) = '1') then
                  r_Presence_OK(i) <= '1';
                else
                  r_Presence_OK(i) <= '0';
                end if;
              end loop;

              -- Проверка направления цикла
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
            r_XFER_Start   <= '1';
            r_XFER_Data_Tx <= (others => c_CMD_SKIP_ROM);
            r_XFER_RW      <= '0'; -- write = 0, read = 1
            if (r_XFER_Done = '1') then
              r_XFER_Start  <= '0';
              r_State_1WIRE <= s_CONVERT;
            end if;
            --------------------------------------------------------------------------------
          when s_CONVERT =>
            r_XFER_Start   <= '1';
            r_XFER_Data_Tx <= (others => c_CMD_CONVERT);
            r_XFER_RW      <= '0'; -- write = 0, read = 1
            if (r_XFER_Done = '1') then
              r_XFER_Start  <= '0';
              r_State_1WIRE <= s_CONVERT_WAIT;
            end if;
            --------------------------------------------------------------------------------
          when s_CONVERT_WAIT =>
            if (i_kHz_1 = '1') then
              if (v_Cnt_kHz_1 >= c_CONVERT_TIME) then
                r_State_1WIRE <= s_IDLE;
                v_Cnt_kHz_1 := (others => '0');
                r_CMD_type <= '1';
              else
                v_Cnt_kHz_1 := v_Cnt_kHz_1 + 1;
              end if;
            end if;
            --------------------------------------------------------------------------------
          when s_MATCH_ROM =>
            r_XFER_Start   <= '1';
            r_XFER_Data_Tx <= (others => c_CMD_MATCH_ROM);
            r_XFER_RW      <= '0'; -- write = 0, read = 1
            if (r_XFER_Done = '1') then
              r_XFER_Start  <= '0';
              r_State_1WIRE <= s_SEND_ROM_BYTE;
            end if;
            --------------------------------------------------------------------------------
          when s_SEND_ROM_BYTE =>
            if (v_Cnt_ID_byte /= "111") then
              r_XFER_Start <= '1';
              for i in 0 to c_LINE_NUM - 1 loop
                r_XFER_Data_Tx(i) <= r_LINE_ID(i)(v_Cnt_ID_byte);
              end loop;
              r_XFER_RW <= '0'; -- write = 0, read = 1
              if (r_XFER_Done = '1') then
                r_XFER_Start <= '0';
                v_Cnt_ID_byte := v_Cnt_ID_byte + 1;
              end if;
            else
              r_State_1WIRE <= s_READ_SCRATCHPAD;
            end if;
            --------------------------------------------------------------------------------
          when s_READ_SCRATCHPAD =>
            r_XFER_Start   <= '1';
            r_XFER_Data_Tx <= (others => c_CMD_READ_SCRATCHPAD);
            r_XFER_RW      <= '0'; -- write = 0, read = 1
            if (r_XFER_Done = '1') then
              r_XFER_Start  <= '0';
              r_State_1WIRE <= s_SEND_ROM_BYTE;
            end if;
            --------------------------------------------------------------------------------
          when s_READ_DATA =>
            r_XFER_Start <= '1';
            r_XFER_RW    <= '1'; -- write = 0, read = 1
            if (r_XFER_Done = '1') then
              r_XFER_Start  <= '0';
              r_State_1WIRE <= s_IDLE;
            end if;
            --------------------------------------------------------------------------------
          when others => r_State_1WIRE <= s_IDLE;
        end case;

        -- --------------------------------------------------------------------------------
        -- Автомат обмена байтами
        -- --------------------------------------------------------------------------------
        case (r_State_Xfer) is
            --------------------------------------------------------------------------------
          when s_XFER_IDLE =>
            if (r_XFER_Start = '1') then
              r_State_Xfer     <= s_START_SLOT;
              v_Cnt_Slot       <= (others => '0');
              v_Cnt_Bit        <= (others => '0');
              r_LINE_1WIRE_OUT <= (others => '0'); -- Удержание линии в 0
            end if;
            --------------------------------------------------------------------------------
          when s_START_SLOT =>
            v_Cnt_Slot := v_Cnt_Slot + 1;
            if (v_Cnt_Slot = to_unsigned(2, 6)) then
              if (r_XFER_RW = '0') then -- read = 1, write = 0
                r_State_Xfer <= s_DRIVE_LOW;
              else
                r_State_Xfer <= s_READ_DATA;
              end if;
            end if;
            --------------------------------------------------------------------------------
          when s_DRIVE_LOW =>
            v_Cnt_Slot := v_Cnt_Slot + 1;
            for i in 0 to c_LINE_NUM - 1 loop
              if (r_XFER_Data(i)(0) = '1') then
                r_LINE_1WIRE_OUT(i) <= '1'; -- отпускаем линию
              else
                r_LINE_1WIRE_OUT(i) <= '0'; -- удерживаем линию
              end if;
              if (v_Cnt_Slot >= c_BITSLOT_MAX_LOW) then -- 15 мкс от начала слота
                r_State_Xfer <= s_RELEASE_BUS_TX;
              end if;
            end loop;
            --------------------------------------------------------------------------------
          when s_RELEASE_BUS_TX =>

            r_LINE_1WIRE_OUT <= (others => '1'); -- отпускаем линию

            if (v_Cnt_Slot >= c_BITSLOT_DUR) then -- конец слота
              for i in 0 to c_LINE_NUM - 1 loop
                r_XFER_Data_Tx(i) <= '0' & r_XFER_Data_Tx(i)(7 downto 1);
              end loop;
              if (v_Cnt_Bit = to_unsigned(7, 7)) then
                r_State_Xfer <= s_XFER_TX_DONE;
              else
                v_Cnt_Bit := v_Cnt_Bit + 1;
                r_State_Xfer <= s_START_SLOT;
                v_Cnt_Slot := (others => '0');
              end if;
            else
              v_Cnt_Slot := v_Cnt_Slot + 1;
            end if;
            --------------------------------------------------------------------------------
          when s_READ_DATA =>
            v_Cnt_Slot := v_Cnt_Slot + 1;
            r_LINE_1WIRE_OUT <= (others => '1'); -- Отпускаем линии
            if (v_Cnt_Slot >= c_BITSLOT_READTIME) then
              for i in 0 to c_LINE_NUM - 1 loop
                r_XFER_Data_Rx(i) <= r_LINE_1WIRE_IN(i) & r_XFER_Data_Rx(i)(71 downto 1);

                -- CRC
                r_CRC(i)(0) <= r_CRC(i)(1);
                r_CRC(i)(1) <= r_CRC(i)(2);
                r_CRC(i)(2) <= r_CRC(i)(0) xor r_CRC(i)(3) xor i_LINE4_1WIRE;
                r_CRC(i)(3) <= r_CRC(i)(0) xor r_CRC(i)(4) xor i_LINE4_1WIRE;
                r_CRC(i)(4) <= r_CRC(i)(5);
                r_CRC(i)(5) <= r_CRC(i)(6);
                r_CRC(i)(6) <= r_CRC(i)(7);
                r_CRC(i)(7) <= r_CRC(i)(0) xor r_LINE_1WIRE_IN(i);

                r_State_Xfer <= s_RELEASE_BUS_RX;
              end loop;
            end if;
            --------------------------------------------------------------------------------
          when s_RELEASE_BUS_RX =>

            r_LINE_1WIRE_OUT <= (others => '1'); -- отпускаем линию

            if (v_Cnt_Slot >= c_BITSLOT_DUR) then -- конец слота
              if (v_Cnt_Bit = to_unsigned(71, 7)) then
                for i in 0 to c_LINE_NUM - 1 loop
                  if (r_CRC(i) = x"0") then
                    r_CRC_Flag(i) <= '0';
                  else
                    r_CRC_Flag(i) <= '1';
                  end if;
                end loop;
                r_State_Xfer <= s_XFER_RX_DONE;
              else
                v_Cnt_Bit := v_Cnt_Bit + 1;
                r_State_Xfer <= s_START_SLOT;
                v_Cnt_Slot := (others => '0');
              end if;
            else
              v_Cnt_Slot := v_Cnt_Slot + 1;
            end if;
            --------------------------------------------------------------------------------
          when s_XFER_TX_DONE | s_XFER_RX_DONE =>

            r_XFER_Done <= '1';
            r_CRC       <= (others => (others => '0')); -- сброс буфера CRC 

            if (r_XFER_Start = '0') then -- завершение Handshake
              r_State_Xfer <= s_XFER_IDLE;
            end if;
            --------------------------------------------------------------------------------
          when others => r_State_Xfer <= s_XFER_IDLE;
        end case;

      end if;
    end if;

  end process;
  ------------------------------------------------------------
  --RESET
  if (r_State_1WIRE = RESET) then
    r_Reset_1MHz_BitLow <= '0';         --START MAIN TIMER										
    if (r_Cnt_Time1MHz_BitLow = 1) then --START STATE "RESET/LINE PULL-DOWN"							
      r_1WIRE_Main <= '0';
    elsif (r_Cnt_Time1MHz_BitLow = 485) then --END STATE "RESET/LINE PULL-DOWN"
      r_1WIRE_Main <= '1';
    elsif (r_Cnt_Time1MHz_BitLow = 550) then --START PRESENCE CHECK
      r_Presence_LINE1 <= i_LINE1_1WIRE;
      r_Presence_LINE2 <= i_LINE2_1WIRE;
      r_Presence_LINE3 <= i_LINE3_1WIRE;
      r_Presence_LINE4 <= i_LINE4_1WIRE;
    elsif (r_Cnt_Time1MHz_BitLow = 851) then --END PRESENCE CHECK
      r_State_1WIRE <= PRESENCE;
    end if;
  end if;
  ------------------------------------------------------------
  --PRESENCE
  if (r_State_1WIRE = PRESENCE) then
    if (r_Presence_LINE1 = '0' and i_LINE1_1WIRE = '1') then
      r_Presence_LINE1_OK <= '1';
    else
      r_Presence_LINE1_OK <= '0';
    end if;
    if (r_Presence_LINE2 = '0' and i_LINE2_1WIRE = '1') then
      r_Presence_LINE2_OK <= '1';
    else
      r_Presence_LINE2_OK <= '0';
    end if;
    if (r_Presence_LINE3 = '0' and i_LINE3_1WIRE = '1') then
      r_Presence_LINE3_OK <= '1';
    else
      r_Presence_LINE3_OK <= '0';
    end if;
    if (r_Presence_LINE4 = '0' and i_LINE4_1WIRE = '1') then
      r_Presence_LINE4_OK <= '1';
    else
      r_Presence_LINE4_OK <= '0';
    end if;
    r_Reset_1MHz_BitLow <= '1'; --END MAIN TIMER
    r_State_1WIRE       <= SEND;
  end if;
  ------------------------------------------------------------
  --SEND COMMAND
  if (r_State_1WIRE = SEND) then
    case (r_State) is
        ------------------------------------------------------------
        --SKIP ROM COMMAND
      when 0 =>
        r_State           <= 1;
        r_LINE1_SendBufer <= x"CC";
        r_LINE2_SendBufer <= x"CC";
        r_LINE3_SendBufer <= x"CC";
        r_LINE4_SendBufer <= x"CC";
        r_State_1WIRE     <= WRITE_BIT;
        ------------------------------------------------------------
        --CONVERT TEMPERATURE COMAND
      when 1 =>
        r_State           <= 2;
        r_LINE1_SendBufer <= x"44";
        r_LINE2_SendBufer <= x"44";
        r_LINE3_SendBufer <= x"44";
        r_LINE4_SendBufer <= x"44";
        r_State_1WIRE     <= WRITE_BIT;
        ------------------------------------------------------------
        --WAIT 800ms
      when 2 =>
        r_State       <= 3;
        r_State_1WIRE <= WAIT_800ms;
        ------------------------------------------------------------	
        --MATCH ROM COMMAND
      when 3 =>
        r_State           <= 4;
        r_LINE1_SendBufer <= x"55";
        r_LINE2_SendBufer <= x"55";
        r_LINE3_SendBufer <= x"55";
        r_LINE4_SendBufer <= x"55";
        r_State_1WIRE     <= WRITE_BIT;
        ------------------------------------------------------------
        --SET ROM COMMAND
      when 4 =>
        r_LINE1_SendBufer <= r_LINE1_SensID;
        r_LINE2_SendBufer <= r_LINE2_SensID;
        r_LINE3_SendBufer <= r_LINE3_SensID;
        r_LINE4_SendBufer <= r_LINE4_SensID;

        if (r_Cnt_Byte_Rom(2 downto 0) = "111") then
          r_State <= 5;
        end if;

        r_Cnt_Byte_Rom <= r_Cnt_Byte_Rom + 1;
        r_State_1WIRE  <= WRITE_BIT;
        ------------------------------------------------------------
        --READ SCRATCHPAD	
      when 5 =>
        r_State           <= 6;
        r_LINE1_SendBufer <= x"BE";
        r_LINE2_SendBufer <= x"BE";
        r_LINE3_SendBufer <= x"BE";
        r_LINE4_SendBufer <= x"BE";
        r_State_1WIRE     <= WRITE_BIT;
        ------------------------------------------------------------
        --GET SENS DATA									
      when 6 =>
        r_State_1WIRE <= GET_DATA;
        ------------------------------------------------------------
      when others =>
        r_State_1WIRE <= RESET;
    end case;
  end if;

  ------------------------------------------------------------
  --WAIT 800 ms
  if (r_State_1WIRE = WAIT_800ms) then
    r_Reset_125Hz <= '0';
    if (r_Cnt_Time125Hz = 94) then --min conv time for 12-bit resolution 750 ms	
      -- IF (r_Cnt_Time125Hz = 1) THEN
      r_Reset_125Hz <= '1';
      r_State_1WIRE <= RESET;
    end if;
  end if;
  ------------------------------------------------------------
  --SEND BYTE
  -- IF (r_State_1WIRE = WRITE_BYTE) THEN
  --     IF (r_Cnt_Bit_Tx = 7) THEN
  --         r_Cnt_Bit_Tx <= 0;
  --         r_State_1WIRE <= SEND;
  --     ELSE
  --         r_State_1WIRE <= WRITE_BIT;
  --     END IF;
  -- END IF;

  --8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
  --8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
  ------------------------------------------------------------
  --SEND BIT
  if (r_State_1WIRE = WRITE_BIT) then

    case (r_Write_BitLow) is
        ------------------------------------------------------------										
      when 0 =>
        --start pull-down
        r_1WIRE_BitLow      <= '0';
        r_Reset_1MHz_BitLow <= '0';
        if (r_Cnt_Time1MHz_BitLow = 59) then
          r_Reset_1MHz_BitLow <= '1';
          r_Write_BitLow      <= 1;
        end if;
        ------------------------------------------------------------										
      when others =>
        r_1WIRE_BitLow      <= '1';
        r_Reset_1MHz_BitLow <= '0';
        if (r_Cnt_Time1MHz_BitLow = 3) then
          r_Reset_1MHz_BitLow <= '1';
          r_Write_BitLow      <= 0;

          --all rows down only here because this 2 cases (r_Write_BitLow and r_Write_BitHigh) run in parallel
          if (r_Cnt_Bit_Tx = 7) then
            r_Cnt_Bit_Tx  <= 0;
            r_State_1WIRE <= SEND;
          else
            r_Cnt_Bit_Tx <= r_Cnt_Bit_Tx + 1;
          end if;
        end if;
        ------------------------------------------------------------														
    end case;

    case (r_Write_BitHigh) is
        ------------------------------------------------------------										
      when 0 =>
        --start pull-down
        r_1WIRE_BitHigh      <= '0';
        r_Reset_1MHz_BitHigh <= '0';
        if (r_Cnt_Time1MHz_BitHigh = 9) then
          r_Reset_1MHz_BitHigh <= '1';
          r_Write_BitHigh      <= 1;
        end if;
        ------------------------------------------------------------										
      when others =>
        r_1WIRE_BitHigh      <= '1';
        r_Reset_1MHz_BitHigh <= '0';
        if (r_Cnt_Time1MHz_BitHigh = 53) then
          r_Reset_1MHz_BitHigh <= '1';
          r_Write_BitHigh      <= 0;
        end if;
        ------------------------------------------------------------														
    end case;

  end if;
  --8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
  --8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
  --8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

  ------------------------------------------------------------
  --RECIEVE TEMPR DATA			
  if (r_State_1WIRE = GET_DATA) then
    case (r_Cnt_Bit_Rx) is
        ------------------------------------------------------------
      when 0 to 71 => --read 72 bit 			
        r_1WIRE_Main  <= '0';
        r_State_1WIRE <= READ_BIT;
        ------------------------------------------------------------									
      when 72 => --STORE DATA TO BRAM
        o_TEMP_ADDR <= r_CntSensor;
        --                            o_LINE1_TEMP_DATA <= r_CRC0_Flag & "000" & x"000" & r_LINE1_SensData(15 DOWNTO 0);
        --                            o_LINE2_TEMP_DATA <= r_CRC1_Flag & "000" & x"000" & r_LINE2_SensData(15 DOWNTO 0);
        --                            o_LINE3_TEMP_DATA <= r_CRC2_Flag & "000" & x"000" & r_LINE3_SensData(15 DOWNTO 0);
        --                            o_LINE4_TEMP_DATA <= r_CRC3_Flag & "000" & x"000" & r_LINE4_SensData(15 DOWNTO 0);
        --                            o_LINE1_TEMP_DATA <= r_CRC0_Flag & "0000000" & r_CRC0 & r_LINE1_SensData(15 DOWNTO 0);
        --                            o_LINE2_TEMP_DATA <= r_CRC1_Flag & "0000000" & r_CRC1 & r_LINE2_SensData(15 DOWNTO 0);
        --                            o_LINE3_TEMP_DATA <= r_CRC2_Flag & "0000000" & r_CRC2 & r_LINE3_SensData(15 DOWNTO 0);
        --                            o_LINE4_TEMP_DATA <= r_CRC3_Flag & "0000000" & r_CRC3 & r_LINE4_SensData(15 DOWNTO 0);

        if (r_Presence_LINE1_OK = '1') then
          o_LINE1_TEMP_DATA <= r_CRC0_Flag & "0000000" & x"00" & r_LINE1_SensData(15 downto 0);
        else
          o_LINE1_TEMP_DATA <= x"80000000"; --INCORRECT RECEIVE
        end if;

        if (r_Presence_LINE2_OK = '1') then
          o_LINE2_TEMP_DATA <= r_CRC1_Flag & "0000000" & x"00" & r_LINE2_SensData(15 downto 0);
        else
          o_LINE2_TEMP_DATA <= x"80000000"; --INCORRECT RECEIVE
        end if;

        if (r_Presence_LINE3_OK = '1') then
          o_LINE3_TEMP_DATA <= r_CRC2_Flag & "0000000" & x"00" & r_LINE3_SensData(15 downto 0);
        else
          o_LINE3_TEMP_DATA <= x"80000000"; --INCORRECT RECEIVE
        end if;

        if (r_Presence_LINE4_OK = '1') then
          o_LINE4_TEMP_DATA <= r_CRC3_Flag & "0000000" & x"00" & r_LINE4_SensData(15 downto 0);
        else
          o_LINE4_TEMP_DATA <= x"80000000"; --INCORRECT RECEIVE
        end if;

        o_TEMP_WR    <= '1';
        r_Cnt_Bit_Rx <= 73;
        ------------------------------------------------------------									
      when others => --all data rx			
        o_TEMP_WR    <= '0';
        r_Cnt_Bit_Rx <= 0;

        r_CRC0 <= (others => '0');
        r_CRC1 <= (others => '0');
        r_CRC2 <= (others => '0');
        r_CRC3 <= (others => '0');

        if ((conv_integer(r_CntSensor)) = c_SensorNum - 1) then --ALL SENS HAVE BEEN CHECKED 
          r_State     <= 0;                                       --RESET SEND-STATE-MACHINE
          r_CntSensor <= (others => '0');                         --RESET SENS NAME's COUNTER
        else
          r_CntSensor <= r_CntSensor + 1; --SET NEXT SENS NAME
          r_State     <= 3;               --REPEAT THE TEMPREATURE READING CYCLE (MATCH >> READ >> GET DATA)			
        end if;

        r_State_1Wire <= RESET;
    end case;
  end if;

  ------------------------------------------------------------
  --RECIEVE TEMPR BIT			
  if (r_State_1WIRE = READ_BIT) then
    case (r_BitRecieve) is
        ------------------------------------------------------------
      when 0 =>
        r_1WIRE_Main        <= '1';
        r_Reset_1MHz_BitLow <= '0';
        if (r_Cnt_Time1MHz_BitLow = 13) then --14 us
          r_LINE1_SensData(r_Cnt_Bit_Rx) <= i_LINE1_1WIRE;
          r_LINE2_SensData(r_Cnt_Bit_Rx) <= i_LINE2_1WIRE;
          r_LINE3_SensData(r_Cnt_Bit_Rx) <= i_LINE3_1WIRE;
          r_LINE4_SensData(r_Cnt_Bit_Rx) <= i_LINE4_1WIRE;
          r_Cnt_Bit_Rx                   <= r_Cnt_Bit_Rx + 1;

          --CRCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          --CRCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          --CRCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          --LINE1
          r_CRC0(0) <= r_CRC0(1);
          r_CRC0(1) <= r_CRC0(2);
          r_CRC0(2) <= r_CRC0(0) xor r_CRC0(3) xor i_LINE1_1WIRE;
          r_CRC0(3) <= r_CRC0(0) xor r_CRC0(4) xor i_LINE1_1WIRE;
          r_CRC0(4) <= r_CRC0(5);
          r_CRC0(5) <= r_CRC0(6);
          r_CRC0(6) <= r_CRC0(7);
          r_CRC0(7) <= r_CRC0(0) xor i_LINE1_1WIRE;

          --LINE2
          r_CRC1(0) <= r_CRC1(1);
          r_CRC1(1) <= r_CRC1(2);
          r_CRC1(2) <= r_CRC1(0) xor r_CRC1(3) xor i_LINE2_1WIRE;
          r_CRC1(3) <= r_CRC1(0) xor r_CRC1(4) xor i_LINE2_1WIRE;
          r_CRC1(4) <= r_CRC1(5);
          r_CRC1(5) <= r_CRC1(6);
          r_CRC1(6) <= r_CRC1(7);
          r_CRC1(7) <= r_CRC1(0) xor i_LINE2_1WIRE;

          --LINE3
          r_CRC2(0) <= r_CRC2(1);
          r_CRC2(1) <= r_CRC2(2);
          r_CRC2(2) <= r_CRC2(0) xor r_CRC2(3) xor i_LINE3_1WIRE;
          r_CRC2(3) <= r_CRC2(0) xor r_CRC2(4) xor i_LINE3_1WIRE;
          r_CRC2(4) <= r_CRC2(5);
          r_CRC2(5) <= r_CRC2(6);
          r_CRC2(6) <= r_CRC2(7);
          r_CRC2(7) <= r_CRC2(0) xor i_LINE3_1WIRE;

          --LINE4
          r_CRC3(0) <= r_CRC3(1);
          r_CRC3(1) <= r_CRC3(2);
          r_CRC3(2) <= r_CRC3(0) xor r_CRC3(3) xor i_LINE4_1WIRE;
          r_CRC3(3) <= r_CRC3(0) xor r_CRC3(4) xor i_LINE4_1WIRE;
          r_CRC3(4) <= r_CRC3(5);
          r_CRC3(5) <= r_CRC3(6);
          r_CRC3(6) <= r_CRC3(7);
          r_CRC3(7) <= r_CRC3(0) xor i_LINE4_1WIRE;
          --CRCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          --CRCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
          --CRCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC			

          r_BitRecieve <= 1;
        end if;
        ------------------------------------------------------------
      when others =>
        r_Reset_1MHz_BitLow <= '0';
        if (r_Cnt_Time1MHz_BitLow = 75) then --62 us

          if (r_CRC0 = x"0") then
            r_CRC0_Flag <= '0';
          else
            r_CRC0_Flag <= '1';
          end if;

          if (r_CRC1 = x"0") then
            r_CRC1_Flag <= '0';
          else
            r_CRC1_Flag <= '1';
          end if;

          if (r_CRC2 = x"0") then
            r_CRC2_Flag <= '0';
          else
            r_CRC2_Flag <= '1';
          end if;

          if (r_CRC3 = x"0") then
            r_CRC3_Flag <= '0';
          else
            r_CRC3_Flag <= '1';
          end if;

          r_Reset_1MHz_BitLow <= '1';
          r_BitRecieve        <= 0;
          r_State_1WIRE       <= GET_DATA;
        end if;
    end case;
  end if;

end if; --(i_Mhz = '1')
end if; --rising_edge(i_Clk)
end process;

--     r_LINE1_SensID <= i_LINE1_ID_DATA;
--     r_LINE2_SensID <= i_LINE2_ID_DATA;
--     r_LINE3_SensID <= i_LINE3_ID_DATA;
--     r_LINE4_SensID <= i_LINE4_ID_DATA;
--     o_ID_ADDR <= r_Cnt_Byte_Rom;

--     r_LINE1_1WIRE_WriteBit <=
--         r_1WIRE_BitLow WHEN r_LINE1_SendBufer(r_Cnt_Bit_Tx) = '0' ELSE
--         r_1WIRE_BitHigh;

--     r_LINE2_1WIRE_WriteBit <=
--         r_1WIRE_BitLow WHEN r_LINE2_SendBufer(r_Cnt_Bit_Tx) = '0' ELSE
--         r_1WIRE_BitHigh;

--     r_LINE3_1WIRE_WriteBit <=
--         r_1WIRE_BitLow WHEN r_LINE3_SendBufer(r_Cnt_Bit_Tx) = '0' ELSE
--         r_1WIRE_BitHigh;

--     r_LINE4_1WIRE_WriteBit <=
--         r_1WIRE_BitLow WHEN r_LINE4_SendBufer(r_Cnt_Bit_Tx) = '0' ELSE
--         r_1WIRE_BitHigh;

--     o_LINE1_1WIRE <= r_1WIRE_Main AND r_LINE1_1WIRE_WriteBit;
--     o_LINE2_1WIRE <= r_1WIRE_Main AND r_LINE2_1WIRE_WriteBit;
--     o_LINE3_1WIRE <= r_1WIRE_Main AND r_LINE3_1WIRE_WriteBit;
--     o_LINE4_1WIRE <= r_1WIRE_Main AND r_LINE4_1WIRE_WriteBit;

--     o_Test(0) <= r_CRC0(0);
--     o_Test(1) <= r_CRC0(1);
--     o_Test(2) <= r_CRC0(2);
--     o_Test(3) <= r_CRC0(3);
--     o_Test(4) <= r_CRC0(4);
--     o_Test(5) <= r_CRC0(5);
--     o_Test(6) <= r_CRC0(6);
--     o_Test(7) <= '1' when (r_Cnt_Bit_Rx = 72) else '0';

end arch;