library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_ARITH.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;


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
		  refreshClk: in std_logic;
        H_in: in std_logic_vector(4 downto 0);        
        M_in: in std_logic_vector(5 downto 0);
		  S_in: in std_logic_vector(5 downto 0);
		  Alarm_on: in std_logic;
		  Blink: in std_logic;
        Segm1_out: out std_logic_vector(6 downto 0);
		  Control: out std_logic_vector(7 downto 0)
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
	
	signal count: integer := 0;
	
	constant REAL_TIME_CLOCK_THREASHOLD: std_logic_vector(31 downto 0) := conv_std_logic_vector(25000000, 32);
	constant REAL_TIME_CLOCK_THREASHOLD_STUB: std_logic_vector(31 downto 0) := conv_std_logic_vector(25, 32);
	
	constant Empty: std_logic_vector(3 downto 0) := "1111";

	signal H_out1_bin: std_logic_vector(3 downto 0); -- The most significant digit of the hour
	signal H_out0_bin: std_logic_vector(3 downto 0); -- The least significant digit of the hour
	signal M_out1_bin: std_logic_vector(3 downto 0); -- The most significant digit of the minute
	signal M_out0_bin: std_logic_vector(3 downto 0); -- The least significant digit of the minute
	signal S_out1_bin: std_logic_vector(3 downto 0); -- The most significant digit of the second
	signal S_out0_bin: std_logic_vector(3 downto 0); -- The least significant digit of the second
	signal Alarm_bin: std_logic_vector(3 downto 0);
	
	signal H_out1_temp: std_logic_vector(3 downto 0);
	signal H_out0_temp: std_logic_vector(3 downto 0);
	signal M_out1_temp: std_logic_vector(3 downto 0);
	signal M_out0_temp: std_logic_vector(3 downto 0);
	signal S_out1_temp: std_logic_vector(3 downto 0); 
	signal S_out0_temp: std_logic_vector(3 downto 0); 
	signal Alarm_temp: std_logic_vector(3 downto 0);
	
	signal DigitIndex: std_logic_vector(2 downto 0) := "000";
	signal DataBinary: std_logic_vector(3 downto 0);
	signal DataBinary_temp: std_logic_vector(3 downto 0);
begin	

	QUARTER_SECOND_CLOCK: ClockDivider port map (REAL_TIME_CLOCK_THREASHOLD, clk, pulse); 
	
	process(pulse, refreshClk, Blink)
	begin	
		if rising_edge(refreshClk) then
			DigitIndex <= DigitIndex + 1;
			if (DigitIndex = "111") then
				DigitIndex <= "000";
			end if;
		end if;
		if(rising_edge(pulse)) then
			count <= count + 1;
			if (count > 4) then
				count <= 1;
			end if;
		end if;
		if (count = 4) and (Blink = '1') then
			DataBinary <= Empty;
		else
			DataBinary <= DataBinary_temp;
		end if;	
	end process;
	
	hours <= to_integer(unsigned(H_in));
	minutes <= to_integer(unsigned(M_in));
	seconds <= to_integer(unsigned(S_in));

	H_out1_temp <= x"2" when hours >= 20 
	else x"1" when hours >= 10 
	else x"0";
	
	H_out0_temp <= std_logic_vector(to_unsigned((hours - to_integer(unsigned(H_out1_temp)) * 10), 4));

	M_out1_temp <= x"5" when minutes >= 50 
	else x"4" when minutes >= 40
	else x"3" when minutes >= 30
	else x"2" when minutes >= 20
	else x"1" when minutes >= 10 
	else x"0";

	M_out0_temp <= std_logic_vector(to_unsigned((minutes - to_integer(unsigned(M_out1_temp)) * 10), 4));

	S_out1_temp <= x"5" when seconds >= 50 
	else x"4" when seconds >= 40
	else x"3" when seconds >= 30
	else x"2" when seconds >= 20
	else x"1" when seconds >= 10 
	else x"0";

	S_out0_temp <= std_logic_vector(to_unsigned((seconds - to_integer(unsigned(S_out1_temp)) * 10), 4));

	Alarm_temp <= "1010" when Alarm_on = '1'
	else Empty;	
	
	with DigitIndex select DataBinary_temp <=
		H_out1_temp when "000",
		H_out0_temp when "001",
		M_out1_temp when "010",
		M_out0_temp when "011",
		S_out1_temp when "100",
		S_out0_temp when "101",
		Alarm_temp when "110",
		"0000" when others;
		
	with DigitIndex select Control <=
		"01111111" when "000",
		"10111111" when "001",
		"11011111" when "010",
		"11101111" when "011",
		"11110111" when "100",
		"11111011" when "101",
		"11111110" when "110",
		"11111111" when others;
	
	Decoder1: Decoder port map (Encoded => DataBinary, Decoded => Segm1_out); 

end Behavioral;

