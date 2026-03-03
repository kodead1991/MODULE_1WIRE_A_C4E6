-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

-- DATE "03/03/2026 15:47:52"

-- 
-- Device: Altera EP4CE6E22C8 Package TQFP144
-- 

-- 
-- This VHDL file should be used for Active-HDL (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	TOP IS
    PORT (
	CLK_50MHz : IN std_logic;
	CLK_16MHz : IN std_logic;
	LED_D3 : OUT std_logic;
	LED_D4 : OUT std_logic;
	LED_D5 : OUT std_logic;
	LED_D6 : OUT std_logic;
	LED_D7 : OUT std_logic;
	LED_D8 : OUT std_logic;
	p28 : OUT std_logic;
	p30 : OUT std_logic;
	p32 : OUT std_logic;
	p33 : OUT std_logic;
	p38 : OUT std_logic;
	p39 : OUT std_logic;
	p42 : OUT std_logic;
	p43 : OUT std_logic;
	p44 : OUT std_logic;
	p46 : OUT std_logic;
	p49 : OUT std_logic;
	p113 : OUT std_logic;
	p114 : IN std_logic;
	p127 : OUT std_logic;
	p126 : OUT std_logic;
	p125 : OUT std_logic;
	p124 : OUT std_logic;
	p121 : OUT std_logic;
	p120 : OUT std_logic;
	p119 : OUT std_logic;
	p115 : OUT std_logic;
	p128 : OUT std_logic;
	p129 : OUT std_logic;
	p132 : OUT std_logic;
	p133 : OUT std_logic;
	p135 : OUT std_logic;
	p136 : OUT std_logic;
	p137 : OUT std_logic;
	p138 : OUT std_logic
	);
END TOP;

-- Design Ports Information
-- CLK_50MHz	=>  Location: PIN_23,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED_D3	=>  Location: PIN_72,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED_D4	=>  Location: PIN_73,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED_D5	=>  Location: PIN_74,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED_D6	=>  Location: PIN_80,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED_D7	=>  Location: PIN_83,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LED_D8	=>  Location: PIN_84,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p28	=>  Location: PIN_28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p30	=>  Location: PIN_30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p32	=>  Location: PIN_32,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p33	=>  Location: PIN_33,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p38	=>  Location: PIN_38,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p39	=>  Location: PIN_39,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p42	=>  Location: PIN_42,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p43	=>  Location: PIN_43,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p44	=>  Location: PIN_44,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p46	=>  Location: PIN_46,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p49	=>  Location: PIN_49,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p113	=>  Location: PIN_113,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p114	=>  Location: PIN_114,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p127	=>  Location: PIN_127,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p126	=>  Location: PIN_126,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p125	=>  Location: PIN_125,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p124	=>  Location: PIN_124,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p121	=>  Location: PIN_121,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p120	=>  Location: PIN_120,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p119	=>  Location: PIN_119,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p115	=>  Location: PIN_115,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p128	=>  Location: PIN_128,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p129	=>  Location: PIN_129,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p132	=>  Location: PIN_132,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p133	=>  Location: PIN_133,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p135	=>  Location: PIN_135,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p136	=>  Location: PIN_136,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p137	=>  Location: PIN_137,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- p138	=>  Location: PIN_138,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- CLK_16MHz	=>  Location: PIN_24,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF TOP IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_CLK_50MHz : std_logic;
SIGNAL ww_CLK_16MHz : std_logic;
SIGNAL ww_LED_D3 : std_logic;
SIGNAL ww_LED_D4 : std_logic;
SIGNAL ww_LED_D5 : std_logic;
SIGNAL ww_LED_D6 : std_logic;
SIGNAL ww_LED_D7 : std_logic;
SIGNAL ww_LED_D8 : std_logic;
SIGNAL ww_p28 : std_logic;
SIGNAL ww_p30 : std_logic;
SIGNAL ww_p32 : std_logic;
SIGNAL ww_p33 : std_logic;
SIGNAL ww_p38 : std_logic;
SIGNAL ww_p39 : std_logic;
SIGNAL ww_p42 : std_logic;
SIGNAL ww_p43 : std_logic;
SIGNAL ww_p44 : std_logic;
SIGNAL ww_p46 : std_logic;
SIGNAL ww_p49 : std_logic;
SIGNAL ww_p113 : std_logic;
SIGNAL ww_p114 : std_logic;
SIGNAL ww_p127 : std_logic;
SIGNAL ww_p126 : std_logic;
SIGNAL ww_p125 : std_logic;
SIGNAL ww_p124 : std_logic;
SIGNAL ww_p121 : std_logic;
SIGNAL ww_p120 : std_logic;
SIGNAL ww_p119 : std_logic;
SIGNAL ww_p115 : std_logic;
SIGNAL ww_p128 : std_logic;
SIGNAL ww_p129 : std_logic;
SIGNAL ww_p132 : std_logic;
SIGNAL ww_p133 : std_logic;
SIGNAL ww_p135 : std_logic;
SIGNAL ww_p136 : std_logic;
SIGNAL ww_p137 : std_logic;
SIGNAL ww_p138 : std_logic;
SIGNAL \CLK_16MHz~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \r_Cnt[3]~19_combout\ : std_logic;
SIGNAL \r_Cnt[0]~45_combout\ : std_logic;
SIGNAL \CLK_50MHz~input_o\ : std_logic;
SIGNAL \p114~input_o\ : std_logic;
SIGNAL \LED_D3~output_o\ : std_logic;
SIGNAL \LED_D4~output_o\ : std_logic;
SIGNAL \LED_D5~output_o\ : std_logic;
SIGNAL \LED_D6~output_o\ : std_logic;
SIGNAL \LED_D7~output_o\ : std_logic;
SIGNAL \LED_D8~output_o\ : std_logic;
SIGNAL \p28~output_o\ : std_logic;
SIGNAL \p30~output_o\ : std_logic;
SIGNAL \p32~output_o\ : std_logic;
SIGNAL \p33~output_o\ : std_logic;
SIGNAL \p38~output_o\ : std_logic;
SIGNAL \p39~output_o\ : std_logic;
SIGNAL \p42~output_o\ : std_logic;
SIGNAL \p43~output_o\ : std_logic;
SIGNAL \p44~output_o\ : std_logic;
SIGNAL \p46~output_o\ : std_logic;
SIGNAL \p49~output_o\ : std_logic;
SIGNAL \p113~output_o\ : std_logic;
SIGNAL \p127~output_o\ : std_logic;
SIGNAL \p126~output_o\ : std_logic;
SIGNAL \p125~output_o\ : std_logic;
SIGNAL \p124~output_o\ : std_logic;
SIGNAL \p121~output_o\ : std_logic;
SIGNAL \p120~output_o\ : std_logic;
SIGNAL \p119~output_o\ : std_logic;
SIGNAL \p115~output_o\ : std_logic;
SIGNAL \p128~output_o\ : std_logic;
SIGNAL \p129~output_o\ : std_logic;
SIGNAL \p132~output_o\ : std_logic;
SIGNAL \p133~output_o\ : std_logic;
SIGNAL \p135~output_o\ : std_logic;
SIGNAL \p136~output_o\ : std_logic;
SIGNAL \p137~output_o\ : std_logic;
SIGNAL \p138~output_o\ : std_logic;
SIGNAL \CLK_16MHz~input_o\ : std_logic;
SIGNAL \CLK_16MHz~inputclkctrl_outclk\ : std_logic;
SIGNAL \r_Cnt[1]~15_combout\ : std_logic;
SIGNAL \r_Cnt[1]~16\ : std_logic;
SIGNAL \r_Cnt[2]~17_combout\ : std_logic;
SIGNAL \r_Cnt[2]~18\ : std_logic;
SIGNAL \r_Cnt[3]~20\ : std_logic;
SIGNAL \r_Cnt[4]~21_combout\ : std_logic;
SIGNAL \r_Cnt[4]~22\ : std_logic;
SIGNAL \r_Cnt[5]~23_combout\ : std_logic;
SIGNAL \r_Cnt[5]~24\ : std_logic;
SIGNAL \r_Cnt[6]~25_combout\ : std_logic;
SIGNAL \r_Cnt[6]~26\ : std_logic;
SIGNAL \r_Cnt[7]~27_combout\ : std_logic;
SIGNAL \r_Cnt[7]~28\ : std_logic;
SIGNAL \r_Cnt[8]~29_combout\ : std_logic;
SIGNAL \r_Cnt[8]~30\ : std_logic;
SIGNAL \r_Cnt[9]~31_combout\ : std_logic;
SIGNAL \r_Cnt[9]~32\ : std_logic;
SIGNAL \r_Cnt[10]~33_combout\ : std_logic;
SIGNAL \r_Cnt[10]~34\ : std_logic;
SIGNAL \r_Cnt[11]~35_combout\ : std_logic;
SIGNAL \r_Cnt[11]~36\ : std_logic;
SIGNAL \r_Cnt[12]~37_combout\ : std_logic;
SIGNAL \r_Cnt[12]~38\ : std_logic;
SIGNAL \r_Cnt[13]~39_combout\ : std_logic;
SIGNAL \r_Cnt[13]~40\ : std_logic;
SIGNAL \r_Cnt[14]~41_combout\ : std_logic;
SIGNAL \r_Cnt[14]~42\ : std_logic;
SIGNAL \r_Cnt[15]~43_combout\ : std_logic;
SIGNAL r_Cnt : std_logic_vector(15 DOWNTO 0);

BEGIN

ww_CLK_50MHz <= CLK_50MHz;
ww_CLK_16MHz <= CLK_16MHz;
LED_D3 <= ww_LED_D3;
LED_D4 <= ww_LED_D4;
LED_D5 <= ww_LED_D5;
LED_D6 <= ww_LED_D6;
LED_D7 <= ww_LED_D7;
LED_D8 <= ww_LED_D8;
p28 <= ww_p28;
p30 <= ww_p30;
p32 <= ww_p32;
p33 <= ww_p33;
p38 <= ww_p38;
p39 <= ww_p39;
p42 <= ww_p42;
p43 <= ww_p43;
p44 <= ww_p44;
p46 <= ww_p46;
p49 <= ww_p49;
p113 <= ww_p113;
ww_p114 <= p114;
p127 <= ww_p127;
p126 <= ww_p126;
p125 <= ww_p125;
p124 <= ww_p124;
p121 <= ww_p121;
p120 <= ww_p120;
p119 <= ww_p119;
p115 <= ww_p115;
p128 <= ww_p128;
p129 <= ww_p129;
p132 <= ww_p132;
p133 <= ww_p133;
p135 <= ww_p135;
p136 <= ww_p136;
p137 <= ww_p137;
p138 <= ww_p138;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\CLK_16MHz~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \CLK_16MHz~input_o\);

