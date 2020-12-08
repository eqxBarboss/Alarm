LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TestOneSecondClock IS
END TestOneSecondClock;
 
ARCHITECTURE behavior OF TestOneSecondClock IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT OneSecondClock
    PORT(
         clk_50 : IN  std_logic;
         oneSecondPulse : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_50 : std_logic := '0';

 	--Outputs
   signal oneSecondPulse : std_logic;

   -- Clock period definitions
   constant clk_50_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: OneSecondClock PORT MAP (
          clk_50 => clk_50,
          oneSecondPulse => oneSecondPulse
        );

   -- Clock process definitions
   clk_50_process :process
   begin
		clk_50 <= '0';
		wait for clk_50_period/2;
		clk_50 <= '1';
		wait for clk_50_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_50_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
