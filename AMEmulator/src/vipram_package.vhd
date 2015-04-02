library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package vipram_package is

    type array_32x11_type is array(31 downto 0) of std_logic_vector(10 downto 0);
    type array_16x11_type is array(15 downto 0) of std_logic_vector(10 downto 0);
    type array_8x11_type  is array(7  downto 0) of std_logic_vector(10 downto 0);
    type array_4x11_type  is array(3  downto 0) of std_logic_vector(10 downto 0);
    type array_2x11_type  is array(1  downto 0) of std_logic_vector(10 downto 0);

    type array_32x32_type is array(31 downto 0) of std_logic_vector(31 downto 0);

    type array_8x15_type  is array(7 downto 0) of std_logic_vector(14 downto 0);

    constant MISS0 : std_logic_vector(1 downto 0) := "00";
    constant MISS1 : std_logic_vector(1 downto 0) := "01";
    constant MISS2 : std_logic_vector(1 downto 0) := "11";

end package;