-- Location: FF_X1_Y4_N7
\r_Cnt[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[3]~19_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(3));

-- Location: LCCOMB_X1_Y4_N6
\r_Cnt[3]~19\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[3]~19_combout\ = (r_Cnt(3) & (\r_Cnt[2]~18\ $ (GND))) # (!r_Cnt(3) & (!\r_Cnt[2]~18\ & VCC))
-- \r_Cnt[3]~20\ = CARRY((r_Cnt(3) & !\r_Cnt[2]~18\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => r_Cnt(3),
	datad => VCC,
	cin => \r_Cnt[2]~18\,
	combout => \r_Cnt[3]~19_combout\,
	cout => \r_Cnt[3]~20\);

-- Location: FF_X1_Y4_N1
\r_Cnt[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[0]~45_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(0));

-- Location: LCCOMB_X1_Y4_N0
\r_Cnt[0]~45\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[0]~45_combout\ = !r_Cnt(0)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => r_Cnt(0),
	combout => \r_Cnt[0]~45_combout\);

-- Location: IOOBUF_X32_Y0_N9
\LED_D3~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LED_D3~output_o\);

-- Location: IOOBUF_X34_Y2_N23
\LED_D4~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LED_D4~output_o\);

-- Location: IOOBUF_X34_Y2_N16
\LED_D5~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LED_D5~output_o\);

