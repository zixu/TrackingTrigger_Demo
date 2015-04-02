library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity input_fpga_tb is
	-- Generic declarations of the tested unit
		generic(
		clk_per_sysclk: time :=20 ns; --50MHz
		number_patterns : INTEGER := 1;
		number_data : INTEGER := 20 );
end input_fpga_tb;

architecture TB_ARCHITECTURE of input_fpga_tb is
	-- Component declaration of the tested unit
	component input_fpga
		generic(
		number_patterns : INTEGER ;
		number_data : INTEGER );
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
		LAYER0 : out STD_LOGIC_VECTOR(14 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLOCK : STD_LOGIC:='1';
	signal EN_pattern : STD_LOGIC;
	signal EN_DAQ : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal LOAD_pattern : STD_LOGIC;
	signal EOE_DAQ : STD_LOGIC;
	signal LAYER7_BX : STD_LOGIC_VECTOR(2 downto 0);
	signal LAYER6_BX : STD_LOGIC_VECTOR(2 downto 0);
	signal LAYER5_BX : STD_LOGIC_VECTOR(2 downto 0);
	signal LAYER4_BX : STD_LOGIC_VECTOR(2 downto 0);
	signal LAYER3_BX : STD_LOGIC_VECTOR(2 downto 0);
	signal LAYER2_BX : STD_LOGIC_VECTOR(2 downto 0);
	signal LAYER1_BX : STD_LOGIC_VECTOR(2 downto 0);
	signal LAYER0_BX : STD_LOGIC_VECTOR(2 downto 0);
	signal LAYER7 : STD_LOGIC_VECTOR(14 downto 0);
	signal LAYER6 : STD_LOGIC_VECTOR(14 downto 0);
	signal LAYER5 : STD_LOGIC_VECTOR(14 downto 0);
	signal LAYER4 : STD_LOGIC_VECTOR(14 downto 0);
	signal LAYER3 : STD_LOGIC_VECTOR(14 downto 0);
	signal LAYER2 : STD_LOGIC_VECTOR(14 downto 0);
	signal LAYER1 : STD_LOGIC_VECTOR(14 downto 0);
	signal LAYER0 : STD_LOGIC_VECTOR(14 downto 0);

begin

	-- Unit Under Test port map
	UUT : input_fpga
		generic map (
			number_patterns => number_patterns,
			number_data => number_data
		)

		port map (
			CLOCK => CLOCK,
			EN_pattern => EN_pattern,
			EN_DAQ => EN_DAQ,
			LOAD_pattern => LOAD_pattern,
			EOE_DAQ => EOE_DAQ,
			LAYER7_BX => LAYER7_BX,
			LAYER6_BX => LAYER6_BX,
			LAYER5_BX => LAYER5_BX,
			LAYER4_BX => LAYER4_BX,
			LAYER3_BX => LAYER3_BX,
			LAYER2_BX => LAYER2_BX,
			LAYER1_BX => LAYER1_BX,
			LAYER0_BX => LAYER0_BX,
			LAYER7 => LAYER7,
			LAYER6 => LAYER6,
			LAYER5 => LAYER5,
			LAYER4 => LAYER4,
			LAYER3 => LAYER3,
			LAYER2 => LAYER2,
			LAYER1 => LAYER1,
			LAYER0 => LAYER0
		);

	-- Add your stimulus here ...
	process
	begin 
		wait for clk_per_sysclk/2;
		CLOCK<= not CLOCK;
	end process;

	process 
	begin
		EN_pattern<='0';
		EN_DAQ<='0';

		wait for 100 ns;
		EN_pattern<='1';
		wait for clk_per_sysclk;
		EN_pattern<='0';

		wait for clk_per_sysclk*(number_patterns*32+10);
		EN_DAQ<='1';
		wait for clk_per_sysclk;
		EN_DAQ<='0';

		wait;
	end process;


end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_input_fpga of input_fpga_tb is
	for TB_ARCHITECTURE
		for UUT : input_fpga
			use entity work.input_fpga(input_fpga);
		end for;
	end for;
end TESTBENCH_FOR_input_fpga;

