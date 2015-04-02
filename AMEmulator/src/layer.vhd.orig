-- layer.vhd
-- Jamieson Olsen <jamieson@fnal.gov>
-- 13 June 2014
--
-- SR based 15 bit layer checker, sync serial load, async operation.
-- see Xilinx UG747 for info on how the 32 bit shift register LUT works.
-- The match pattern is fully specified (and includes don't care bits) and is
-- loaded on serially on d(2..0) when load=1; 32 clocks required.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

use work.vipram_package.all;

entity layer is
port(
    clock: in  std_logic;
    load:  in  std_logic;
    d:     in  std_logic_vector(14 downto 0);
    eoe:   in  std_logic;
    match: out std_logic);
end layer;

architecture layer_arch of layer is

    signal q0, q1, q2: std_logic;
    signal match_reg: std_logic;

begin

SRL0 : SRLC32E
generic map (
   INIT => X"00000000")
port map (
   Q   => q0,
   Q31 => open,
   A   => d(4 downto 0),
   CE  => load,  
   CLK => clock,
   D   => d(0)    
);

SRL1 : SRLC32E
generic map (
   INIT => X"00000000")
port map (
   Q   => q1,
   Q31 => open,
   A   => d(9 downto 5),
   CE  => load,  
   CLK => clock,
   D   => d(1)    
);

SRL2 : SRLC32E
generic map (
   INIT => X"00000000")
port map (
   Q   => q2,
   Q31 => open,
   A   => d(14 downto 10),
   CE  => load,  
   CLK => clock,
   D   => d(2)    
);

matchproc: process(clock)
begin
    if rising_edge(clock) then
        if (eoe='1') then
            match_reg <= '0';
        else
            match_reg <= match_reg or (q0 and q1 and q2);
        end if;
    end if;
end process matchproc;

match <= match_reg;

end layer_arch;

