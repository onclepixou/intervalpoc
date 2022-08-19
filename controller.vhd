---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
entity controller is 

    port ( clk   : in  std_logic;
           rst   : in  std_logic;
           stop  : in  std_logic; 
           state : out std_logic_vector(1 downto 0));

end entity;
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
architecture behaviour of controller is

    constant reset_state   : std_logic_vector(1 downto 0) := "00";
    constant compute_state : std_logic_vector(1 downto 0) := "01";
    constant update_state  : std_logic_vector(1 downto 0) := "10";
    constant stop_state    : std_logic_vector(1 downto 0) := "11";

    signal present_state : std_logic_vector(1 downto 0) := "00" ;
    signal next_state    : std_logic_vector(1 downto 0);


    begin

        state <= present_state;

        process(clk, rst, stop)
            begin
                if rising_edge(rst) then
                    present_state <= "00";
                elsif rising_edge(stop) then
                    present_state <= "11";
                elsif rising_edge(clk) then
                    present_state <= next_state;
                end if;
        end process;

        process(present_state)
            begin
                case present_state is 
                    when "00" =>
                        next_state <= "01";
                    when "01" =>
                        next_state <= "10";
                    when "10" =>
                        next_state <= "01";
                    when "11" =>
                        next_state <= "11";
                    when others =>
                        next_state <= "--";
                end case;
        end process;

end architecture;
---------------------------------------------------------------------------------