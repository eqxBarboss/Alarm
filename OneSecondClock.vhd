library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity OneSecondClock is
	port (
		clk_50: in std_logic;
		oneSecondPulse: out std_logic
	);
end OneSecondClock;

architecture Behavioral of OneSecondClock is

	signal counter: std_logic_vector(27 downto 0) := (others =>'0');

begin

	-- FPGA Begin --
	
--	process (clk_50)
--	begin
--		if (rising_edge(clk_50)) then
--			counter <= counter + x"0000001";
--			-- If higher than 50.000.000 ticks
--			if (counter >= x"2FAF080") then
--				counter <= x"0000000";
--			end if;
--		end if;
--	end process;
--	oneSecondPulse <= '0' when counter < x"17D7840" else '1';
	
	-- FPGA End --
	
	-- Simulatin Begin --
	oneSecondPulse <= clk_50;
	-- Simulatin End --
	
end Behavioral;