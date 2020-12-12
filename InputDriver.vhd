library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

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



begin
    
    -- Don't forget to hold settingDone for some time here

end Behavioral;