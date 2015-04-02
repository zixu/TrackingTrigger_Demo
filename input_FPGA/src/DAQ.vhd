----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/31/2015 10:16:57 AM
-- Design Name: 
-- Module Name: DAQ - Behavioral
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
--library UNISIM;
--use UNISIM.VComponents.all;

use std.textio.all;
use ieee.std_logic_textio.all;

entity DAQ is
	generic( number_data: integer :=1);
	Port ( CLOCK : in STD_LOGIC;
		   EN : in STD_LOGIC;
		   EOE : out STD_LOGIC;-- end of event
		   LAYER0 : out STD_LOGIC_VECTOR (14 downto 0);
		   LAYER1 : out STD_LOGIC_VECTOR (14 downto 0);
		   LAYER2 : out STD_LOGIC_VECTOR (14 downto 0);
		   LAYER3 : out STD_LOGIC_VECTOR (14 downto 0);
		   LAYER4 : out STD_LOGIC_VECTOR (14 downto 0);
		   LAYER5 : out STD_LOGIC_VECTOR (14 downto 0);
		   LAYER6 : out STD_LOGIC_VECTOR (14 downto 0);
		   LAYER7 : out STD_LOGIC_VECTOR (14 downto 0);

		   LAYER0_BX : out STD_LOGIC_VECTOR (2 downto 0);
		   LAYER1_BX : out STD_LOGIC_VECTOR (2 downto 0);
		   LAYER2_BX : out STD_LOGIC_VECTOR (2 downto 0);
		   LAYER3_BX : out STD_LOGIC_VECTOR (2 downto 0);
		   LAYER4_BX : out STD_LOGIC_VECTOR (2 downto 0);
		   LAYER5_BX : out STD_LOGIC_VECTOR (2 downto 0);
		   LAYER6_BX : out STD_LOGIC_VECTOR (2 downto 0);
		   LAYER7_BX : out STD_LOGIC_VECTOR (2 downto 0));

end DAQ;

architecture Behavioral of DAQ is

	-- read data txt file
	--type DataType is array(0 to number_data-1) of std_logic_vector(36*4-1 downto 0);--3*5*8 bit
	type DataType is array(0 to number_data-1) of std_logic_vector(120-1 downto 0);--3*5*8 bit

	impure function InitRomFromFile_data (RomFileName : in string) return DataType is

		FILE RomFile : text open read_mode is RomFileName;
		variable RomFileLine : line;
		variable ROM : DataType;
	begin
		for i in DataType'range loop
			readline (RomFile, RomFileLine);
			hread (RomFileLine, ROM(i));
		end loop;
		return ROM;
	end function;

	--signal Datas : DataType := InitRomFromFile_data("C:\WorkSpace\TrackingTrigger_Aldec\Old\AM_FPGA_Feb2_from_vivado\TestingPackage\scripts\patternbanks_fromZhenHu\rawlist_events_binary_tmp2.txt");
	--signal Datas : DataType := InitRomFromFile_data("C:\WorkSpace\TrackingTrigger_Aldec\zijun_March2-2015\TrackingTrigger_Demo\input_FPGA\src\data\1kevents_bin.txt");
	signal Datas : DataType := InitRomFromFile_data(".\data\1kevents_bin.txt");
	
	type state_type is (rst, wait4go, countup);
	signal state: state_type:= rst;
	signal count_reg: integer range 0 to 1024 :=0;

