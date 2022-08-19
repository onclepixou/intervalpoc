---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.interval_pkg.all;
---------------------------------------------------------------------------------
entity union2 is

    port ( i1 : IN  interval;
           i2 : IN  interval;
           o1 : OUT interval);

end entity;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
architecture behaviour of union2 is

    signal empty_inputs : std_logic_vector(1 downto 0);
    signal min_lb       : float32;
    signal max_ub       : float32;
    signal o1lb, o1ub   : float32;
    signal o1empty      : std_logic;

    begin

        empty_inputs <= i2.empty & i1.empty;
        min_lb   <= i1.lb when le(l => i1.lb, r => i2.lb, check_error => true, denormalize => true) else i2.lb;
        max_ub   <= i1.ub when ge(l => i1.ub, r => i2.ub, check_error => true, denormalize => true) else i2.ub;

        with empty_inputs select o1lb <= min_lb       when "00",
                                         i2.lb        when "01",
                                         i1.lb        when "10",
                                         to_float(0 ) when "11",
                                         to_float(0 ) when others;

        with empty_inputs select o1ub <= max_ub       when "00",
                                         i2.ub        when "01",
                                         i1.ub        when "10",
                                         to_float(0 ) when "11",
                                         to_float(0 ) when others;

        o1empty <= i1.empty and i2.empty;


        o1  <= (lb => o1lb, ub => o1ub, empty => o1empty);

end architecture;
---------------------------------------------------------------------------------