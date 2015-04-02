----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2015 07:23:41 AM
-- Design Name: 
-- Module Name: Bank_load - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

use std.textio.all;
use ieee.std_logic_textio.all;

entity Bank_load is
	generic( number_patterns: integer );
    Port ( CLOCK : in STD_LOGIC;
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
end Bank_load;

architecture Behavioral of Bank_load is

		-- read pattern txt file
	--type PatternType is array(0 to number_pattern_per_column*pattern_cols-1) of std_logic_vector(pattern_length*4-1 downto 0);
	type PatternType is array(0 to number_patterns-1) of std_logic_vector(779 downto 0); --768+12. the last 12 bit is for postion

	impure function InitRomFromFile_pattern (RomFileName : in string) return PatternType is

		FILE RomFile : text open read_mode is RomFileName;
		variable RomFileLine : line;
		variable ROM : PatternType;
	begin
		for i in PatternType'range loop
			readline (RomFile, RomFileLine);
			hread (RomFileLine, ROM(i));
		end loop;
		return ROM;
	end function;

	--signal Patterns : PatternType := InitRomFromFile_pattern("C:\WorkSpace\TrackingTrigger_Aldec\Old\AM_FPGA_Feb2_from_vivado\TestingPackage\scripts\patternbanks_fromZhenHu\rawlist_patterns_binary_tmp2.txt");
	signal Patterns : PatternType := InitRomFromFile_pattern(".\data\1kpatterns_bin.txt");  
	--signal Patterns : PatternType := InitRomFromFile_pattern("C:\WorkSpace\TrackingTrigger_Aldec\zijun_March2-2015\TrackingTrigger_Demo\input_FPGA\src\data\1kpatterns_bin.txt");
	type array_3x32_type is array(2 downto 0) of std_logic_vector(31 downto 0);
	type array_8x3_32_type is array(7 downto 0) of array_3x32_type;

	type state_type is (rst, wait4go, countup);
	signal state: state_type:= rst;
	signal count_reg: integer range 0 to 16384 :=0;
	signal ipattern: integer range 0 to 31 :=0;

begin

	proc: process(CLOCK)
	begin
		if rising_edge(CLOCK) then
		--if falling_edge(CLOCK) then

			case state is 
				when rst =>
					state<= wait4go;
					LOAD<='0';
					Pattern_position<="0000000000";
					Pattern_layer7<="000";
					Pattern_layer6<="000";
					Pattern_layer5<="000";
					Pattern_layer4<="000";
					Pattern_layer3<="000";
					Pattern_layer2<="000";
					Pattern_layer1<="000";
					Pattern_layer0<="000";


				when wait4go=>
					if(EN='1')then state <=countup;
					else state <= wait4go;
					end if;
					LOAD<='0';
					Pattern_position<="0000000000";
					Pattern_layer7<="000";
					Pattern_layer6<="000";
					Pattern_layer5<="000";
					Pattern_layer4<="000";
					Pattern_layer3<="000";
					Pattern_layer2<="000";
					Pattern_layer1<="000";
					Pattern_layer0<="000";

				when countup =>
					if(count_reg< number_patterns) then
						LOAD<='1';
						--Pattern_position<="0101010000";--row 01010 10; col 10000 16
						Pattern_position <=Patterns(count_reg)(777 downto 768);

						Pattern_layer7(2)<=Patterns(count_reg)( 767-ipattern);
						Pattern_layer7(1)<=Patterns(count_reg)( 735-ipattern);
						Pattern_layer7(0)<=Patterns(count_reg)( 703-ipattern);
						Pattern_layer6(2)<=Patterns(count_reg)( 671-ipattern);
						Pattern_layer6(1)<=Patterns(count_reg)( 639-ipattern);
						Pattern_layer6(0)<=Patterns(count_reg)( 607-ipattern);
						Pattern_layer5(2)<=Patterns(count_reg)( 575-ipattern);
						Pattern_layer5(1)<=Patterns(count_reg)( 543-ipattern);
						Pattern_layer5(0)<=Patterns(count_reg)( 511-ipattern);
						Pattern_layer4(2)<=Patterns(count_reg)( 479-ipattern);
						Pattern_layer4(1)<=Patterns(count_reg)( 447-ipattern);
						Pattern_layer4(0)<=Patterns(count_reg)( 415-ipattern);
						Pattern_layer3(2)<=Patterns(count_reg)( 383-ipattern);
						Pattern_layer3(1)<=Patterns(count_reg)( 351-ipattern);
						Pattern_layer3(0)<=Patterns(count_reg)( 319-ipattern);
						Pattern_layer2(2)<=Patterns(count_reg)( 287-ipattern);
						Pattern_layer2(1)<=Patterns(count_reg)( 255-ipattern);
						Pattern_layer2(0)<=Patterns(count_reg)( 223-ipattern);
						Pattern_layer1(2)<=Patterns(count_reg)( 191-ipattern);
						Pattern_layer1(1)<=Patterns(count_reg)( 159-ipattern);
						Pattern_layer1(0)<=Patterns(count_reg)( 127-ipattern);
						Pattern_layer0(2)<=Patterns(count_reg)(  95-ipattern);
						Pattern_layer0(1)<=Patterns(count_reg)(  63-ipattern);
						Pattern_layer0(0)<=Patterns(count_reg)(  31-ipattern);


						if( ipattern=31) then
							ipattern<=0; 
							count_reg<=count_reg+1;
						else
							ipattern<= ipattern+1;
						end if;
					else
						count_reg<=0;
						state<=wait4go;
						LOAD<='0';
						Pattern_position<="0000000000";
						Pattern_layer7<="000";
						Pattern_layer6<="000";
						Pattern_layer5<="000";
						Pattern_layer4<="000";
						Pattern_layer3<="000";
						Pattern_layer2<="000";
						Pattern_layer1<="000";
						Pattern_layer0<="000";

					end if;
			end case;
		end if;

	end process proc;

end Behavioral;
