--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:47:17 12/12/2020
-- Design Name:   
-- Module Name:   C:/Users/eqxba/Alarm/TestAlarmClock.vhd
-- Project Name:  Alarm
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AlarmClock
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TestAlarmClock IS
END TestAlarmClock;
 
ARCHITECTURE behavior OF TestAlarmClock IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AlarmClock
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         timeButton : IN  std_logic;
         alarmButton : IN  std_logic;
         incrementHoursButton : IN  std_logic;
         incrementMinutesButton : IN  std_logic;
         disableAlarmButton : IN  std_logic;
         DisplayData : OUT  std_logic_vector(6 downto 0);
         DisplayControl : OUT  std_logic_vector(7 downto 0);
         H_out: out std_logic_vector(4 downto 0);
         M_out: out std_logic_vector(5 downto 0);
         S_out: out std_logic_vector(5 downto 0);
			alarmOut: out std_logic;
			alarmOutSet: out std_logic;
         settingReset: out std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal timeButton : std_logic := '0';
   signal alarmButton : std_logic := '0';
   signal incrementHoursButton : std_logic := '0';
   signal incrementMinutesButton : std_logic := '0';
   signal disableAlarmButton : std_logic := '0';

 	--Outputs
   signal DisplayData : std_logic_vector(6 downto 0);
   signal DisplayControl : std_logic_vector(7 downto 0);
   signal H_out: std_logic_vector(4 downto 0);
   signal M_out: std_logic_vector(5 downto 0);
   signal S_out: std_logic_vector(5 downto 0);
   signal settingReset: std_logic;
	signal alarmOutSet: std_logic;
	signal alarmOut: std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AlarmClock PORT MAP (
          clk => clk,
          rst => rst,
          timeButton => timeButton,
          alarmButton => alarmButton,
          incrementHoursButton => incrementHoursButton,
          incrementMinutesButton => incrementMinutesButton,
          disableAlarmButton => disableAlarmButton,
          DisplayData => DisplayData,
          DisplayControl => DisplayControl,
          H_out => H_out,
          M_out => M_out,
          S_out => S_out,
			 alarmOut => alarmOut,
			 alarmOutSet => alarmOutSet,
          settingReset => settingReset
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      --

      wait for clk_period*100;

      timeButton <= '1';

      wait for clk_period*10;

      timeButton <= '0';

      wait for clk_period*10;

      incrementHoursButton <= '1';

      wait for clk_period*100;

      incrementHoursButton <= '0';

      wait for clk_period*10;

      incrementMinutesButton <= '1';

      wait for clk_period*100;

      incrementMinutesButton <= '0';

      wait for clk_period*10;

      timeButton <= '1';

      wait for clk_period*10;

      timeButton <= '0';
		
		wait for clk_period*100;

      -- insert stimulus here 
		
		alarmButton <= '1';

      wait for clk_period*10;

      alarmButton <= '0';

      wait for clk_period*10;
		
      incrementMinutesButton <= '1';

      wait for clk_period*100;

      incrementMinutesButton <= '0';

      wait for clk_period*10;

      alarmButton <= '1';

      wait for clk_period*10;

      alarmButton <= '0';
		
		wait for clk_period*100000;
		
		disableAlarmButton <= '1';
		
		wait for clk_period*1000;

      wait;
   end process;

END;
