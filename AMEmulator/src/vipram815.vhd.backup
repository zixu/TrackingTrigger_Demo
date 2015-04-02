-- vipram815.vhd
-- updated 5 Feb 2015
--
-- top level VIPRAM design based on SRL road finder.
-- 32 x 32 array = 1024 roads
-- 8 layers @ 15 bits per layer	 
--
-- when load=1 patterns are loaded serially on layer*[2..0]
--    the target row is specified by layer0[14 downto 10]
--    and target col is specified by layer0[10 downto 6]
--
--    one cell is loaded in 32 clock cycles and the loading can occur at full speed

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vipram_package.all;

entity vipram815 is
port(

    clock: in std_logic;
    load: in std_logic;

    mode:    in  std_logic_vector(1 downto 0);
    eoe:     in std_logic;
    layer0:  in std_logic_vector(14 downto 0);
    layer1:  in std_logic_vector(14 downto 0);
    layer2:  in std_logic_vector(14 downto 0);
    layer3:  in std_logic_vector(14 downto 0);
    layer4:  in std_logic_vector(14 downto 0);
    layer5:  in std_logic_vector(14 downto 0);
    layer6:  in std_logic_vector(14 downto 0);
    layer7:  in std_logic_vector(14 downto 0);

    addr:    out std_logic_vector(10 downto 0)  -- valid + row(4 downto 0) + col(4 downto 0)
);
end vipram815;

architecture vipram815_arch of vipram815 is

component road815 is
port(
    clock: in  std_logic;
    load:  in  std_logic;
    d:     in  array_8x15_type;
    mode:  in  std_logic_vector(1 downto 0);
    eoe:   in  std_logic;
    flag:  out std_logic);
end component;

component backend is
port(
    clock: in  std_logic;
    load:  in  std_logic;
    d:     in  array_32x32_type;  -- row(31..0),col(31..0)
    addr:  out std_logic_vector(10 downto 0)); -- valid + rownum(5..0) + colnum(5..0)
end component;

signal load_reg:  std_logic;
signal eoe_reg:   std_logic;
signal mode_reg:  std_logic_vector(1 downto 0);

signal d_reg: array_8x15_type;
signal flag, loadcell: array_32x32_type;

signal target_row, target_col: std_logic_vector(4 downto 0);


begin

-- register inputs

input_proc: process(clock)
begin
    if rising_edge(clock) then
        d_reg(0) <= layer0;
        d_reg(1) <= layer1;
        d_reg(2) <= layer2;
        d_reg(3) <= layer3;
        d_reg(4) <= layer4;
        d_reg(5) <= layer5;
        d_reg(6) <= layer6;
        d_reg(7) <= layer7;
        eoe_reg <= eoe;
		load_reg <= load;
        mode_reg <= mode;
    end if;
end process input_proc;

-- 32 x 32 road array
-- index by (row)(col)

genrow: for r in 31 downto 0 generate
    gencol: for c in 31 downto 0 generate

        loadcell(r)(c) <= '1' when ( load_reg='1' and 
                                     (d_reg(0)(14 downto 10)=std_logic_vector(to_unsigned(r,5))) and 
                                     (d_reg(0)( 9 downto  5)=std_logic_vector(to_unsigned(c,5))) ) else '0';

        road_inst: road815
        port map(
            clock  => clock,
            load   => loadcell(r)(c),
            d      => d_reg,
            mode   => mode_reg,
            eoe    => eoe_reg,
            flag   => flag(r)(c));

    end generate gencol;	  	
end generate genrow;

-- register flag array, compress it, and perform backend sorting...

backend_inst: backend
port map(
    clock => clock,
    load  => eoe_reg,
    d     => flag,
    addr  => addr);

end vipram815_arch;

