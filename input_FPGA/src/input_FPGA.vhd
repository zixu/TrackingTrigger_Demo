-------------------------------------------------------------------------------
--
-- Title       : input_FPGA
-- Design      : DAQ
-- Author      : zixu
-- Company     : pku
--
-------------------------------------------------------------------------------
--

-- Generated   : Tue Feb  3 23:19:58 2015
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {input_FPGA} architecture {input_FPGA}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity input_FPGA is 
	generic (
				number_patterns: INTEGER :=1;
				number_data: INTEGER :=1);
	port(
			CLOCK : in STD_LOGIC;
			EN_pattern : in STD_LOGIC;
			EN_DAQ : in STD_LOGIC;
			LOAD_pattern : out STD_LOGIC;
			EOE_DAQ : out STD_LOGIC;
			LAYER7_BX : out STD_LOGIC_VECTOR(2 downto 0);
			LAYER6_BX : out STD_LOGIC_VECTOR(2 downto 0);
			LAYER5_BX : out STD_LOGIC_VECTOR(2 downto 0);
			LAYER4_BX : out STD_LOGIC_VECTOR(2 downto 0);
			LAYER3_BX : out STD_LOGIC_VECTOR(2 downto 0);
			LAYER2_BX : out STD_LOGIC_VECTOR(2 downto 0);
			LAYER1_BX : out STD_LOGIC_VECTOR(2 downto 0);
			LAYER0_BX : out STD_LOGIC_VECTOR(2 downto 0);
			LAYER7 : out STD_LOGIC_VECTOR(14 downto 0);
			LAYER6 : out STD_LOGIC_VECTOR(14 downto 0);
			LAYER5 : out STD_LOGIC_VECTOR(14 downto 0);
			LAYER4 : out STD_LOGIC_VECTOR(14 downto 0);
			LAYER3 : out STD_LOGIC_VECTOR(14 downto 0);
			LAYER2 : out STD_LOGIC_VECTOR(14 downto 0);
			LAYER1 : out STD_LOGIC_VECTOR(14 downto 0);
			LAYER0 : out STD_LOGIC_VECTOR(14 downto 0)
		);
end input_FPGA;

--}} End of automatically maintained section

architecture input_FPGA of input_FPGA is  


	-- Component declaration of the tested unit
	component daq
		generic(
				   number_data : INTEGER := 1 );
		port(
				CLOCK : in STD_LOGIC;
				EN : in STD_LOGIC;
				EOE : out STD_LOGIC;
				LAYER0 : out STD_LOGIC_VECTOR(14 downto 0);
				LAYER1 : out STD_LOGIC_VECTOR(14 downto 0);
				LAYER2 : out STD_LOGIC_VECTOR(14 downto 0);
				LAYER3 : out STD_LOGIC_VECTOR(14 downto 0);
				LAYER4 : out STD_LOGIC_VECTOR(14 downto 0);
				LAYER5 : out STD_LOGIC_VECTOR(14 downto 0);
				LAYER6 : out STD_LOGIC_VECTOR(14 downto 0);
				LAYER7 : out STD_LOGIC_VECTOR(14 downto 0);
				LAYER0_BX : out STD_LOGIC_VECTOR(2 downto 0);
				LAYER1_BX : out STD_LOGIC_VECTOR(2 downto 0);
				LAYER2_BX : out STD_LOGIC_VECTOR(2 downto 0);
				LAYER3_BX : out STD_LOGIC_VECTOR(2 downto 0);
				LAYER4_BX : out STD_LOGIC_VECTOR(2 downto 0);
				LAYER5_BX : out STD_LOGIC_VECTOR(2 downto 0);
				LAYER6_BX : out STD_LOGIC_VECTOR(2 downto 0);
				LAYER7_BX : out STD_LOGIC_VECTOR(2 downto 0) );
	end component;
	type array_8x15_type is array(7 downto 0) of std_logic_vector(14 downto 0);
	signal layer_reg_events: array_8x15_type;--from event
	signal layer_reg_pattern: array_8x15_type;--from pattern
	signal layer_reg: array_8x15_type;--output


	-- Component declaration of the tested unit
	component bank_load
		generic(
		number_patterns : INTEGER );
		port(
				CLOCK : in STD_LOGIC;
				EN : in STD_LOGIC;
				LOAD : out STD_LOGIC;
				Pattern_layer0 : out STD_LOGIC_VECTOR(2 downto 0);
				Pattern_layer1 : out STD_LOGIC_VECTOR(2 downto 0);
				Pattern_layer2 : out STD_LOGIC_VECTOR(2 downto 0);
				Pattern_layer3 : out STD_LOGIC_VECTOR(2 downto 0);
				Pattern_layer4 : out STD_LOGIC_VECTOR(2 downto 0);
				Pattern_layer5 : out STD_LOGIC_VECTOR(2 downto 0);
				Pattern_layer6 : out STD_LOGIC_VECTOR(2 downto 0);
				Pattern_layer7 : out STD_LOGIC_VECTOR(2 downto 0);
				Pattern_position: out STD_LOGIC_VECTOR(9 downto 0)
			);
	end component;
	signal LOAD_pattern_reg: STD_LOGIC:='0';




