library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_ARITH.conv_std_logic_vector;

entity DigitalClock is
    port ( 
        -- clock 50 MHz
        clk: in std_logic; 
        -- Active high reset pulse, to set the time to the input hour and minute (as 
        -- defined by the H_in, M_in inputs) and the second to 00.
        -- For normal operation, this input pin should be 0.
        rst: in std_logic; 
        -- Hours intput (unsigned value)
        H_in: in std_logic_vector(4 downto 0);
        -- Minutes intput (unsigned value)
        M_in: in std_logic_vector(5 downto 0);
        -- Hours output (unsigned value)
        H_out: out std_logic_vector(4 downto 0);
        -- Minutes output (unsigned value)
        M_out: out std_logic_vector(5 downto 0);
        -- Seconds output (unsigned value)
        S_out: out std_logic_vector(5 downto 0)
    );
end DigitalClock;

architecture Behavioral of DigitalClock is

    component ClockDivider
        port (
            threshold: in std_logic_vector(31 downto 0);
            clk: in std_logic;
            dividedClk: out std_logic
        );
    end component;
	 
	 constant REAL_TIME_CLOCK_THREASHOLD: std_logic_vector(31 downto 0) := conv_std_logic_vector(100000000, 32);
	 constant REAL_TIME_CLOCK_THREASHOLD_STUB: std_logic_vector(31 downto 0) := conv_std_logic_vector(100, 32);

    signal oneSecondPulse: std_logic; -- 1-s clock
	 signal hours: integer := 5;
	 signal minutes: integer := 35;
	 signal seconds: integer := 10;

begin
    -- Create 1-s clock
    ONE_SECOND_CLOCK: ClockDivider port map (REAL_TIME_CLOCK_THREASHOLD, clk, oneSecondPulse); 

    -- Clock operation
    process (oneSecondPulse, rst)
    begin 
        if (rst = '1') then
            hours <= to_integer(unsigned(H_in));
            minutes <= to_integer(unsigned(M_in));
            seconds <= 0;
        elsif (rising_edge(oneSecondPulse)) then
            seconds <= seconds + 1;
            if (seconds >= 59) then -- seconds overflow
                minutes <= minutes + 1;
                seconds <= 0;
                if (minutes >= 59) then -- minutes overflow
                    minutes <= 0;
                    hours <= hours + 1;
                    if (hours >= 24) then -- hours overflow
                        hours <= 0;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Output
    H_out <= std_logic_vector(to_unsigned(hours, 5));
    M_out <= std_logic_vector(to_unsigned(minutes, 6));
    S_out <= std_logic_vector(to_unsigned(seconds, 6));

end Behavioral;