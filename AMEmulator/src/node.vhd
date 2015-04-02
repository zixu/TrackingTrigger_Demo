-- node.vhd
-- Jamieson Olsen <jamieson@fnal.gov>
-- 27 January 2015
--
-- sort node for pipelined road flag serializer
-- fixed FIFO depth of 32.  Full and Empty FIFO flags are implemented and 
-- checked to insure these pointers are not corrupted by writing to a 
-- full FIFO or reading from an empty FIFO.

-- A  B  Operation
-- -  -  ---------------------------------
-- 0  0  read from FIFO, if non-empty
-- 0  1  pass B to output
-- 1  0  pass A to output
-- 1  1  pass A to output, store B in FIFO

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity node is
port(
    clock: in  std_logic;
    reset: in  std_logic;
    a,b:   in  std_logic_vector(10 downto 0);  -- MSb is valid
    c:     out std_logic_vector(10 downto 0));
end node;

architecture node_arch of node is

    signal c_reg: std_logic_vector(10 downto 0);
    signal wptr_reg, rptr_reg: std_logic_vector(5 downto 0);

    signal empty, full, fifo_we, fifo_re: std_logic;
    signal fifo_dout: std_logic_vector(9 downto 0);

begin

-- make a simple FIFO dual port ram 10x32.  At reset the read and write pointers
-- are forced to 0 (empty)

fifogen: for i in 0 to 9 generate

    RAM32X1D_inst : RAM32X1D
    generic map (
        INIT => X"00000000")
    port map(
        DPO   => fifo_dout(i),
        A0    => wptr_reg(0),
        A1    => wptr_reg(1),
        A2    => wptr_reg(2),
        A3    => wptr_reg(3),
        A4    => wptr_reg(4),
        D     => B(i),
        DPRA0 => rptr_reg(0),
        DPRA1 => rptr_reg(1),
        DPRA2 => rptr_reg(2),
        DPRA3 => rptr_reg(3),
        DPRA4 => rptr_reg(4),
        WCLK  => clock,
        WE    => fifo_we);

end generate fifogen;

-- note make the R and W pointers 1 bit wider to make full/empty flag generation logic simpler...

empty <= '1' when (wptr_reg = rptr_reg) else '0';
full  <= '1' when ( (wptr_reg(4 downto 0)=rptr_reg(4 downto 0)) and (wptr_reg(5) /= rptr_reg(5)) ) else '0';

fifo_we <= '1' when (a(10)='1' and b(10)='1') else '0'; -- this will store B
fifo_re <= '1' when (a(10)='0' and b(10)='0') else '0'; -- no inputs, try to read

fifo_proc: process(clock)
begin
    if rising_edge(clock) then
        if (reset='1') then
            wptr_reg <= "000000";
            rptr_reg <= "000000";
            c_reg    <= (others=>'0');
        else
            if (fifo_we='1' and full='0') then  -- do not write to full FIFO!
                wptr_reg <= std_logic_vector( unsigned(wptr_reg) + 1);
            end if;

            if (fifo_re='1' and empty='0') then  -- do not read from empty FIFO!
                rptr_reg <= std_logic_vector( unsigned(rptr_reg) + 1);
            end if;

            if (a(10)='0' and b(10)='0') then
                if (empty='0') then -- not empty, read from FIFO
                    c_reg <= ('1' & fifo_dout);
                else -- FIFO empty, output zeros
                    c_reg <= (others=>'0');
                end if;
            elsif (a(10)='1' and b(10)='0') then
                c_reg <= a;
            elsif (a(10)='0' and b(10)='1') then
                c_reg <= b;
            elsif (a(10)='1' and b(10)='1') then
                c_reg <= a;
            else
                c_reg <= (others=>'0');
            end if;
        end if;
    end if;
end process fifo_proc;

c <= c_reg;

end node_arch;

