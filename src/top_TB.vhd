library TOP;
use TOP.pack.all;
library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

-- Add your library and packages declaration here ...

entity top_tb is
end top_tb;

architecture TB_ARCHITECTURE of top_tb is
  -- Component declaration of the tested unit
  component top
    port (
      CLK_50MHz : in std_logic;
      CLK_16MHz : in std_logic;
      LED_D3    : out std_logic;
      LED_D4    : out std_logic;
      LED_D5    : out std_logic;
      LED_D6    : out std_logic;
      LED_D7    : out std_logic;
      LED_D8    : out std_logic;
      p28       : inout std_logic;
      p30       : out std_logic;
      p32       : out std_logic;
      p33       : out std_logic;
      p38       : out std_logic;
      p39       : out std_logic;
      p42       : out std_logic;
      p43       : out std_logic;
      p44       : out std_logic;
      p46       : out std_logic;
      p49       : out std_logic;
      p113      : out std_logic;
      p114      : in std_logic;
      p127      : out std_logic;
      p126      : out std_logic;
      p125      : out std_logic;
      p124      : out std_logic;
      p121      : out std_logic;
      p120      : out std_logic;
      p119      : out std_logic;
      p115      : out std_logic;
      p128      : out std_logic;
      p129      : out std_logic;
      p132      : out std_logic;
      p133      : out std_logic;
      p135      : out std_logic;
      p136      : out std_logic;
      p137      : out std_logic;
      p138      : out std_logic);
  end component;

  -- Stimulus signals - signals mapped to the input and inout ports of tested entity
  signal CLK_50MHz : std_logic;
  signal CLK_16MHz : std_logic;
  signal p114      : std_logic;
  signal p28       : std_logic;
  -- Observed signals - signals mapped to the output ports of tested entity
  signal LED_D3 : std_logic;
  signal LED_D4 : std_logic;
  signal LED_D5 : std_logic;
  signal LED_D6 : std_logic;
  signal LED_D7 : std_logic;
  signal LED_D8 : std_logic;
  signal p30    : std_logic;
  signal p32    : std_logic;
  signal p33    : std_logic;
  signal p38    : std_logic;
  signal p39    : std_logic;
  signal p42    : std_logic;
  signal p43    : std_logic;
  signal p44    : std_logic;
  signal p46    : std_logic;
  signal p49    : std_logic;
  signal p113   : std_logic;
  signal p127   : std_logic;
  signal p126   : std_logic;
  signal p125   : std_logic;
  signal p124   : std_logic;
  signal p121   : std_logic;
  signal p120   : std_logic;
  signal p119   : std_logic;
  signal p115   : std_logic;
  signal p128   : std_logic;
  signal p129   : std_logic;
  signal p132   : std_logic;
  signal p133   : std_logic;
  signal p135   : std_logic;
  signal p136   : std_logic;
  signal p137   : std_logic;
  signal p138   : std_logic;

  -- Add your code here ...
  -- Clock period
  constant clk_period : time := 61.035 ns; -- 16,384 MHz

begin

  -- Unit Under Test port map
  UUT : top
  port map
  (
    CLK_50MHz => CLK_50MHz,
    CLK_16MHz => CLK_16MHz,
    LED_D3    => LED_D3,
    LED_D4    => LED_D4,
    LED_D5    => LED_D5,
    LED_D6    => LED_D6,
    LED_D7    => LED_D7,
    LED_D8    => LED_D8,
    p28       => p28,
    p30       => p30,
    p32       => p32,
    p33       => p33,
    p38       => p38,
    p39       => p39,
    p42       => p42,
    p43       => p43,
    p44       => p44,
    p46       => p46,
    p49       => p49,
    p113      => p113,
    p114      => p114,
    p127      => p127,
    p126      => p126,
    p125      => p125,
    p124      => p124,
    p121      => p121,
    p120      => p120,
    p119      => p119,
    p115      => p115,
    p128      => p128,
    p129      => p129,
    p132      => p132,
    p133      => p133,
    p135      => p135,
    p136      => p136,
    p137      => p137,
    p138      => p138
  );

  -- Add your stimulus here ...

  -- Clock generation
  clk_process : process
  begin
    CLK_16MHz <= '0';
    wait for clk_period/2;
    CLK_16MHz <= '1';
    wait for clk_period/2;
  end process;


  ow_device : process
  begin
	p28 <= 'Z';
    -- Ждем когда мастер опустит линию в '0'
    wait until p28 = '0';
    wait for 1029 us;
	
	p28 <= '0';
    wait for 100 us;
	p28 <= '1';
    wait for 437 us;
	p28 <= 'Z';

    wait;
  end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_top of top_tb is
  for TB_ARCHITECTURE
    for UUT : top
      use entity work.top(rtl);
    end for;
  end for;
end TESTBENCH_FOR_top;
