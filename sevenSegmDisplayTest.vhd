--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:44:51 12/12/2020
-- Design Name:   
-- Module Name:   C:/Users/compp/Desktop/qqq/Alarm/sevenSegmDisplayTest.vhd
-- Project Name:  Alarm
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SevenSegmentDisplay
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

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