begin

	LAYER0<=layer_reg(0);
	LAYER1<=layer_reg(1);
	LAYER2<=layer_reg(2);
	LAYER3<=layer_reg(3);
	LAYER4<=layer_reg(4);
	LAYER5<=layer_reg(5);
	LAYER6<=layer_reg(6);
	LAYER7<=layer_reg(7);



	--with std_logic_vector'(EN_DAQ, EN_pattern) select
	--	LOAD_pattern_reg<='1' when "01",
	--					  '0' when "10";
	LOAD_pattern_reg<='1' when EN_pattern='1' else
					  '0' when EN_DAQ='1';

	with LOAD_pattern_reg select
		layer_reg<= layer_reg_pattern when '1',
					 layer_reg_events when others;


	--proc: process(CLOCK)
	--begin
	--	if rising_edge(CLOCK) then

	--		with std_logic_vector'(EN_DAQ, EN_pattern) select
	--			LOAD_pattern_reg<='1' when "01",
	--							  '0' when "10",
	--							  unaffected when others;

	--		with LOAD_pattern_reg select
	--			layer_reg<= layer_reg_pattern when '1',
	--						 layer_reg_events when others;

	--	end if;

	--end process proc;


	--EN_pattern_reg<=EN_pattern;
	--EN_DAQ_reg<=EN_DAQ;

	--layer_reg<=layer_reg_pattern;
	--with std_logic_vector'(EN_DAQ_reg, EN_pattern_reg) select



	UUT_DAQ : daq
	generic map (
					number_data => number_data
				)

	port map (
				 CLOCK => CLOCK,
				 EN => EN_DAQ,
				 EOE => EOE_DAQ,
				 LAYER0 => layer_reg_events(0),
				 LAYER1 => layer_reg_events(1),
				 LAYER2 => layer_reg_events(2),
				 LAYER3 => layer_reg_events(3),
				 LAYER4 => layer_reg_events(4),
				 LAYER5 => layer_reg_events(5),
				 LAYER6 => layer_reg_events(6),
				 LAYER7 => layer_reg_events(7),
				 LAYER0_BX => LAYER0_BX,
				 LAYER1_BX => LAYER1_BX,
				 LAYER2_BX => LAYER2_BX,
				 LAYER3_BX => LAYER3_BX,
				 LAYER4_BX => LAYER4_BX,
				 LAYER5_BX => LAYER5_BX,
				 LAYER6_BX => LAYER6_BX,
				 LAYER7_BX => LAYER7_BX
			 );


	UUT_bank_load : bank_load
	generic map (
					number_patterns => number_patterns
				)

	port map (
				 CLOCK => CLOCK,
				 EN => EN_pattern,
				 LOAD => LOAD_pattern,
				 Pattern_layer0=>layer_reg_pattern(0)(2 downto 0),
				 Pattern_layer1=>layer_reg_pattern(1)(2 downto 0),
				 Pattern_layer2=>layer_reg_pattern(2)(2 downto 0),
				 Pattern_layer3=>layer_reg_pattern(3)(2 downto 0),
				 Pattern_layer4=>layer_reg_pattern(4)(2 downto 0),
				 Pattern_layer5=>layer_reg_pattern(5)(2 downto 0),
				 Pattern_layer6=>layer_reg_pattern(6)(2 downto 0),
				 Pattern_layer7=>layer_reg_pattern(7)(2 downto 0),
				 Pattern_position=> layer_reg_pattern(0)(14 downto 5)
			 );
	layer_reg_pattern(0)(4 downto 3)<="00";
	layer_reg_pattern(1)(14 downto 3)<="000000000000";
	layer_reg_pattern(2)(14 downto 3)<="000000000000";
	layer_reg_pattern(3)(14 downto 3)<="000000000000";
	layer_reg_pattern(4)(14 downto 3)<="000000000000";
	layer_reg_pattern(5)(14 downto 3)<="000000000000";
	layer_reg_pattern(6)(14 downto 3)<="000000000000";
	layer_reg_pattern(7)(14 downto 3)<="000000000000";

end input_FPGA;
