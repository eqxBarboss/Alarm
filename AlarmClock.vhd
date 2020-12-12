library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_ARITH.conv_std_logic_vector;

entity AlarmClock is
    port ( 
        clk: in std_logic; 
        rst: in std_logic;
        timeButton: in std_logic;
        alarmButton: in std_logic;
        incrementHoursButton: in std_logic;
        incrementMinutesButton: in std_logic;
        disableAlarmButton: in std_logic;
        Display1: out std_logic_vector(6 downto 0);
		  Display2: out std_logic_vector(6 downto 0);
		  Display3: out std_logic_vector(6 downto 0);
		  Display4: out std_logic_vector(6 downto 0);
		  Display5: out std_logic_vector(6 downto 0);
		  Display6: out std_logic_vector(6 downto 0);
		  DisplayA: out std_logic_vector(6 downto 0)
    );
end AlarmClock;

architecture Behavioral of AlarmClock is

    component ClockDivider
        port (
            threshold: in std_logic_vector(31 downto 0);
            clk: in std_logic;
            dividedClk: out std_logic
        );
    end component;

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
	 
	 component SevenSegmentDisplay
        port (     
			  clk: in std_logic;
			  H_in: in std_logic_vector(4 downto 0);        
			  M_in: in std_logic_vector(5 downto 0);
			  S_in: in std_logic_vector(5 downto 0);
			  Alarm_on: in std_logic;
			  Blink: in std_logic;
			  Segm1_out: out std_logic_vector(6 downto 0);
			  Segm2_out: out std_logic_vector(6 downto 0);
			  Segm3_out: out std_logic_vector(6 downto 0);
			  Segm4_out: out std_logic_vector(6 downto 0);
			  Segm5_out: out std_logic_vector(6 downto 0);
			  Segm6_out: out std_logic_vector(6 downto 0);
			  SegmAlarm_out: out std_logic_vector(6 downto 0)
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

    -- Clock for input driver has 0.1s period
    constant INPUT_CLOCK_THREASHOLD: std_logic_vector(31 downto 0) := conv_std_logic_vector(10000000, 32);

    -- Time data
    signal hours: std_logic_vector(4 downto 0);
    signal minutes: std_logic_vector(5 downto 0);
    signal seconds: std_logic_vector(5 downto 0);

    -- Clocks
    signal inputDriverClk: std_logic;

    signal hoursToSet: std_logic_vector(4 downto 0);
    signal minutesToSet: std_logic_vector(5 downto 0);

    signal hoursToDisplay: std_logic_vector(4 downto 0);
    signal minutesToDisplay: std_logic_vector(5 downto 0);
    signal secondsToDisplay: std_logic_vector(5 downto 0);

    -- State signals
    signal resetTime: std_logic;
    signal resetAlarm: std_logic;
    signal settingDone: std_logic;
    signal settingInProgress: std_logic;
    signal settingMode: std_logic;
    signal alarm: std_logic;
    signal isAlarmSet: std_logic;
	 
	 signal blink: std_logic;

begin

	 blink <= '1' when alarm = '1' or settingInProgress = '1'
	 else '0';
    -- Time setting process
    resetTime <= '1' when ((settingDone = '1') and (settingMode = '0')) else '0';
    resetAlarm <= '1' when ((settingDone = '1') and (settingMode = '1')) else '0';
    
    hoursToDisplay <= hoursToSet when (settingInProgress = '1') else hours;
    minutesToDisplay <= minutesToSet when (settingInProgress = '1') else minutes;
    secondsToDisplay <= "000000" when (settingInProgress = '1') else seconds;
    
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
        , disableAlarmButton
        , hoursToSet
        , minutesToSet
        , hours
        , minutes
        , isAlarmSet
        , alarm
    );

    INPUR_CLOCK_DIVIDER: ClockDivider port map (INPUT_CLOCK_THREASHOLD, clk, inputDriverClk); 

    INPUT_DRIVER: InputDriver port map (
          inputDriverClk
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
	 
	 SEVEN_SEGMENT_DISPLAY: SevenSegmentDisplay port map (
			 clk
		  , hoursToDisplay       
		  , minutesToDisplay
		  , secondsToDisplay
		  , isAlarmSet
		  , blink
		  , Display1
		  , Display2
		  , Display3
		  , Display4
		  , Display5
		  , Display6
		  , DisplayA
    );


end Behavioral;