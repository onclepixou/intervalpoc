---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.interval_pkg.all;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
entity intersectn is 

    generic ( INPUT_SIZE : positive range 2 to positive'high := 2 );

    port ( intersection_in  : in  interval_vector( 0 TO input_size - 1 );
           intersection_out : out interval                             );

end entity;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
architecture behaviour of intersectn is

    component intersect2 is

        port ( i1 : in  interval;
               i2 : in  interval;
               o1 : out interval);
    
    end component;

    -- if there are n entries, we must save the results of the successive (n-1) intersection
    constant NB_OF_INTERSECTIONS : positive := (INPUT_SIZE - 1);
    SIGNAL results : interval_vector(0 TO (NB_OF_INTERSECTIONS - 1));

    begin

        -- base intersection (in case there are 2 entries and the need for only one intersection)
        inter : intersect2 port map( i1 => intersection_in(0), 
                                     i2 => intersection_in(1), 
                                     o1 => results(0));

        -- other intersections (if INPUT_SIZE > 2)
        inter_gen :  for i in 0 to (NB_OF_INTERSECTIONS - 2) generate

            inter_opt : intersect2 port map( i1 => results(i), 
                                             i2 => intersection_in(i + 2), 
                                             O1 => results(i + 1));
        end generate inter_gen;

        intersection_out <= results(NB_OF_INTERSECTIONS - 1);

end architecture;
---------------------------------------------------------------------------------