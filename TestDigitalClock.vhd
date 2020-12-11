library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TestDigitalClock is
end TestDigitalClock;

architecture Behavioral of TestDigitalClock is 

    component DigitalClock
        port ( 
            clk: in std_logic; 			
            rst: in std_logic; 
            H_in: in std_logic_vector(4 downto 0);
            M_in: in std_logic_vector(5 downto 0);
            H_out: out std_logic_vector(4 downto 0);
            M_out: out std_logic_vector(5 downto 0);
            S_out: out std_logic_vector(5 downto 0)
        );
    end component;

    --Inputs
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal H_in : std_logic_vector(4 downto 0) := (others => '0');
    signal M_in : std_logic_vector(5 downto 0) := (others => '0');

    --Outputs
    signal H_out : std_logic_vector(4 downto 0);
    signal M_out : std_logic_vector(5 downto 0);
    signal S_out : std_logic_vector(5 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ps;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: DigitalClock PORT MAP (
        clk => clk,
        rst => rst,
        H_in => H_in,
        M_in => M_in,        
        H_out => H_out,
        M_out => M_out,
        S_out => S_out
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
        rst <= '1';
        -- 5 hours
        H_in <= "00101";
        -- 5 minutes
        M_in <= "000101";
        wait for 100 ns; 
        rst <= '0';
        wait for clk_period * 10;
        -- insert stimulus here 
        wait;
    end process;
end;