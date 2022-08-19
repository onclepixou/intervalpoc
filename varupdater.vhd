---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.interval_pkg.all;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
entity varupdater is 

    generic ( PRODUCERS : positive range 1 to positive'high := 1 );

    port ( state        : in std_logic_vector(1 downto 0 );
           producers_in : in interval_vector(0 to PRODUCERS - 1);
           consumer_out : out  interval                        
    );

end entity;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
architecture behaviour of varupdater is

    constant reset_state   : std_logic_vector(1 downto 0) := "00";
    constant compute_state : std_logic_vector(1 downto 0) := "01";
    constant update_state  : std_logic_vector(1 downto 0) := "10";
    constant stop_state    : std_logic_vector(1 downto 0) := "11";

    component intersectn is 

        generic ( INPUT_SIZE : positive range 2 to positive'high := 2 );

        port ( intersection_in  : in  interval_vector( 0 TO input_size - 1 );
               intersection_out : out interval                             );

    end component;

    signal producers_intersect       : interval;
    signal producers_intersect_store : interval;

    begin

        process(state)

            begin

                if(state = compute_state) then
                    producers_intersect_store <= producers_intersect;
                end if;

        end process;

        add_fw_op : intersectn 

            generic map(INPUT_SIZE => PRODUCERS)
            port map (intersection_in  => producers_in,
                      intersection_out => producers_intersect);

        consumer_out <= producers_intersect_store;

end architecture;
---------------------------------------------------------------------------------