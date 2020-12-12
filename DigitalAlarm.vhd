library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity DigitalAlarm is
    port ( 
        clk: in std_logic;
        -- 1 when setting alarm (async)
        rst: in std_logic;
        -- To turn off alarm
        turnOff: in std_logic;
        -- Time to set as alarm 
        H_in: in std_logic_vector(4 downto 0);
        M_in: in std_logic_vector(5 downto 0);
        -- Current time
        currentHours: in std_logic_vector(4 downto 0);
        currentMinutes: in std_logic_vector(5 downto 0);
        isAlarmSet: out std_logic;
        alarm: out std_logic
    );
end DigitalAlarm;

architecture Behavioral of DigitalAlarm is

	signal sAlarm: std_logic := '0';
	signal sIsAlarmSet: std_logic := '0';
	
	signal savedHours: std_logic_vector(4 downto 0) := (others => '0');
	signal savedMinutes: std_logic_vector(5 downto 0) := (others => '0');
	
begin

	Main: process (clk, rst, H_in, M_in, turnOff)
	begin
		if rst = '1' then
			savedHours <= H_in;
			savedMinutes <= M_in;
			sIsAlarmSet <= '1';
		elsif rising_edge(clk) then
			if sIsAlarmSet = '1' then
				if savedHours = currentHours and savedMinutes = currentMinutes then
					sAlarm <= '1';
				end if;
				if turnOff = '1' then
					sIsAlarmSet <= '0';
					sAlarm <= '0';
				end if;
			end if;
		end if;
	end process;
	
	alarm <= sAlarm;
	isAlarmSet <= sIsAlarmSet;
	
end Behavioral;