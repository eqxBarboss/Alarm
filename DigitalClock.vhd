library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity DigitalClock is
	port ( 
		-- clock 50 MHz
		clk: in std_logic; 
		-- Active low reset pulse, to set the time to the input hour and minute (as 
		-- defined by the H_in1, H_in0, M_in1, and M_in0 inputs) and the second to 00.
		-- For normal operation, this input pin should be 1.
		rst: in std_logic; 
		-- 2-bit input used to set the most significant hour digit of the clock 
		-- Valid values are 0 to 2. 
		H_in1: in std_logic_vector(1 downto 0);
		-- 4-bit input used to set the least significant hour digit of the clock 
		-- Valid values are 0 to 9.  
		H_in0: in std_logic_vector(3 downto 0);
		-- 4-bit input used to set the most significant minute digit of the clock 
		-- Valid values are 0 to 9.  
		M_in1: in std_logic_vector(3 downto 0);
		-- 4-bit input used to set the least significant minute digit of the clock 
		-- Valid values are 0 to 9.  
		M_in0: in std_logic_vector(3 downto 0);
		-- The most significant digit of the hour. Valid values are 0 to 2 (Hexadecimal value on 7-segment LED)
		H_out1: out std_logic_vector(6 downto 0);
		-- The least significant digit of the hour. Valid values are 0 to 9 (Hexadecimal value on 7-segment LED)
		H_out0: out std_logic_vector(6 downto 0);
		-- The most significant digit of the minute. Valid values are 0 to 5 (Hexadecimal value on 7-segment LED)
		M_out1: out std_logic_vector(6 downto 0);
		-- The least significant digit of the minute. Valid values are 0 to 9 (Hexadecimal value on 7-segment LED)
		M_out0: out std_logic_vector(6 downto 0);
		-- The most significant digit of the second. Valid values are 0 to 5 (Hexadecimal value on 7-segment LED)
		S_out1: out std_logic_vector(6 downto 0);
		-- The least significant digit of the second. Valid values are 0 to 9 (Hexadecimal value on 7-segment LED)
		S_out0: out std_logic_vector(6 downto 0)
	);
end DigitalClock;

architecture Behavioral of DigitalClock is

	component BinToHex
		port (
			B_in: in std_logic_vector(3 downto 0);
			H_out: out std_logic_vector(6 downto 0)
		);
	end component;

	component OneSecondClock
		port (
			clk_50: in std_logic;
			oneSecondPulse: out std_logic
		);
	end component;

	signal oneSecondPulse: std_logic; -- 1-s clock
	signal counterHours, counterMinutes, counterSeconds: integer;

	signal H_out1_bin: std_logic_vector(3 downto 0); -- The most significant digit of the hour
	signal H_out0_bin: std_logic_vector(3 downto 0); -- The least significant digit of the hour
	signal M_out1_bin: std_logic_vector(3 downto 0); -- The most significant digit of the minute
	signal M_out0_bin: std_logic_vector(3 downto 0); -- The least significant digit of the minute
	signal S_out1_bin: std_logic_vector(3 downto 0); -- The most significant digit of the second
	signal S_out0_bin: std_logic_vector(3 downto 0); -- The least significant digit of the second

begin
	-- create 1-s clock
	oneSecClock: OneSecondClock port map (clk_50 => clk, oneSecondPulse => oneSecondPulse); 

	-- clock operation
	process (oneSecondPulse, rst)
	begin 
		if (rst = '0') then
			counterHours <= to_integer(unsigned(H_in1)) * 10 + to_integer(unsigned(H_in0));
			counterMinutes <= to_integer(unsigned(M_in1)) * 10 + to_integer(unsigned(M_in0));
			counterSeconds <= 0;
		elsif (rising_edge(oneSecondPulse)) then
			counterSeconds <= counterSeconds + 1;
			if (counterSeconds >= 59) then -- seconds overflow
				counterMinutes <= counterMinutes + 1;
				counterSeconds <= 0;
				if (counterMinutes >= 59) then -- minutes overflow
					counterMinutes <= 0;
					counterHours <= counterHours + 1;
					if (counterHours >= 24) then -- hours overflow
						counterHours <= 0;
					end if;
				end if;
			end if;
		end if;
	end process;

	-- Time conversion
	-- H_out1 binary value
	H_out1_bin <= x"2" when counterHours >= 20 
	else x"1" when counterHours >= 10 
	else x"0";
	-- 7-Segment LED display of H_out1
	binToHexConverter_H_out1: BinToHex port map (B_in => H_out1_bin, H_out => H_out1); 

	-- H_out0 binary value
	H_out0_bin <= std_logic_vector(to_unsigned((counterHours - to_integer(unsigned(H_out1_bin)) * 10), 4));
	-- 7-Segment LED display of H_out0
	binToHexConverter_H_out0: BinToHex port map (B_in => H_out0_bin, H_out => H_out0); 

	-- M_out1 binary value
	M_out1_bin <= x"5" when counterMinutes >= 50 
	else x"4" when counterMinutes >= 40
	else x"3" when counterMinutes >= 30
	else x"2" when counterMinutes >= 20
	else x"1" when counterMinutes >= 10 
	else x"0";
	-- 7-Segment LED display of M_out1
	binToHexConverter_M_out1: BinToHex port map (B_in => M_out1_bin, H_out => M_out1); 

	-- M_out0 binary value
	M_out0_bin <= std_logic_vector(to_unsigned((counterMinutes - to_integer(unsigned(M_out1_bin)) * 10), 4));
	-- 7-Segment LED display of M_out0
	binToHexConverter_M_out0: BinToHex port map (B_in => M_out0_bin, H_out => M_out0);

	-- S_out1 binary value
	S_out1_bin <= x"5" when counterSeconds >= 50 
	else x"4" when counterSeconds >= 40
	else x"3" when counterSeconds >= 30
	else x"2" when counterSeconds >= 20
	else x"1" when counterSeconds >= 10 
	else x"0";
	-- 7-Segment LED display of S_out1
	binToHexConverter_S_out1: BinToHex port map (B_in => S_out1_bin, H_out => S_out1); 

	-- S_out0 binary value
	S_out0_bin <= std_logic_vector(to_unsigned((counterSeconds - to_integer(unsigned(S_out1_bin)) * 10), 4));
	-- 7-Segment LED display of S_out0
	binToHexConverter_S_out0: BinToHex port map (B_in => S_out0_bin, H_out => S_out0);

end Behavioral;