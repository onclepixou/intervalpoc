---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.interval_pkg.all;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- This computation blocks performs backward addition of two intervals (z = x + y)
-- ports : 
--      state : std_logic_vector : fsm state 
--                            - 00 for reset
--                            - 01 for compute
--                            - 10 for update
--                            - 11 for stop
--      x_in  : interval  : input  interval 1
--      y_in  : interval  : input  interval 2
--      z_in  : interval  : input  interval 3
--      x_out : interval  : output interval 1
--      y_out : interval  : output interval 2
--
-- Performed operation : 
--                      x_out = x_in ∩ (z_in - y_in)
--                      y_out = y_in ∩ (z_in - x_in)
entity bwdadd is 

    port ( state : in  std_logic_vector(1 downto 0);
           x_in     : in  interval;
           y_in     : in  interval;
           z_in     : in  interval;
           x_out    : out interval;
           y_out    : out interval                );

end entity;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
architecture behaviour of bwdadd is

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

    signal op_mode : std_logic := '1';

    signal subtract1_result : interval;
    signal subtract2_result : interval;

    signal x_out_bwd_result : interval;
    signal y_out_bwd_result : interval;

    begin

        sub_bwd_op1 : iadder port map (mode => op_mode,
                                       x    => z_in,
                                       y    => y_in,
                                       z    => subtract1_result);
                            
        sub_bwd_op2 : iadder port map (mode => op_mode,
                                       x    => z_in,
                                       y    => x_in,
                                       z    => subtract2_result);

        inter1 : intersect2 port map( i1 => x_in, 
                                      i2 => subtract1_result, 
                                      o1 => x_out_bwd_result);

        inter2 : intersect2 port map( i1 => y_in, 
                                      i2 => subtract2_result, 
                                      o1 => y_out_bwd_result);

        x_out <= x_out_bwd_result when (state = compute_state) else INTERVAL_R;
        y_out <= y_out_bwd_result when (state = compute_state) else INTERVAL_R;

end architecture;
---------------------------------------------------------------------------------