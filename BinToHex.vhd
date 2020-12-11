library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Bin to HEX For 7-segment LEDs display 
entity BinToHex is
	port (
		B_in: in std_logic_vector(3 downto 0);
		H_out: out std_logic_vector(6 downto 0)
	);
end BinToHex;

architecture Behavioral of BinToHex is
begin
    process (B_in)
    begin
        case (B_in) is
            when "0000" =>  H_out <= "1000000"; --0--
            when "0001" =>  H_out <= "1111001"; --1--
            when "0010" =>  H_out <= "0100100"; --2--
            when "0011" =>  H_out <= "0110000"; --3--
            when "0100" =>  H_out <= "0011001"; --4-- 
            when "0101" =>  H_out <= "0010010"; --5--    
            when "0110" =>  H_out <= "0000010"; --6--
            when "0111" =>  H_out <= "1111000"; --7--   
            when "1000" =>  H_out <= "0000000"; --8--
            when "1001" =>  H_out <= "0010000"; --9--
            when "1010" =>  H_out <= "0001000"; --a--
            when "1011" =>  H_out <= "0000011"; --b--
            when "1100" =>  H_out <= "1000110"; --c--
            when "1101" =>  H_out <= "0100001"; --d--
            when "1110" =>  H_out <= "0000110"; --e--
            when others =>  H_out <= "0001110"; 
        end case;
    end process;
end Behavioral;