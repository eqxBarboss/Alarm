LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY sevenSegmDisplayTest IS
END sevenSegmDisplayTest;
 
ARCHITECTURE behavior OF sevenSegmDisplayTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SevenSegmentDisplay
    PORT(
         clk : IN  std_logic;
         H_in : IN  std_logic_vector(4 downto 0);
         M_in : IN  std_logic_vector(5 downto 0);
         S_in : IN  std_logic_vector(5 downto 0);
         Alarm_on : IN  std_logic;
         Blink : IN  std_logic;
         Segm1_out : OUT  std_logic_vector(6 downto 0);
         Segm2_out : OUT  std_logic_vector(6 downto 0);
         Segm3_out : OUT  std_logic_vector(6 downto 0);
         Segm4_out : OUT  std_logic_vector(6 downto 0);
         Segm5_out : OUT  std_logic_vector(6 downto 0);
         Segm6_out : OUT  std_logic_vector(6 downto 0);
         SegmAlarm_out : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal H_in : std_logic_vector(4 downto 0) := (others => '0');
   signal M_in : std_logic_vector(5 downto 0) := (others => '0');
   signal S_in : std_logic_vector(5 downto 0) := (others => '0');
   signal Alarm_on : std_logic := '0';
   signal Blink : std_logic := '0';

 	--Outputs
   signal Segm1_out : std_logic_vector(6 downto 0);
   signal Segm2_out : std_logic_vector(6 downto 0);
   signal Segm3_out : std_logic_vector(6 downto 0);
   signal Segm4_out : std_logic_vector(6 downto 0);
   signal Segm5_out : std_logic_vector(6 downto 0);
   signal Segm6_out : std_logic_vector(6 downto 0);
   signal SegmAlarm_out : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SevenSegmentDisplay PORT MAP (
          clk => clk,
          H_in => H_in,
          M_in => M_in,
          S_in => S_in,
          Alarm_on => Alarm_on,
          Blink => Blink,
          Segm1_out => Segm1_out,
          Segm2_out => Segm2_out,
          Segm3_out => Segm3_out,
          Segm4_out => Segm4_out,
          Segm5_out => Segm5_out,
          Segm6_out => Segm6_out,
          SegmAlarm_out => SegmAlarm_out
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
		
		H_in <= "10010";
		M_in <= "100101";
		S_in <= "001110";
		Alarm_on <= '0';
		Blink <= '0';
				
      wait for clk_period*10;
		
		H_in <= "10010";
		M_in <= "100101";
		S_in <= "001110";
		Alarm_on <= '1';
		Blink <= '1';
		
		wait for clk_period*100;
		
		H_in <= "10110";
		M_in <= "000101";
		S_in <= "001110";
		Alarm_on <= '1';
		Blink <= '0';
		
		wait for clk_period*10;
		
		H_in <= "00110";
		M_in <= "000100";
		S_in <= "001010";
		Alarm_on <= '0';
		Blink <= '1';

      -- insert stimulus here 

      wait;
   end process;

END;
