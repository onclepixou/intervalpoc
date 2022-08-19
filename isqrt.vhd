---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.interval_pkg.all;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- This entity performs square root on input interval
-- ports : 
--      x    : interval  : input interval 1
--      y    : interval  : output interval
entity isqrt is

    port ( x    : in  interval;
           y    : out interval);

end entity;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
architecture behaviour of isqrt is

    component intersect2 is

        port ( i1 : in  interval;
               i2 : in  interval;
               o1 : out interval);
    
    end component;

    signal xpos       : interval;
    signal ylb, yub : float32;

    begin

        inter1 : intersect2 port map( i1 => x, 
                                      i2 => INTERVAL_RPOS, 
                                      o1 => xpos);

        ylb <= sqrt(arg => x.lb, check_error => true, denormalize => true);
        yub <= sqrt(arg => x.ub, check_error => true, denormalize => true);

        y <= (lb => ylb, ub => yub, empty => x.empty);

end architecture;
---------------------------------------------------------------------------------