begin

	proc: process(CLOCK)
	begin
		if rising_edge(CLOCK) then

			case state is 
				when rst =>
					state<= wait4go;
					LAYER0_BX<= "000";
					LAYER1_BX<= "000";
					LAYER2_BX<= "000";
					LAYER3_BX<= "000";
					LAYER4_BX<= "000";
					LAYER5_BX<= "000";
					LAYER6_BX<= "000";
					LAYER7_BX<= "000";
					LAYER0<="000000000000000";
					LAYER1<="000000000000000";
					LAYER2<="000000000000000";
					LAYER3<="000000000000000";
					LAYER4<="000000000000000";
					LAYER5<="000000000000000";
					LAYER6<="000000000000000";
					LAYER7<="000000000000000";
					EOE<='0';
				when wait4go=>
					if(EN='1')then state <=countup;
					else state <= wait4go;
					end if;
					LAYER0_BX<= "000";
					LAYER1_BX<= "000";
					LAYER2_BX<= "000";
					LAYER3_BX<= "000";
					LAYER4_BX<= "000";
					LAYER5_BX<= "000";
					LAYER6_BX<= "000";
					LAYER7_BX<= "000";
					LAYER0<="000000000000000";
					LAYER1<="000000000000000";
					LAYER2<="000000000000000";
					LAYER3<="000000000000000";
					LAYER4<="000000000000000";
					LAYER5<="000000000000000";
					LAYER6<="000000000000000";
					LAYER7<="000000000000000";
					EOE<='0';
				when countup =>
					if(count_reg< number_data) then

						LAYER7_BX<="000";--Datas(count_reg)( 3*0+120)&Datas(count_reg)(1+120 )&Datas(count_reg)(3*1-1+120 );
						LAYER6_BX<="000";--Datas(count_reg)( 3*1+120)&Datas(count_reg)(1+120 )&Datas(count_reg)(3*2-1+120 );
						LAYER5_BX<="000";--Datas(count_reg)( 3*2+120)&Datas(count_reg)(1+120 )&Datas(count_reg)(3*3-1+120 );
						LAYER4_BX<="000";--Datas(count_reg)( 3*3+120)&Datas(count_reg)(1+120 )&Datas(count_reg)(3*4-1+120 );
						LAYER3_BX<="000";--Datas(count_reg)( 3*4+120)&Datas(count_reg)(1+120 )&Datas(count_reg)(3*5-1+120 );
						LAYER2_BX<="000";--Datas(count_reg)( 3*5+120)&Datas(count_reg)(1+120 )&Datas(count_reg)(3*6-1+120 );
						LAYER1_BX<="000";--Datas(count_reg)( 3*6+120)&Datas(count_reg)(1+120 )&Datas(count_reg)(3*7-1+120 );
						LAYER0_BX<="000";--Datas(count_reg)( 3*7+120)&Datas(count_reg)(1+120 )&Datas(count_reg)(3*8-1+120 );

						LAYER7<=Datas(count_reg)(15*8-1 downto 15*7);
						LAYER6<=Datas(count_reg)(15*7-1 downto 15*6);
						LAYER5<=Datas(count_reg)(15*6-1 downto 15*5);
						LAYER4<=Datas(count_reg)(15*5-1 downto 15*4);
						LAYER3<=Datas(count_reg)(15*4-1 downto 15*3);
						LAYER2<=Datas(count_reg)(15*3-1 downto 15*2);
						LAYER1<=Datas(count_reg)(15*2-1 downto 15*1);
						LAYER0<=Datas(count_reg)(15*1-1 downto 15*0);

						--if (Datas(count_reg)=X"000000000000000000000000000000") then
						--	EOE<='1';
						--else 
						--	EOE<='0';
						--end if;
						

						count_reg<=count_reg+1;
					else
						count_reg<=0;
						state<=wait4go;
						LAYER0_BX<= "000";
						LAYER1_BX<= "000";
						LAYER2_BX<= "000";
						LAYER3_BX<= "000";
						LAYER4_BX<= "000";
						LAYER5_BX<= "000";
						LAYER6_BX<= "000";
						LAYER7_BX<= "000";
						LAYER0<="000000000000000";
						LAYER1<="000000000000000";
						LAYER2<="000000000000000";
						LAYER3<="000000000000000";
						LAYER4<="000000000000000";
						LAYER5<="000000000000000";
						LAYER6<="000000000000000";
						LAYER7<="000000000000000";
						EOE<='1';

					end if;
			end case;
		end if;

	end process proc;


end Behavioral;
