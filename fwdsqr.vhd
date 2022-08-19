---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.interval_pkg.all;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- This computation blocks performs forward square operation (y = sqr(x))
-- ports : 
--      state : std_logic_vector : fsm state 
--                            - 00 for reset
--                            - 01 for compute
--                            - 10 for update
--                            - 11 for stop
--      x_in  : interval : input interval 1
--      y_in  : interval : input interval 2
--      y_out : interval : output interval
--
-- Performed operation : 
--                      y_out = y_in ∩ (sqr(x_in))
entity fwdsqr is 

    port ( state : in  std_logic_vector(1 downto 0);
           x_in  : in  interval;
           y_in  : in  interval;
           y_out : out interval                   );

end entity;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
architecture behaviour of fwdsqr is

    constant reset_state   : std_logic_vector(1 downto 0) := "00";
    constant compute_state : std_logic_vector(1 downto 0) := "01";
    constant update_state  : std_logic_vector(1 downto 0) := "10";
    constant stop_state    : std_logic_vector(1 downto 0) := "11";

    component isqr is

        port ( x    : in  interval;
               y    : out interval);
    
    end component;

    component intersect2 is

        port ( i1 : in  interval;
               i2 : in  interval;
               o1 : out interval);
    
    end component;

    signal sqr1_result : interval;

    signal y_out_fwd_result : interval;
    
    begin

        -- sqr fwd  : 
        -- y_out = y_in ∩ (sqr(x_in))
        sqr_fwd_op : isqr port map ( x => x_in,
                                     y => sqr1_result);

        inter1 : intersect2 port map( i1 => y_in, 
                                      i2 => sqr1_result, 
                                      o1 => y_out_fwd_result);

        y_out <= y_out_fwd_result when (state = compute_state) else INTERVAL_R;

end architecture;
---------------------------------------------------------------------------------