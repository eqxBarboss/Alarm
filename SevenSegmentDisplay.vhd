----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:30:54 12/12/2020 
-- Design Name: 
-- Module Name:    SevenSegmentDisplay - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SevenSegmentDisplay is
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
end SevenSegmentDisplay;

architecture Behavioral of SevenSegmentDisplay is

	component Decoder is
		port (
			Encoded: in std_logic_vector(3 downto 0);
			Decoded: out std_logic_vector(6 downto 0)
		);
	end component;
	
	component ClockDivider
        port (
            threshold: in std_logic_vector(31 downto 0);
            clk: in std_logic;
            dividedClk: out std_logic
        );
    end component;
	
	signal hours, minutes, seconds: integer;
	
	signal pulse: std_logic;
	
	signal count: integer;
	
	constant REAL_TIME_CLOCK_THREASHOLD: std_logic_vector(31 downto 0) := conv_std_logic_vector(25000000, 32);
	constant REAL_TIME_CLOCK_THREASHOLD_STUB: std_logic_vector(31 downto 0) := conv_std_logic_vector(1, 8);
	
	constant Empty: std_logic_vector(3 downto 0) := "1111";

	signal H_out1_bin: std_logic_vector(3 downto 0); -- The most significant digit of the hour
	signal H_out0_bin: std_logic_vector(3 downto 0); -- The least significant digit of the hour
	signal M_out1_bin: std_logic_vector(3 downto 0); -- The most significant digit of the minute
	signal M_out0_bin: std_logic_vector(3 downto 0); -- The least significant digit of the minute
	signal S_out1_bin: std_logic_vector(3 downto 0); -- The most significant digit of the second
	signal S_out0_bin: std_logic_vector(3 downto 0); -- The least significant digit of the second
	signal Alarm_bin: std_logic_vector(3 downto 0);
begin	

	QUARTER_SECOND_CLOCK: ClockDivider port map (REAL_TIME_CLOCK_THREASHOLD_STUB, clk, pulse); 
	
	process(pulse, Blink, clk)
	begin
		if(rising_edge(clk)) then
			if(rising_edge(pulse)) then
				count <= count + 1;
				if (count > 4) then
					count <= 1;
				end if;
			end if;
			if (count = 4) and (Blink = '1') then
				H_out1_bin <= Empty; 
				H_out0_bin <= Empty; 
				M_out1_bin <= Empty; 
				M_out0_bin <= Empty;
				S_out1_bin <= Empty;
				S_out0_bin <= Empty;
				Alarm_bin <= Empty;
			else
				hours <= to_integer(unsigned(H_in));
				minutes <= to_integer(unsigned(M_in));
				seconds <= to_integer(unsigned(S_in));

				H_out1_bin <= x"2" when hours >= 20 
				else x"1" when hours >= 10 
				else x"0";
				
				H_out0_bin <= std_logic_vector(to_unsigned((hours - to_integer(unsigned(H_out1_bin)) * 10), 4));

				M_out1_bin <= x"5" when minutes >= 50 
				else x"4" when minutes >= 40
				else x"3" when minutes >= 30
				else x"2" when minutes >= 20
				else x"1" when minutes >= 10 
				else x"0";

				M_out0_bin <= std_logic_vector(to_unsigned((minutes - to_integer(unsigned(M_out1_bin)) * 10), 4));

				S_out1_bin <= x"5" when seconds >= 50 
				else x"4" when seconds >= 40
				else x"3" when seconds >= 30
				else x"2" when seconds >= 20
				else x"1" when seconds >= 10 
				else x"0";

				S_out0_bin <= std_logic_vector(to_unsigned((seconds - to_integer(unsigned(S_out1_bin)) * 10), 4));

				Alarm_bin <= "1010" when Alarm_on = '1'
				else Empty;
			end if;	
		end if;
	end process;
	
	
	Decoder1: Decoder port map (Encoded => H_out1_bin, Decoded => Segm1_out); 

	Decoder2: Decoder port map (Encoded => H_out0_bin, Decoded => Segm2_out); 
	
	Decoder3: Decoder port map (Encoded => M_out1_bin, Decoded => Segm3_out); 

	Decoder4: Decoder port map (Encoded => M_out0_bin, Decoded => Segm4_out);

	Decoder5: Decoder port map (Encoded => S_out1_bin, Decoded => Segm5_out); 

	Decoder6: Decoder port map (Encoded => S_out0_bin, Decoded => Segm6_out);
	
	DecoderAlarm: Decoder port map (Encoded => Alarm_bin, Decoded => SegmAlarm_out);

end Behavioral;

