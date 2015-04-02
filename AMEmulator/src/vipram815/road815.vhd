-- road815.vhd
-- 4 Feb 2015
--
-- pattern shifted in on the 3 LSb of each d bus when load=1, 32 clocks needed

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vipram_package.all;

entity road815 is
port(
    clock: in  std_logic;
    load:  in  std_logic;
    d:     in  array_8x15_type;
    mode:  in  std_logic_vector(1 downto 0);
    eoe:   in  std_logic;
    flag:  out std_logic);
end road815;

architecture road815_arch of road815 is

    component layer
    port(
        clock: in  std_logic;
        load:  in  std_logic;
        eoe:   in  std_logic;
        d:     in  std_logic_vector(14 downto 0);
        match: out std_logic);
    end component;

    signal match: std_logic_vector(7 downto 0);
    signal missing0, missing1a, missing1b, missing2a, missing2b, roadflag, flag_reg: std_logic;

begin

layergen: for i in 7 downto 0 generate

    layer_inst: layer
    port map(
        clock  => clock,
        load   => load,
        eoe    => eoe,
        d      => d(i),
        match  => match(i));

end generate layergen;

missing0 <= '1' when (match="11111111") else '0';

missing1a <= '1' when (match(3 downto 0)="1110") else 
             '1' when (match(3 downto 0)="1101") else 
             '1' when (match(3 downto 0)="1011") else 
             '1' when (match(3 downto 0)="0111") else 
             '0';

missing1b <= '1' when (match(7 downto 4)="1110") else 
             '1' when (match(7 downto 4)="1101") else 
             '1' when (match(7 downto 4)="1011") else 
             '1' when (match(7 downto 4)="0111") else 
             '0';

missing2a <= '1' when (match(3 downto 0)="1100") else 
             '1' when (match(3 downto 0)="1001") else 
             '1' when (match(3 downto 0)="0011") else 
             '1' when (match(3 downto 0)="0110") else 
             '0';

missing2b <= '1' when (match(7 downto 4)="1100") else 
             '1' when (match(7 downto 4)="1001") else 
             '1' when (match(7 downto 4)="0011") else 
             '1' when (match(7 downto 4)="0110") else 
             '0';

roadflag <= '1' when (mode=MISS0 and missing0='1') else

            '1' when (mode=MISS1 and missing0='1') else
            '1' when (mode=MISS1 and missing1a='1') else
            '1' when (mode=MISS1 and missing1b='1') else

            '1' when (mode=MISS2 and missing0='1') else
            '1' when (mode=MISS2 and missing2a='1') else
            '1' when (mode=MISS2 and missing2b='1') else
            '1' when (mode=MISS2 and missing1a='1' and missing1b='1') else

            '0';

outproc: process(clock)
begin
    if rising_edge(clock) then
        flag_reg <= roadflag;
    end if;
end process outproc;

flag <= flag_reg;

end road815_arch;

