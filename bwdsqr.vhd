---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.interval_pkg.all;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- This computation blocks performs backward square operation (y = sqr(x))
-- ports : 
--      state : std_logic_vector : fsm state 
--                            - 00 for reset
--                            - 01 for compute
--                            - 10 for update
--                            - 11 for stop
--      x_in  : interval : input interval 1
--      y_in  : interval : input interval 2
--      x_out : interval : output interval 1
--      y_out : interval : output interval 2
--
-- Performed operation : be respectively (x_in ∩ [-oo, 0]) and (x_in ∩ [0, oo])
-- let x1, x2 
--                      y_out = (y_in ∩ (sqr(x1)) | (y_in ∩ (x2)))
--                      x_out = (x1 ∩ (-1 * sqrt(y_in))) | (x2 ∩ (sqrt(y_in)))
entity bwdsqr is 

    port ( state : in  std_logic_vector(1 downto 0);
           x_in  : in  interval;
           y_in  : in  interval;
           x_out : out interval;
           y_out : out interval                   );

end entity;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
architecture behaviour of bwdsqr is

    constant reset_state   : std_logic_vector(1 downto 0) := "00";
    constant compute_state : std_logic_vector(1 downto 0) := "01";
    constant update_state  : std_logic_vector(1 downto 0) := "10";
    constant stop_state    : std_logic_vector(1 downto 0) := "11";

    component isqr is

        port ( x    : in  interval;
               y    : out interval);
    
    end component;

    component isqrt is

        port ( x    : in  interval;
               y    : out interval);
    
    end component;

    component intersect2 is

        port ( i1 : in  interval;
               i2 : in  interval;
               o1 : out interval);
    
    end component;

    component union2 is

        port ( i1 : in  interval;
               i2 : in  interval;
               o1 : out interval);
    
    end component;


    signal x1, x1_sqr, yin_inter_sqrx1 : interval;
    signal x2, x2_sqr, yin_inter_sqrx2 : interval;
    signal yout_bwd_res                : interval;

    signal sqrt_yin, sqrt_yin_neg   : interval;
    signal x1_inter_sqrt_yin_neg    : interval;
    signal x2_inter_sqrt_yin        : interval;
    signal xout_bwd_res                : interval;


    
    begin

        ----------------------------------------------------------------------- computing y_out (begin)
        x1_inter : intersect2 port map( i1 => x_in, 
                                        i2 => INTERVAL_RNEG, 
                                        o1 => x1);

        x2_inter : intersect2 port map( i1 => x_in, 
                                        i2 => INTERVAL_RPOS, 
                                        o1 => x2);

        x1_sqr_op : isqr port map ( x => x1,
                                    y => x1_sqr);

        x2_sqr_op : isqr port map ( x => x2,
                                    y => x2_sqr);

        yin_sqrx1_inter : intersect2 port map( i1 => y_in, 
                                               i2 => x1_sqr, 
                                               o1 => yin_inter_sqrx1);

        yin_sqrx2_inter : intersect2 port map( i1 => y_in, 
                                               i2 => x2_sqr, 
                                               o1 => yin_inter_sqrx2);
        
        union1 : union2 port map( i1 => yin_inter_sqrx1, 
                                  i2 => yin_inter_sqrx2, 
                                  o1 => yout_bwd_res);
        ----------------------------------------------------------------------- computing y_out (end)

        ----------------------------------------------------------------------- computing x_out (begin)
        yin_sqrt_op : isqrt port map ( x => y_in,
                                       y => sqrt_yin);

        sqrt_yin_neg <= (lb => -sqrt_yin.ub, ub => -sqrt_yin.lb, empty => sqrt_yin.empty);

        x1_sqrt_yin_neg_iner : intersect2 port map( i1 => x1, 
                                                    i2 => sqrt_yin_neg, 
                                                    o1 => x1_inter_sqrt_yin_neg);

        x2_sqrt_yin_iner : intersect2 port map( i1 => x2, 
                                                i2 => sqrt_yin, 
                                                o1 => x2_inter_sqrt_yin);

        xout_result_inter : intersect2 port map( i1 => x1_inter_sqrt_yin_neg, 
                                                 i2 => x2_inter_sqrt_yin, 
                                                 o1 => xout_bwd_res);


        ----------------------------------------------------------------------- computing x_out (end)

        y_out <= yout_bwd_res when (state = compute_state) else INTERVAL_R;
        x_out <= xout_bwd_res when (state = compute_state) else INTERVAL_R;

end architecture;
---------------------------------------------------------------------------------