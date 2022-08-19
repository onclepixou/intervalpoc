---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.float_pkg.all;
use work.interval_pkg.all;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- This entity performs square elevation on input interval
-- ports : 
--      x    : interval  : input interval 1
--      y    : interval  : output interval
entity isqr is

    port ( x    : in  interval;
           y    : out interval);

end entity;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
architecture behaviour of isqr is

    -- express x format with (a, b) > 0 : 
    --  "00"  : interval of type [a, b]
    --  "01"  : interval of type [-a, -b]
    --  "10"  : interval of type [-a, b]
    --  "11"  : empty 
    signal xkind : std_logic_vector(1 downto 0);
    signal xlbge0, xubge0 : std_logic;
    signal xbsynth : std_logic_vector(1 downto 0);

    signal xlbsqr, xubsqr : float32;
    signal ylbf, yubf : float32;
    signal yempty : std_logic;

    begin

        xlbge0 <= '1' when ge(l => x.lb, r => to_float(0), check_error => true, denormalize => true) else '0';
        xubge0 <= '1' when ge(l => x.ub, r => to_float(0), check_error => true, denormalize => true) else '0';

        xbsynth <= xlbge0 & xubge0;

        with xbsynth select xkind <=
            "01" when "00",
            "10" when "01",
            "11" when "10",
            "00" when "11",
            "--" when others;

        xlbsqr <= multiply( l => x.lb, r => x.lb, check_error => true, denormalize => true);
        xubsqr <= multiply( l => x.ub, r => x.ub, check_error => true, denormalize => true);

        yempty <= '1' when (xkind = "11" or x.empty = '1') else '0';

        with xkind select ylbf <=
            xlbsqr      when "00",
            xubsqr      when "01",
            to_float(0) when "10",
            to_float(0) when "11",
            to_float(0) when others;

        with xkind select yubf <=
            xubsqr      when "00",
            xlbsqr      when "01",
            xubsqr      when "10",
            to_float(0) when "11",
            to_float(0) when others;
    
        y.lb <= ylbf;
        y.ub <= yubf;
        y.empty <= yempty;

end architecture;
---------------------------------------------------------------------------------