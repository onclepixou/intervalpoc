---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.float_pkg.all;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
package interval_pkg is

    type interval is record
        lb    : float32;
        ub    : float32;         
        empty : std_logic;     
    end record interval;

    TYPE interval_vector is array(natural range <>) of interval;

    constant INTERVAL_EMPTY : interval := (lb => to_float(0), ub => to_float(0), empty => '1');
    constant INTERVAL_RPOS  : interval := (lb => to_float(0), ub => pos_inffp,   empty => '0');
    constant INTERVAL_RNEG  : interval := (lb => neg_inffp,   ub => to_float(0), empty => '0');
    constant INTERVAL_R     : interval := (lb => neg_inffp,   ub => pos_inffp,   empty => '0');
    
end package interval_pkg;
---------------------------------------------------------------------------------