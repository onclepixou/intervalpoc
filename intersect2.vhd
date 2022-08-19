---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.interval_pkg.all;
---------------------------------------------------------------------------------
entity intersect2 is

    port ( i1 : IN  interval;
           i2 : IN  interval;
           o1 : OUT interval);

end entity;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
architecture behaviour of intersect2 is

    signal ordered_i1, ordered_i2 : interval;
    signal ordered      : std_logic;
    signal empty_input  : std_logic;
    signal disjoint     : std_logic;
    signal empty_output : std_logic;

    begin

        ordered  <= '1' when LE(l => i1.lb, r => i2.lb, check_error => true, denormalize => true) else '0';
        disjoint <= '1' when LT(l => ordered_i1.ub, r => ordered_i2.lb, check_error => true, denormalize => true) else '0';
        ordered_i1 <= i1 when (ordered = '1') else i2;
        ordered_i2 <= i1 when (ordered = '1') else i1;
        
        empty_input <= (ordered_i1.empty or ordered_i2.empty);
        empty_output <= (disjoint or empty_input);
        o1 <= ( lb => to_float(0), UB => to_float(0), EMPTY => '1') when empty_output else ( lb => ordered_i2.lb, ub => ordered_i1.ub, empty => '0');

end architecture;
---------------------------------------------------------------------------------