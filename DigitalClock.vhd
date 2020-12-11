library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity DigitalClock is
	port ( 
		-- clock 50 MHz
		clk: in std_logic; 
		-- Active high reset pulse, to set the time to the input hour and minute (as 
		-- defined by the H_in, M_in inputs) and the second to 00.
		-- For normal operation, this input pin should be 0.
		rst: in std_logic; 
		-- Hours intput (unsigned value)
		H_in: in std_logic_vector(4 downto 0);
		-- Minutes intput (unsigned value)
		M_in: in std_logic_vector(5 downto 0);
		-- Hours output (unsigned value)
		H_out: out std_logic_vector(4 downto 0);
		-- Minutes output (unsigned value)
		M_out: out std_logic_vector(5 downto 0);
		-- Seconds output (unsigned value)
		S_out: out std_logic_vector(5 downto 0)
	);
end DigitalClock;

architecture Behavioral of DigitalClock is

	component OneSecondClock
		port (
			clk_50: in std_logic;
			oneSecondPulse: out std_logic
		);
	end component;

	signal oneSecondPulse: std_logic; -- 1-s clock
	signal counterHours, counterMinutes, counterSeconds: integer;

begin
	-- Create 1-s clock
	oneSecClock: OneSecondClock port map (clk_50 => clk, oneSecondPulse => oneSecondPulse); 

	-- Clock operation
	process (oneSecondPulse, rst)
	begin 
		if (rst = '1') then
			counterHours <= to_integer(unsigned(H_in));
			counterMinutes <= to_integer(unsigned(M_in));
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

	-- Output
	H_out <= std_logic_vector(to_unsigned(counterHours, 5));
	M_out <= std_logic_vector(to_unsigned(counterMinutes, 6));
	S_out <= std_logic_vector(to_unsigned(counterSeconds, 6));

end Behavioral;