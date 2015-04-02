-- smoosh32.vhd
-- Jamieson Olsen <jamieson@fnal.gov>
-- 29 January 2015
--
-- compress 32x32 array to eliminate columns with zero hits
-- clock out column vectors one at a time and provide a column index
--
-- The array    3 2 1 0 
--            3 . . . .
--            2 . 1 . .
--            1 1 . . .
--            0 . 1 . .
--
-- would be reported as ["0010",3] ["0101",2]

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vipram_package.all;

entity smoosh is
port(
    clock: in  std_logic;
    load:  in  std_logic;
    d:     in  array_32x32_type;  -- d(row 31..0)(col 31..0)
    cvec:  out std_logic_vector(31 downto 0);
    cnum:  out std_logic_vector(4 downto 0));
end smoosh;

architecture smoosh_arch of smoosh is

    signal d_reg: array_32x32_type;
    signal co, cooh, co_reg, cvec_reg: std_logic_vector(31 downto 0);
    signal cnum_reg: std_logic_vector(4 downto 0);

begin

-- for each input column, generate an OR 

cogen: for i in 31 downto 0 generate
    co(i) <= d(31)(i) or d(30)(i) or d(29)(i) or d(28)(i) or 
             d(27)(i) or d(26)(i) or d(25)(i) or d(24)(i) or 
             d(23)(i) or d(22)(i) or d(21)(i) or d(20)(i) or 
             d(19)(i) or d(18)(i) or d(17)(i) or d(16)(i) or 
             d(15)(i) or d(14)(i) or d(13)(i) or d(12)(i) or 
             d(11)(i) or d(10)(i) or d( 9)(i) or d( 8)(i) or 
             d( 7)(i) or d( 6)(i) or d( 5)(i) or d( 4)(i) or 
             d( 3)(i) or d( 2)(i) or d( 1)(i) or d( 0)(i);
end generate cogen;

-- one hot priority encoder for co_reg

    cooh( 0) <= '1' when std_match(co_reg, "00000000000000000000000000000001") else '0';
    cooh( 1) <= '1' when std_match(co_reg, "0000000000000000000000000000001-") else '0';
    cooh( 2) <= '1' when std_match(co_reg, "000000000000000000000000000001--") else '0';
    cooh( 3) <= '1' when std_match(co_reg, "00000000000000000000000000001---") else '0';
    cooh( 4) <= '1' when std_match(co_reg, "0000000000000000000000000001----") else '0';
    cooh( 5) <= '1' when std_match(co_reg, "000000000000000000000000001-----") else '0';
    cooh( 6) <= '1' when std_match(co_reg, "00000000000000000000000001------") else '0';
    cooh( 7) <= '1' when std_match(co_reg, "0000000000000000000000001-------") else '0';
    cooh( 8) <= '1' when std_match(co_reg, "000000000000000000000001--------") else '0';
    cooh( 9) <= '1' when std_match(co_reg, "00000000000000000000001---------") else '0';
    cooh(10) <= '1' when std_match(co_reg, "0000000000000000000001----------") else '0';
    cooh(11) <= '1' when std_match(co_reg, "000000000000000000001-----------") else '0';
    cooh(12) <= '1' when std_match(co_reg, "00000000000000000001------------") else '0';
    cooh(13) <= '1' when std_match(co_reg, "0000000000000000001-------------") else '0';
    cooh(14) <= '1' when std_match(co_reg, "000000000000000001--------------") else '0';
    cooh(15) <= '1' when std_match(co_reg, "00000000000000001---------------") else '0';
    cooh(16) <= '1' when std_match(co_reg, "0000000000000001----------------") else '0';
    cooh(17) <= '1' when std_match(co_reg, "000000000000001-----------------") else '0';
    cooh(18) <= '1' when std_match(co_reg, "00000000000001------------------") else '0';
    cooh(19) <= '1' when std_match(co_reg, "0000000000001-------------------") else '0';
    cooh(20) <= '1' when std_match(co_reg, "000000000001--------------------") else '0';
    cooh(21) <= '1' when std_match(co_reg, "00000000001---------------------") else '0';
    cooh(22) <= '1' when std_match(co_reg, "0000000001----------------------") else '0';
    cooh(23) <= '1' when std_match(co_reg, "000000001-----------------------") else '0';
    cooh(24) <= '1' when std_match(co_reg, "00000001------------------------") else '0';
    cooh(25) <= '1' when std_match(co_reg, "0000001-------------------------") else '0';
    cooh(26) <= '1' when std_match(co_reg, "000001--------------------------") else '0';
    cooh(27) <= '1' when std_match(co_reg, "00001---------------------------") else '0';
    cooh(28) <= '1' when std_match(co_reg, "0001----------------------------") else '0';
    cooh(29) <= '1' when std_match(co_reg, "001-----------------------------") else '0';
    cooh(30) <= '1' when std_match(co_reg, "01------------------------------") else '0';
    cooh(31) <= '1' when std_match(co_reg, "1-------------------------------") else '0';

-- "peel away" one hot priority encoder

in_proc: process(clock)
begin
    if rising_edge(clock) then
        if (load='1') then
            d_reg  <= d;
            co_reg <= co;
        else
            co_reg <= co_reg xor cooh;
        end if;
    end if;
end process in_proc;


out_proc: process(clock)
begin
    if rising_edge(clock) then
        if (load='1') then
            cvec_reg   <= X"00000000";
            cnum_reg <= "00000";
        else
            if (cooh=X"00000000") then
                cvec_reg   <= X"00000000";
                cnum_reg <= "00000";
            end if;

            for i in 31 downto 0 loop
                if (cooh(i)='1') then 
                    cvec_reg <= d_reg(31)(i) & d_reg(30)(i) & d_reg(29)(i) & d_reg(28)(i) & 
                                d_reg(27)(i) & d_reg(26)(i) & d_reg(25)(i) & d_reg(24)(i) & 
                                d_reg(23)(i) & d_reg(22)(i) & d_reg(21)(i) & d_reg(20)(i) & 
                                d_reg(19)(i) & d_reg(18)(i) & d_reg(17)(i) & d_reg(16)(i) & 
                                d_reg(15)(i) & d_reg(14)(i) & d_reg(13)(i) & d_reg(12)(i) & 
                                d_reg(11)(i) & d_reg(10)(i) & d_reg( 9)(i) & d_reg( 8)(i) & 
                                d_reg( 7)(i) & d_reg( 6)(i) & d_reg( 5)(i) & d_reg( 4)(i) & 
                                d_reg( 3)(i) & d_reg( 2)(i) & d_reg( 1)(i) & d_reg( 0)(i);
                end if;

                if (cooh(i)='1') then 
                    cnum_reg <= std_logic_vector(to_unsigned(i,5));
                end if;
            end loop;

        end if;
    end if;
end process out_proc;

cvec <= cvec_reg;

cnum <= cnum_reg;

end smoosh_arch;

