library AMEmulator;
use AMEmulator.vipram_package.all;
library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
library unisim;
use unisim.VCOMPONENTS.all;

-- Add your library and packages declaration here ...

entity backend_tb is
end backend_tb;

architecture TB_ARCHITECTURE of backend_tb is
	-- Component declaration of the tested unit
	component backend
		port(
			clock : in STD_LOGIC;
			load : in STD_LOGIC;
			d : in array_32x32_type;
			addr : out STD_LOGIC_VECTOR(10 downto 0) );
	end component;
	
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clock : STD_LOGIC:='0';
	signal load : STD_LOGIC:='0';		  
	
	signal road: array_32x32_type;	
	
	--	signal d : array_32x32_type;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal addr : STD_LOGIC_VECTOR(10 downto 0);
	
	-- Add your code here ...
	
begin
	
	clock <= not clock after 5ns;  -- 100MHz
	transactor: process
	begin
		
		-- initialize the hit array...
		
		for i in 31 downto 0 loop
			road(i) <= X"00000000";
		end loop;
		
		wait for 40ns;
		
		wait until falling_edge(clock);
		
		-- road(row)(col)   
		
		--road(31)(31) <= '1';
		--road( 4)(28) <= '1';
		--road( 7)(24) <= '1';
		--road( 0)(24) <= '1';
		--road( 0)(23) <= '1';
		--road(14)(12) <= '1';
		--road( 1)( 8) <= '1';
		--road(25)( 6) <= '1';
		--road( 5)( 3) <= '1';
		for i in 31 downto 0 loop
			road(i) <= X"ffffffff";
		end loop;
				
		wait until falling_edge(clock);
		load <= '1';
		
		wait until falling_edge(clock);
		load <= '0';
		
		wait until falling_edge(clock);
		for i in 31 downto 0 loop
			road(i) <= X"00000000";
		end loop;
		
		wait;
	end process transactor;
	
	-- Unit Under Test port map
	UUT : backend
	port map (
		clock => clock,
		load => load,
		d => road,
		--d => d,
		addr => addr
		);
	
	-- Add your stimulus here ...
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_backend of backend_tb is
	for TB_ARCHITECTURE
		for UUT : backend
			use entity work.backend(backend_arch);
		end for;
	end for;
end TESTBENCH_FOR_backend;

