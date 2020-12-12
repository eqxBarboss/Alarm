library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_ARITH.conv_std_logic_vector;

entity InputDriver is
    port ( 
        clk: in std_logic; 
        timeButton: in std_logic;
        alarmButton: in std_logic;
        incrementHoursButton: in std_logic;
        incrementMinutesButton: in std_logic;
        H_in: in std_logic_vector(4 downto 0);
        M_in: in std_logic_vector(5 downto 0);
        H_out: out std_logic_vector(4 downto 0);
        M_out: out std_logic_vector(5 downto 0);
        -- Bool that tells us about the fact that the value (for clock or alarm was saved)
        settingDone: out std_logic;
        -- Bool that tells us about the fact that we are changing a value rn (and display is blinking)
        settingInProgress: out std_logic;
        -- Setting mode (0 - time, 1 - alarm)
        settingMode: out std_logic
    );
end InputDriver;

architecture Behavioral of InputDriver is

    constant TICKS_TO_HOLD_SETTING_DONE: integer := 2;

    signal hours, minutes: integer;
    signal modifyingInProgress: std_logic := '0';
    signal modifyingFinished: std_logic := '0';
    -- (0 - time, 1 - alarm)
    signal modifyingMode: std_logic := '0';
    signal ticksToHoldCounter: integer := 0;

begin

    main: process (clk, timeButton, alarmButton, incrementHoursButton, incrementMinutesButton)
    begin
        if (rising_edge(timeButton)) then
            if (modifyingInProgress = '0') then
                modifyingInProgress <= '1';
                modifyingMode <= '0';
                hours <= to_integer(unsigned(H_in));
                minutes <= to_integer(unsigned(M_in));
            else
                if (modifyingMode = '0') then
                    modifyingFinished <= '1';
                end if;
            end if;
        end if;

        if (rising_edge(alarmButton)) then
            if (modifyingInProgress = '0') then
                modifyingInProgress <= '1';
                modifyingMode <= '1';
                hours <= to_integer(unsigned(H_in));
                minutes <= to_integer(unsigned(M_in));
            else
                if (modifyingMode = '1') then
                    modifyingFinished <= '1';
                end if;
            end if;
        end if;

        if (rising_edge(clk)) then
            if (modifyingFinished = '1') then
                ticksToHoldCounter <= ticksToHoldCounter + 1;
                if (ticksToHoldCounter >= TICKS_TO_HOLD_SETTING_DONE) then
                    modifyingFinished <= '0';
                    ticksToHoldCounter <= 0;
                    modifyingInProgress <= '0';
                end if;
            elsif (modifyingInProgress = '1') then
                if (incrementHoursButton = '1') then
                    hours <= hours + 1;
                    if (hours >= 24) then -- hours overflow
                        hours <= 0;
                    end if;
                end if;
                if (incrementMinutesButton = '1') then
                    minutes <= minutes + 1;
                    if (minutes >= 59) then -- minutes overflow
                        minutes <= 0;
                    end if;
                end if;
            end if;            
        end if;
    end process;

    H_out <= std_logic_vector(to_unsigned(hours, 5));
    M_out <= std_logic_vector(to_unsigned(minutes, 6));
    settingDone <= modifyingFinished;
    settingInProgress <= modifyingInProgress;
    settingMode <= modifyingMode;

end Behavioral;