-- Location: IOOBUF_X34_Y7_N9
\LED_D6~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LED_D6~output_o\);

-- Location: IOOBUF_X34_Y9_N23
\LED_D7~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LED_D7~output_o\);

-- Location: IOOBUF_X34_Y9_N16
\LED_D8~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LED_D8~output_o\);

-- Location: IOOBUF_X0_Y9_N9
\p28~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => r_Cnt(5),
	devoe => ww_devoe,
	o => \p28~output_o\);

-- Location: IOOBUF_X0_Y8_N16
\p30~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => r_Cnt(6),
	devoe => ww_devoe,
	o => \p30~output_o\);

-- Location: IOOBUF_X0_Y6_N16
\p32~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => r_Cnt(7),
	devoe => ww_devoe,
	o => \p32~output_o\);

-- Location: IOOBUF_X0_Y6_N23
\p33~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => r_Cnt(8),
	devoe => ww_devoe,
	o => \p33~output_o\);

-- Location: IOOBUF_X1_Y0_N23
\p38~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => r_Cnt(9),
	devoe => ww_devoe,
	o => \p38~output_o\);

-- Location: IOOBUF_X1_Y0_N16
\p39~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => r_Cnt(10),
	devoe => ww_devoe,
	o => \p39~output_o\);

