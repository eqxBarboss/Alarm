library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity AlarmClock is
    port ( 
        clk: in std_logic; 
        rst: in std_logic;
        timeButton: in std_logic;
        alarmButton: in std_logic;
        incrementHoursButton: in std_logic;
        incrementMinutesButton: in std_logic;
        disableAlarmButton: in std_logic
        -- Also need to add display output here
    );
end AlarmClock;

architecture Behavioral of AlarmClock is

    component DigitalClock
        port (
            clk: in std_logic; 			
            rst: in std_logic; 
            H_in: in std_logic_vector(4 downto 0);
            M_in: in std_logic_vector(5 downto 0);
            H_out: out std_logic_vector(4 downto 0);
            M_out: out std_logic_vector(5 downto 0);
            S_out: out std_logic_vector(5 downto 0)
        );
    end component;

    component DigitalAlarm
        port (
            clk: in std_logic;
            rst: in std_logic;
            turnOff: in std_logic;
            H_in: in std_logic_vector(4 downto 0);
            M_in: in std_logic_vector(5 downto 0);
            currentHours: in std_logic_vector(4 downto 0);
            currentMinutes: in std_logic_vector(5 downto 0);
            isAlarmSet: out std_logic;
            alarm: out std_logic
        );
    end component;
    
    component InputDriver
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
    end component;

    -- Time data
    signal hours: std_logic_vector(4 downto 0);
    signal minutes: std_logic_vector(5 downto 0);
    signal seconds: std_logic_vector(5 downto 0);

    signal hoursToSet: std_logic_vector(4 downto 0);
    signal minutesToSet: std_logic_vector(5 downto 0);

    -- State signals
    signal resetTime: std_logic;
    signal resetAlarm: std_logic;
    signal settingDone: std_logic;
    signal settingInProgress: std_logic;
    signal settingMode: std_logic;
    signal alarm: std_logic;
    signal isAlarmSet: std_logic;

begin
    -- Time setting process
    resetTime <= '1' when ((settingDone = '1') and (settingMode = '0')) else '0';
    resetAlarm <= '1' when ((settingDone = '1') and (settingMode = '1')) else '0';
    
    -- It's fine to pass clk here, DigitalClock has a clock divider
    DIGITAL_CLOCK: DigitalClock port map (
          clk
        , resetAlarm
        , hoursToSet
        , minutesToSet
        , hours
        , minutes
        , seconds
    );

    DIGITAL_ALARM: DigitalAlarm port map (
          clk
        , resetTime
        , disableAlarm
        , hoursToSet
        , minutesToSet
        , hours
        , minutes
        , isAlarmSet
        , alarm
    );

    INPUT_DRIVER: InputDriver port map (
          clk
        , timeButton
        , alarmButton
        , incrementHoursButton
        , incrementMinutesButton
        , hours
        , minutes
        , hoursToSet
        , minutesToSet
        , settingDone
        , settingInProgress
        , settingMode
    );


end Behavioral;