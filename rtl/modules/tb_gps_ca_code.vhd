library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_gps_ca_code is
-- Testbench does not have any input or output ports
end tb_gps_ca_code;

architecture Behavioral of tb_gps_ca_code is

    -- Component Declaration for the Unit Under Test (UUT)
    component gps_ca_code
    port (
        clk_i : in STD_LOGIC;
        rstn_i : in STD_LOGIC;
        sv_sel_i : in INTEGER range 1 to 37;
        ca_chip_o : out STD_LOGIC
    );
    end component;

    -- Inputs
    signal clk_i : STD_LOGIC := '0';
    signal rstn_i : STD_LOGIC := '0';
    signal sv_sel_i : INTEGER range 1 to 37 := 1;

    -- Outputs
    signal ca_chip_o : STD_LOGIC;

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: gps_ca_code port map (
        clk_i => clk_i,
        rstn_i => rstn_i,
        sv_sel_i => sv_sel_i,
        ca_chip_o => ca_chip_o
    );

    -- Clock process definitions
    clk_process :process
    begin
        clk_i <= '0';
        wait for clk_period/2;
        clk_i <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the system
        rstn_i <= '0';
        wait for 20 ns;
        rstn_i <= '1';

        -- Test for different SV selections
        for i in 1 to 37 loop
            sv_sel_i <= i;
            wait for 1024 * clk_period; -- Wait for one full C/A code sequence
        end loop;

        -- End simulation
        wait;
    end process;

end Behavioral;