-- Location: IOOBUF_X3_Y0_N2
\p42~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => r_Cnt(11),
	devoe => ww_devoe,
	o => \p42~output_o\);

-- Location: IOOBUF_X5_Y0_N23
\p43~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => r_Cnt(12),
	devoe => ww_devoe,
	o => \p43~output_o\);

-- Location: IOOBUF_X5_Y0_N16
\p44~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => r_Cnt(13),
	devoe => ww_devoe,
	o => \p44~output_o\);

-- Location: IOOBUF_X7_Y0_N2
\p46~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => r_Cnt(14),
	devoe => ww_devoe,
	o => \p46~output_o\);

-- Location: IOOBUF_X13_Y0_N16
\p49~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => r_Cnt(15),
	devoe => ww_devoe,
	o => \p49~output_o\);

-- Location: IOOBUF_X28_Y24_N9
\p113~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p113~output_o\);

-- Location: IOOBUF_X16_Y24_N9
\p127~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p127~output_o\);

-- Location: IOOBUF_X16_Y24_N2
\p126~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p126~output_o\);

-- Location: IOOBUF_X18_Y24_N23
\p125~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p125~output_o\);

-- Location: IOOBUF_X18_Y24_N16
\p124~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p124~output_o\);

-- Location: IOOBUF_X23_Y24_N16
\p121~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p121~output_o\);

-- Location: IOOBUF_X23_Y24_N9
\p120~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p120~output_o\);

-- Location: IOOBUF_X23_Y24_N2
\p119~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p119~output_o\);

-- Location: IOOBUF_X28_Y24_N23
\p115~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p115~output_o\);

-- Location: IOOBUF_X16_Y24_N16
\p128~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p128~output_o\);

-- Location: IOOBUF_X16_Y24_N23
\p129~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p129~output_o\);

-- Location: IOOBUF_X13_Y24_N16
\p132~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p132~output_o\);

-- Location: IOOBUF_X13_Y24_N23
\p133~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p133~output_o\);

-- Location: IOOBUF_X11_Y24_N16
\p135~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p135~output_o\);

-- Location: IOOBUF_X9_Y24_N9
\p136~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p136~output_o\);

-- Location: IOOBUF_X7_Y24_N2
\p137~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p137~output_o\);

-- Location: IOOBUF_X7_Y24_N9
\p138~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \p138~output_o\);

