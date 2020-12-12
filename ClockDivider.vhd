library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ClockDivider is
    port (
        threshold: std_logic_vector(31 downto 0);
        clk: in std_logic;
        dividedClk: out std_logic
    );
end ClockDivider;

architecture Behavioral of ClockDivider is	

    signal ticks: std_logic_vector(31 downto 0) := (others => '0');
    signal result: std_logic := '0';
    
begin
    Main: process (clk)
    begin
        if (rising_edge(clk)) then 
            ticks <= ticks + 1;
            if ticks < threshold then 
                result <= '0';
            else 
                result <= '1';
                ticks <= (others => '0');
            end if;
        end if;
    end process;

    dividedClk <= result;
end Behavioral;