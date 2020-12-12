LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY TestDigitalAlarm IS
END TestDigitalAlarm;
 
ARCHITECTURE behavior OF TestDigitalAlarm IS 
  
    COMPONENT DigitalAlarm
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         turnOff : IN  std_logic;
         H_in : IN  std_logic_vector(4 downto 0);
         M_in : IN  std_logic_vector(5 downto 0);
         currentHours : IN  std_logic_vector(4 downto 0);
         currentMinutes : IN  std_logic_vector(5 downto 0);
         isAlarmSet : OUT  std_logic;
         alarm : OUT  std_logic
        );
    END COMPONENT;
    
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal turnOff : std_logic := '0';
   signal H_in : std_logic_vector(4 downto 0) := (others => '0');
   signal M_in : std_logic_vector(5 downto 0) := (others => '0');
   signal currentHours : std_logic_vector(4 downto 0) := (others => '0');
   signal currentMinutes : std_logic_vector(5 downto 0) := (others => '0');

   signal isAlarmSet : std_logic;
   signal alarm : std_logic;

   constant clk_period : time := 10 ns;
 
BEGIN
 
   uut: DigitalAlarm PORT MAP (
          clk => clk,
          rst => rst,
          turnOff => turnOff,
          H_in => H_in,
          M_in => M_in,
          currentHours => currentHours,
          currentMinutes => currentMinutes,
          isAlarmSet => isAlarmSet,
          alarm => alarm
        );

   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   stim_proc: process
   begin		
		rst <= '1';
      wait for 100 ns;	
		
		turnOff <= '0';
		rst <= '0';
      wait for 100 ns;	
		
		turnOff <= '1';
		rst <= '0';
      wait for 100 ns;	
		
		turnOff <= '0';
		rst <= '0';
      wait for 100 ns;
   end process;

END;
