library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TestDigitalClock is
end TestDigitalClock;

architecture Behavioral of TestDigitalClock is 

    component DigitalClock
        port ( 
            clk: in std_logic; 
            rst: in std_logic; 
            H_in1: in std_logic_vector(1 downto 0);
            H_in0: in std_logic_vector(3 downto 0);
            M_in1: in std_logic_vector(3 downto 0);
            M_in0: in std_logic_vector(3 downto 0);
            H_out1: out std_logic_vector(6 downto 0);
            H_out0: out std_logic_vector(6 downto 0);
            M_out1: out std_logic_vector(6 downto 0);
            M_out0: out std_logic_vector(6 downto 0);
				S_out1: out std_logic_vector(6 downto 0);
            S_out0: out std_logic_vector(6 downto 0)
        );
    end component;

    --Inputs
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal H_in1 : std_logic_vector(1 downto 0) := (others => '0');
    signal H_in0 : std_logic_vector(3 downto 0) := (others => '0');
    signal M_in1 : std_logic_vector(3 downto 0) := (others => '0');
    signal M_in0 : std_logic_vector(3 downto 0) := (others => '0');

    --Outputs
    signal H_out1 : std_logic_vector(6 downto 0);
    signal H_out0 : std_logic_vector(6 downto 0);
    signal M_out1 : std_logic_vector(6 downto 0);
    signal M_out0 : std_logic_vector(6 downto 0);
    signal S_out1 : std_logic_vector(6 downto 0);
    signal S_out0 : std_logic_vector(6 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ps;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: DigitalClock PORT MAP (
        clk => clk,
        rst => rst,
        H_in1 => H_in1,
        H_in0 => H_in0,
        M_in1 => M_in1,
        M_in0 => M_in0,
        H_out1 => H_out1,
        H_out0 => H_out0,
        M_out1 => M_out1,
        M_out0 => M_out0,
		  S_out1 => S_out1,
        S_out0 => S_out0
    );

    -- Clock process definitions
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin 
        -- hold reset state for 100 ns.
        rst <= '0';
        H_in1 <= "01";
        H_in0 <= x"0";
        M_in1 <= x"2";
        M_in0 <= x"0";
        wait for 100 ns; 
        rst <= '1';
        wait for clk_period * 10;
        -- insert stimulus here 
        wait;
    end process;
end;