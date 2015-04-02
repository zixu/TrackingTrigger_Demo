-- backend.vhd
-- Jamieson Olsen <jamieson@fnal.gov>
-- 29 January 2015
--
-- counters and tree of sort nodes.  Designed for 32x32 array.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

use work.vipram_package.all;

entity backend is
port(
    clock: in  std_logic;
    load:  in  std_logic;
    d:     in  array_32x32_type;  -- row(31..0),col(31..0)
    addr:  out std_logic_vector(10 downto 0)); -- valid + rownum(5..0) + colnum(5..0)
end backend;

architecture backend_arch of backend is

    component smoosh
    port(
        clock: in  std_logic;
        load:  in  std_logic;
        d:     in  array_32x32_type;
        cvec:  out std_logic_vector(31 downto 0);
        cnum:  out std_logic_vector(4 downto 0));
    end component;    

    component node
    port(
        clock: in  std_logic;
        reset: in  std_logic;
        a,b:   in  std_logic_vector(10 downto 0);  -- MSb is valid
        c:     out std_logic_vector(10 downto 0));
    end component;

    signal cvec: std_logic_vector(31 downto 0);
    signal cnum: std_logic_vector(4 downto 0);

    signal hit:        array_32x11_type;
    signal layer1_out: array_16x11_type;
    signal layer2_out: array_8x11_type;
    signal layer3_out: array_4x11_type;
    signal layer4_out: array_2x11_type;

begin

    smoosh_inst: smoosh -- zero suppress columns
    port map(
        clock  => clock,
        load   => load,
        d      => d,
        cvec   => cvec,
        cnum   => cnum);

    -- convert cvec, cnum into array of hit addresses
    -- hit = valid + rownum(4..0) + colnum(4..0)

    hitgen: for i in 31 downto 0 generate  
        hit(i)(10) <= cvec(i);  -- valid
        hit(i)(9 downto 5) <= std_logic_vector( to_unsigned(i,5) );  -- row number (static)
        hit(i)(4 downto 0) <= cnum;  -- column number
    end generate;

    -- now begin the array of 31 sort nodes.  OK to use the load signal as the reset to nodes and force all FIFOs to empty.

    layer1_gen: for i in 15 downto 0 generate
        node1_inst: node port map( clock => clock, reset => load, a => hit(2*i), b => hit((2*i)+1), c => layer1_out(i) );
    end generate layer1_gen;

    layer2_gen: for i in 7 downto 0 generate
        node2_inst: node port map( clock => clock, reset => load, a => layer1_out(2*i), b => layer1_out((2*i)+1), c => layer2_out(i) );
    end generate layer2_gen;

    layer3_gen: for i in 3 downto 0 generate
        node3_inst: node port map( clock => clock, reset => load, a => layer2_out(2*i), b => layer2_out((2*i)+1), c => layer3_out(i) );
    end generate layer3_gen;

    node4_inst0: node port map( clock => clock, reset => load, a => layer3_out(0), b => layer3_out(1), c => layer4_out(0) );
    node4_inst1: node port map( clock => clock, reset => load, a => layer3_out(2), b => layer3_out(3), c => layer4_out(1) );

    node5_inst: node port map( clock => clock, reset => load, a => layer4_out(0), b => layer4_out(1), c => addr );

end backend_arch;