-- Location: IOIBUF_X0_Y11_N15
\CLK_16MHz~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_CLK_16MHz,
	o => \CLK_16MHz~input_o\);

-- Location: CLKCTRL_G4
\CLK_16MHz~inputclkctrl\ : cycloneive_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \CLK_16MHz~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \CLK_16MHz~inputclkctrl_outclk\);

-- Location: LCCOMB_X1_Y4_N2
\r_Cnt[1]~15\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[1]~15_combout\ = (r_Cnt(0) & (r_Cnt(1) $ (VCC))) # (!r_Cnt(0) & (r_Cnt(1) & VCC))
-- \r_Cnt[1]~16\ = CARRY((r_Cnt(0) & r_Cnt(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => r_Cnt(0),
	datab => r_Cnt(1),
	datad => VCC,
	combout => \r_Cnt[1]~15_combout\,
	cout => \r_Cnt[1]~16\);

-- Location: FF_X1_Y4_N3
\r_Cnt[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[1]~15_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(1));

-- Location: LCCOMB_X1_Y4_N4
\r_Cnt[2]~17\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[2]~17_combout\ = (r_Cnt(2) & (!\r_Cnt[1]~16\)) # (!r_Cnt(2) & ((\r_Cnt[1]~16\) # (GND)))
-- \r_Cnt[2]~18\ = CARRY((!\r_Cnt[1]~16\) # (!r_Cnt(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => r_Cnt(2),
	datad => VCC,
	cin => \r_Cnt[1]~16\,
	combout => \r_Cnt[2]~17_combout\,
	cout => \r_Cnt[2]~18\);

-- Location: FF_X1_Y4_N5
\r_Cnt[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[2]~17_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(2));

-- Location: LCCOMB_X1_Y4_N8
\r_Cnt[4]~21\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[4]~21_combout\ = (r_Cnt(4) & (!\r_Cnt[3]~20\)) # (!r_Cnt(4) & ((\r_Cnt[3]~20\) # (GND)))
-- \r_Cnt[4]~22\ = CARRY((!\r_Cnt[3]~20\) # (!r_Cnt(4)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => r_Cnt(4),
	datad => VCC,
	cin => \r_Cnt[3]~20\,
	combout => \r_Cnt[4]~21_combout\,
	cout => \r_Cnt[4]~22\);

-- Location: FF_X1_Y4_N9
\r_Cnt[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[4]~21_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(4));

-- Location: LCCOMB_X1_Y4_N10
\r_Cnt[5]~23\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[5]~23_combout\ = (r_Cnt(5) & (\r_Cnt[4]~22\ $ (GND))) # (!r_Cnt(5) & (!\r_Cnt[4]~22\ & VCC))
-- \r_Cnt[5]~24\ = CARRY((r_Cnt(5) & !\r_Cnt[4]~22\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => r_Cnt(5),
	datad => VCC,
	cin => \r_Cnt[4]~22\,
	combout => \r_Cnt[5]~23_combout\,
	cout => \r_Cnt[5]~24\);

-- Location: FF_X1_Y4_N11
\r_Cnt[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[5]~23_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(5));

-- Location: LCCOMB_X1_Y4_N12
\r_Cnt[6]~25\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[6]~25_combout\ = (r_Cnt(6) & (!\r_Cnt[5]~24\)) # (!r_Cnt(6) & ((\r_Cnt[5]~24\) # (GND)))
-- \r_Cnt[6]~26\ = CARRY((!\r_Cnt[5]~24\) # (!r_Cnt(6)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => r_Cnt(6),
	datad => VCC,
	cin => \r_Cnt[5]~24\,
	combout => \r_Cnt[6]~25_combout\,
	cout => \r_Cnt[6]~26\);

-- Location: FF_X1_Y4_N13
\r_Cnt[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[6]~25_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(6));

-- Location: LCCOMB_X1_Y4_N14
\r_Cnt[7]~27\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[7]~27_combout\ = (r_Cnt(7) & (\r_Cnt[6]~26\ $ (GND))) # (!r_Cnt(7) & (!\r_Cnt[6]~26\ & VCC))
-- \r_Cnt[7]~28\ = CARRY((r_Cnt(7) & !\r_Cnt[6]~26\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => r_Cnt(7),
	datad => VCC,
	cin => \r_Cnt[6]~26\,
	combout => \r_Cnt[7]~27_combout\,
	cout => \r_Cnt[7]~28\);

-- Location: FF_X1_Y4_N15
\r_Cnt[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[7]~27_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(7));

-- Location: LCCOMB_X1_Y4_N16
\r_Cnt[8]~29\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[8]~29_combout\ = (r_Cnt(8) & (!\r_Cnt[7]~28\)) # (!r_Cnt(8) & ((\r_Cnt[7]~28\) # (GND)))
-- \r_Cnt[8]~30\ = CARRY((!\r_Cnt[7]~28\) # (!r_Cnt(8)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => r_Cnt(8),
	datad => VCC,
	cin => \r_Cnt[7]~28\,
	combout => \r_Cnt[8]~29_combout\,
	cout => \r_Cnt[8]~30\);

-- Location: FF_X1_Y4_N17
\r_Cnt[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[8]~29_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(8));

-- Location: LCCOMB_X1_Y4_N18
\r_Cnt[9]~31\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[9]~31_combout\ = (r_Cnt(9) & (\r_Cnt[8]~30\ $ (GND))) # (!r_Cnt(9) & (!\r_Cnt[8]~30\ & VCC))
-- \r_Cnt[9]~32\ = CARRY((r_Cnt(9) & !\r_Cnt[8]~30\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => r_Cnt(9),
	datad => VCC,
	cin => \r_Cnt[8]~30\,
	combout => \r_Cnt[9]~31_combout\,
	cout => \r_Cnt[9]~32\);

-- Location: FF_X1_Y4_N19
\r_Cnt[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[9]~31_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(9));

-- Location: LCCOMB_X1_Y4_N20
\r_Cnt[10]~33\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[10]~33_combout\ = (r_Cnt(10) & (!\r_Cnt[9]~32\)) # (!r_Cnt(10) & ((\r_Cnt[9]~32\) # (GND)))
-- \r_Cnt[10]~34\ = CARRY((!\r_Cnt[9]~32\) # (!r_Cnt(10)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => r_Cnt(10),
	datad => VCC,
	cin => \r_Cnt[9]~32\,
	combout => \r_Cnt[10]~33_combout\,
	cout => \r_Cnt[10]~34\);

-- Location: FF_X1_Y4_N21
\r_Cnt[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[10]~33_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(10));

-- Location: LCCOMB_X1_Y4_N22
\r_Cnt[11]~35\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[11]~35_combout\ = (r_Cnt(11) & (\r_Cnt[10]~34\ $ (GND))) # (!r_Cnt(11) & (!\r_Cnt[10]~34\ & VCC))
-- \r_Cnt[11]~36\ = CARRY((r_Cnt(11) & !\r_Cnt[10]~34\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => r_Cnt(11),
	datad => VCC,
	cin => \r_Cnt[10]~34\,
	combout => \r_Cnt[11]~35_combout\,
	cout => \r_Cnt[11]~36\);

-- Location: FF_X1_Y4_N23
\r_Cnt[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[11]~35_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(11));

-- Location: LCCOMB_X1_Y4_N24
\r_Cnt[12]~37\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[12]~37_combout\ = (r_Cnt(12) & (!\r_Cnt[11]~36\)) # (!r_Cnt(12) & ((\r_Cnt[11]~36\) # (GND)))
-- \r_Cnt[12]~38\ = CARRY((!\r_Cnt[11]~36\) # (!r_Cnt(12)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => r_Cnt(12),
	datad => VCC,
	cin => \r_Cnt[11]~36\,
	combout => \r_Cnt[12]~37_combout\,
	cout => \r_Cnt[12]~38\);

-- Location: FF_X1_Y4_N25
\r_Cnt[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[12]~37_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(12));

-- Location: LCCOMB_X1_Y4_N26
\r_Cnt[13]~39\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[13]~39_combout\ = (r_Cnt(13) & (\r_Cnt[12]~38\ $ (GND))) # (!r_Cnt(13) & (!\r_Cnt[12]~38\ & VCC))
-- \r_Cnt[13]~40\ = CARRY((r_Cnt(13) & !\r_Cnt[12]~38\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => r_Cnt(13),
	datad => VCC,
	cin => \r_Cnt[12]~38\,
	combout => \r_Cnt[13]~39_combout\,
	cout => \r_Cnt[13]~40\);

-- Location: FF_X1_Y4_N27
\r_Cnt[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[13]~39_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(13));

-- Location: LCCOMB_X1_Y4_N28
\r_Cnt[14]~41\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[14]~41_combout\ = (r_Cnt(14) & (!\r_Cnt[13]~40\)) # (!r_Cnt(14) & ((\r_Cnt[13]~40\) # (GND)))
-- \r_Cnt[14]~42\ = CARRY((!\r_Cnt[13]~40\) # (!r_Cnt(14)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => r_Cnt(14),
	datad => VCC,
	cin => \r_Cnt[13]~40\,
	combout => \r_Cnt[14]~41_combout\,
	cout => \r_Cnt[14]~42\);

-- Location: FF_X1_Y4_N29
\r_Cnt[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[14]~41_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(14));

-- Location: LCCOMB_X1_Y4_N30
\r_Cnt[15]~43\ : cycloneive_lcell_comb
-- Equation(s):
-- \r_Cnt[15]~43_combout\ = r_Cnt(15) $ (!\r_Cnt[14]~42\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010110100101",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => r_Cnt(15),
	cin => \r_Cnt[14]~42\,
	combout => \r_Cnt[15]~43_combout\);

-- Location: FF_X1_Y4_N31
\r_Cnt[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLK_16MHz~inputclkctrl_outclk\,
	d => \r_Cnt[15]~43_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_Cnt(15));

-- Location: IOIBUF_X0_Y11_N8
\CLK_50MHz~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_CLK_50MHz,
	o => \CLK_50MHz~input_o\);

-- Location: IOIBUF_X28_Y24_N15
\p114~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_p114,
	o => \p114~input_o\);

ww_LED_D3 <= \LED_D3~output_o\;

ww_LED_D4 <= \LED_D4~output_o\;

ww_LED_D5 <= \LED_D5~output_o\;

ww_LED_D6 <= \LED_D6~output_o\;

ww_LED_D7 <= \LED_D7~output_o\;

ww_LED_D8 <= \LED_D8~output_o\;

ww_p28 <= \p28~output_o\;

ww_p30 <= \p30~output_o\;

ww_p32 <= \p32~output_o\;

ww_p33 <= \p33~output_o\;

ww_p38 <= \p38~output_o\;

ww_p39 <= \p39~output_o\;

ww_p42 <= \p42~output_o\;

ww_p43 <= \p43~output_o\;

ww_p44 <= \p44~output_o\;

ww_p46 <= \p46~output_o\;

ww_p49 <= \p49~output_o\;

ww_p113 <= \p113~output_o\;

ww_p127 <= \p127~output_o\;

ww_p126 <= \p126~output_o\;

ww_p125 <= \p125~output_o\;

ww_p124 <= \p124~output_o\;

ww_p121 <= \p121~output_o\;

ww_p120 <= \p120~output_o\;

ww_p119 <= \p119~output_o\;

ww_p115 <= \p115~output_o\;

ww_p128 <= \p128~output_o\;

ww_p129 <= \p129~output_o\;

ww_p132 <= \p132~output_o\;

ww_p133 <= \p133~output_o\;

ww_p135 <= \p135~output_o\;

ww_p136 <= \p136~output_o\;

ww_p137 <= \p137~output_o\;

ww_p138 <= \p138~output_o\;
END structure;


