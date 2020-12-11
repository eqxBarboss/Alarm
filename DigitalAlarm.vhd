library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity DigitalAlarm is
	port ( 
        clk: in std_logic;
        -- 1 when setting alarm (async)
        rst: in std_logic;
        -- Time to set as alarm 
        H_in: in std_logic_vector(4 downto 0);
        M_in: in std_logic_vector(5 downto 0);
        -- Current time
        currentHours: in std_logic_vector(4 downto 0);
        currentMinutes: in std_logic_vector(5 downto 0);
        alarm: out std_logic
	);
end DigitalAlarm;

architecture Behavioral of DigitalAlarm is



begin
    
    -- Don't forget to hold settingDone for some time here

end Behavioral;