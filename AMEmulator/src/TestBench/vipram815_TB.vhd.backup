library AMEmulator;
use AMEmulator.vipram_package.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	-- Add your library and packages declaration here ...

entity vipram815_tb is
end vipram815_tb;

architecture TB_ARCHITECTURE of vipram815_tb is

	component vipram815 is
		port(
			    clock:  in  std_logic;
			    load:   in  std_logic;
			    mode:   in  std_logic_vector(1 downto 0);
			    eoe:    in  std_logic;
			    layer0: in  std_logic_vector(14 downto 0);
			    layer1: in  std_logic_vector(14 downto 0);
			    layer2: in  std_logic_vector(14 downto 0);
			    layer3: in  std_logic_vector(14 downto 0);
			    layer4: in  std_logic_vector(14 downto 0);
			    layer5: in  std_logic_vector(14 downto 0);
			    layer6: in  std_logic_vector(14 downto 0);
			    layer7: in  std_logic_vector(14 downto 0);
			    addr:   out std_logic_vector(10 downto 0));
	end component;

	signal clock: std_logic := '0';
	signal eoe:   std_logic := '0';
	signal load:  std_logic := '0';
	signal layer: array_8x15_type;
	signal addr: std_logic_vector(10 downto 0):="00000000000";

	type array_3x32_type is array(2 downto 0) of std_logic_vector(31 downto 0);
	type array_8x3_32_type is array(7 downto 0) of array_3x32_type;
	signal pattern: array_8x3_32_type;


begin

	clock <= not clock after 5ns;  -- 100MHz

	pattern(7) <= (X"00000001" , X"00000001", X"00000080"); -- 00000 00000 00111
	pattern(6) <= (X"00000001" , X"00000001", X"00000040"); -- 00000 00000 00110
	pattern(5) <= (X"00000001" , X"00000001", X"00000020"); -- 00000 00000 00101
	pattern(4) <= (X"00000001" , X"00000001", X"00000010"); -- 00000 00000 00100 
	pattern(3) <= (X"00000001" , X"00000001", X"00000008"); -- 00000 00000 00011
	pattern(2) <= (X"00000001" , X"00000001", X"00000004"); -- 00000 00000 00010
	pattern(1) <= (X"00000001" , X"00000001", X"00000002"); -- 00000 00000 00001
	pattern(0) <= (X"00000001" , X"00000001", X"00000001"); -- 00000 00000 00000


	transactor: process
	begin

		for i in 7 downto 0 loop
			layer(i) <= (others=>'0');
		end loop;

		wait for 100ns;

		wait until falling_edge(clock);
		load <= '1';

		--try 1 pattern
		layer(0)(14 downto 10) <= "01010"; -- row 10
		layer(0)( 9 downto  5) <= "10000"; -- col 16

		for b in 31 downto 0 loop
			for l in 7 downto 0 loop
				layer(l)(2) <= pattern(l)(2)(b);
				layer(l)(1) <= pattern(l)(1)(b);
				layer(l)(0) <= pattern(l)(0)(b);
			end loop;
			wait until falling_edge(clock);        
		end loop;

		----try all the 1K patterns
		--for x in 31 downto 0 loop
		--	for y in 31 downto 0 loop

		--		layer(0)(14 downto 10) <= std_logic_vector(to_unsigned(x,5)); -- row x
		--		layer(0)( 9 downto  5) <= std_logic_vector(to_unsigned(y,5)); -- col y 

		--		for b in 31 downto 0 loop
		--			for l in 7 downto 0 loop
		--				layer(l)(2) <= '1';
		--				layer(l)(1) <= '1';
		--				layer(l)(0) <= '1';
		--			end loop;
		--			wait until falling_edge(clock);        
		--		end loop;
		--	end loop;
		--end loop;



		-- clear data busses, take us out of load mode
		load <= '0';
		for i in 7 downto 0 loop
			layer(i) <= (others=>'0');
		end loop;

		wait for 200ns;

		wait until falling_edge(clock);

		--1st event
		layer(7) <= "000000000000111";
		layer(6) <= "000000000000110";
		layer(5) <= "000000000000101";
		layer(4) <= "000000000000100";
		layer(3) <= "000000000000011";
		layer(2) <= "000000000000010";
		layer(1) <= "000000000000001";
		layer(0) <= "000000000000000";

		--wait until falling_edge(clock);

		--for i in 7 downto 0 loop
		--	layer(i) <= (others=>'0');
		--end loop;

		--wait for 500ns;

		wait until falling_edge(clock);
		eoe <= '1';
		for i in 7 downto 0 loop
			layer(i) <= (others=>'0');
		end loop;


		wait until falling_edge(clock);
		eoe <= '0';    

		----2nd event
		--layer(7) <= "000000000000111";
		--layer(6) <= "000000000000110";
		--layer(5) <= "000000000000101";
		--layer(4) <= "000000000000100";
		--layer(3) <= "000000000000011";
		--layer(2) <= "000000000000010";
		--layer(1) <= "000000000000001";
		--layer(0) <= "000000000000000";

		--wait until falling_edge(clock);

		--for i in 7 downto 0 loop
		--	layer(i) <= (others=>'0');
		--end loop;

		--wait for 500ns;

		--wait until falling_edge(clock);
		--eoe <= '1';
		--wait until falling_edge(clock);
		--eoe <= '0';    

		----3rd event
		--layer(7) <= "001000000000111";
		--layer(6) <= "001000000000110";
		--layer(5) <= "001000000000101";
		--layer(4) <= "001000000000100";
		--layer(3) <= "001000000000011";
		--layer(2) <= "001000000000010";
		--layer(1) <= "001000000000001";
		--layer(0) <= "001000000000000";

		--wait until falling_edge(clock);

		--for i in 7 downto 0 loop
		--	layer(i) <= (others=>'0');
		--end loop;

		--wait for 500ns;

		--wait until falling_edge(clock);
		--eoe <= '1';
		--wait until falling_edge(clock);
		--eoe <= '0';    



		wait;
	end process transactor;


	DUT: vipram815 
	port map(
			clock => clock,
			load  => load,
			mode  => MISS0,
			eoe   => eoe,

			layer0 => layer(0),
			layer1 => layer(1),
			layer2 => layer(2),
			layer3 => layer(3),
			layer4 => layer(4),
			layer5 => layer(5),
			layer6 => layer(6),
			layer7 => layer(7),
			addr => addr
		);

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_vipram815 of vipram815_tb is
	for TB_ARCHITECTURE
		for DUT : vipram815
			use entity work.vipram815(vipram815_arch);
		end for;
	end for;
end TESTBENCH_FOR_vipram815;

