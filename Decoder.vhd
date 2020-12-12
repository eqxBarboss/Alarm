----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:44:01 12/12/2020 
-- Design Name: 
-- Module Name:    Decoder - Behavioral 
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

entity Decoder is
	port (
		Encoded: in std_logic_vector(3 downto 0);
		Decoded: out std_logic_vector(6 downto 0)
	);
end Decoder;

architecture Behavioral of Decoder is
   constant Dig0: std_logic_vector(6 downto 0) := "0000001";
	constant Dig1: std_logic_vector(6 downto 0) := "1001111";
	constant Dig2: std_logic_vector(6 downto 0) := "0010010";
	constant Dig3: std_logic_vector(6 downto 0) := "0000110";
	constant Dig4: std_logic_vector(6 downto 0) := "1001100";
	constant Dig5: std_logic_vector(6 downto 0) := "0100100";
	constant Dig6: std_logic_vector(6 downto 0) := "0100000";
	constant Dig7: std_logic_vector(6 downto 0) := "0001111";
	constant Dig8: std_logic_vector(6 downto 0) := "0000000";
	constant Dig9: std_logic_vector(6 downto 0) := "0000100";
	constant DigA: std_logic_vector(6 downto 0) := "0001000";
	constant Empty: std_logic_vector(6 downto 0) := "1111111";
begin
	with Encoded select Decoded <=
		Dig0 when "0000",
		Dig1 when "0001",
		Dig2 when "0010",
		Dig3 when "0011",
		Dig4 when "0100",
		Dig5 when "0101",
		Dig6 when "0110",
		Dig7 when "0111",
		Dig8 when "1000",
		Dig9 when "1001",
		DigA when "1010",
		Empty when others;	 
end Behavioral;

