---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.interval_pkg.all;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- This computation blocks performs forward addition of two intervals (z = x + y)
-- ports : 
--      state : std_logic_vector : fsm state 
--                            - 00 for reset
--                            - 01 for compute
--                            - 10 for update
--                            - 11 for stop
--      x_in  : interval : input interval 1
--      y_in  : interval : input interval 2
--      z_out : interval : output interval
--
-- Performed operation : 
--                      z_out = z_in ∩ (x + y)
entity fwdadd is 

    port ( state : in  std_logic_vector(1 downto 0);
           x_in  : in  interval;
           y_in  : in  interval;
           z_in  : in  interval;
           z_out : out interval                   );

end entity;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
architecture behaviour of fwdadd is

    constant reset_state   : std_logic_vector(1 downto 0) := "00";
    constant compute_state : std_logic_vector(1 downto 0) := "01";
    constant update_state  : std_logic_vector(1 downto 0) := "10";
    constant stop_state    : std_logic_vector(1 downto 0) := "11";

    component iadder is 

        port ( mode : in std_logic;
               x    : in  interval;
               y    : in  interval;
               z    : out interval);

    end component;

    component intersect2 is

        port ( i1 : in  interval;
               i2 : in  interval;
               o1 : out interval);
    
    end component;

    signal op_mode     : std_logic := '0';

    signal add1_result : interval;

    signal z_out_fwd_result : interval;
    
    begin

        -- addition fwd  : 
        -- x + y = z
        add_fwd_op : iadder port map (mode => op_mode,
                                     x => x_in,
                                     y => y_in,
                                     z => add1_result);

        inter1 : intersect2 port map( i1 => z_in, 
                                      i2 => add1_result, 
                                      o1 => z_out_fwd_result);

        z_out <= z_out_fwd_result when (state = compute_state) else INTERVAL_R;

end architecture;
---------------------------------------------------------------------------------