---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.interval_pkg.all;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- This entity performs addition/subtraction of two intervals
-- ports : 
--      mode : std_logic : op_mode 
--             - 0 for addition z = x + y
--             - 1 for subtraction z = x - y
--      x    : interval  : input interval 1
--      y    : interval  : input interval 2
--      z    : interval  : output interval
entity iadder is

    port ( mode : in  std_logic;
           x    : in  interval;
           y    : in  interval;
           z    : out interval);

end entity;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
architecture behaviour of iadder is

    signal zlbf, zubf : float32;
    signal zempty : std_logic;

    begin

        zempty <= '1' when (x.empty or y.empty) else '0';
        zlbf <= add( l => x.lb, r => y.lb, check_error => true, denormalize => true) when (mode = '0') else 
                subtract( l => x.lb, r => y.ub, check_error => true, denormalize => true);

        zubf <= add( l => x.ub, r => y.ub, check_error => true, denormalize => true) when (mode = '0') else
                subtract( l => x.ub, r => y.lb, check_error => true, denormalize => true);
       
        z.lb <= zlbf;
        z.ub <= zubf;
        z.empty <= zempty;

end architecture;
---------------------------------------------------------------------------------