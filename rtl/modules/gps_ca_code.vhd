library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gps_ca_code is
    Port (
        clk_i     : in STD_LOGIC;
        rstn_i    : in STD_LOGIC;
        sv_sel_i  : in NATURAL range 1 to 37; -- Input for SV selection
        ca_chip_o : out STD_LOGIC
    );
end gps_ca_code;

architecture Behavioral of gps_ca_code is
    signal sv_sel  : NATURAL range 1 to 37;
    signal g1      : STD_LOGIC_VECTOR(10-1 downto 0);
    signal g2      : STD_LOGIC_VECTOR(10-1 downto 0);
    signal g2_taps : STD_LOGIC;
    signal count   : natural range 0 to 1023;
begin
    -- Define G2 taps based on SV number
    process(sv_sel, g2)
    begin
        case sv_sel is
            -- according to IS-GPS-200N
            when 1  => g2_taps <= g2(1) xor g2(5);
            when 2  => g2_taps <= g2(2) xor g2(6);
            when 3  => g2_taps <= g2(3) xor g2(7);
            when 4  => g2_taps <= g2(4) xor g2(8);
            when 5  => g2_taps <= g2(0) xor g2(8);
            when 6  => g2_taps <= g2(1) xor g2(9);
            when 7  => g2_taps <= g2(0) xor g2(7);
            when 8  => g2_taps <= g2(1) xor g2(8);
            when 9  => g2_taps <= g2(2) xor g2(9);
            when 10 => g2_taps <= g2(1) xor g2(2);
            when 11 => g2_taps <= g2(2) xor g2(3);
            when 12 => g2_taps <= g2(4) xor g2(5);
            when 13 => g2_taps <= g2(5) xor g2(6);
            when 14 => g2_taps <= g2(6) xor g2(7);
            when 15 => g2_taps <= g2(7) xor g2(8);
            when 16 => g2_taps <= g2(8) xor g2(9);
            when 17 => g2_taps <= g2(0) xor g2(3);
            when 18 => g2_taps <= g2(1) xor g2(4);
            when 19 => g2_taps <= g2(2) xor g2(5);
            when 20 => g2_taps <= g2(3) xor g2(6);
            when 21 => g2_taps <= g2(4) xor g2(7);
            when 22 => g2_taps <= g2(5) xor g2(8);
            when 23 => g2_taps <= g2(0) xor g2(2);
            when 24 => g2_taps <= g2(3) xor g2(5);
            when 25 => g2_taps <= g2(4) xor g2(6);
            when 26 => g2_taps <= g2(5) xor g2(7);
            when 27 => g2_taps <= g2(6) xor g2(8);
            when 28 => g2_taps <= g2(7) xor g2(9);
            when 29 => g2_taps <= g2(0) xor g2(5);
            when 30 => g2_taps <= g2(1) xor g2(6);
            when 31 => g2_taps <= g2(2) xor g2(7);
            when 32 => g2_taps <= g2(3) xor g2(8);
            when 33 => g2_taps <= g2(4) xor g2(9);
            when 34 => g2_taps <= g2(3) xor g2(9);
            when 35 => g2_taps <= g2(0) xor g2(6);
            when 36 => g2_taps <= g2(1) xor g2(7);
            when 37 => g2_taps <= g2(3) xor g2(9);
            when others => g2_taps <= g2(0) xor g2(1);
        end case;
    end process;

    process(clk_i, rstn_i)
    begin
        if rstn_i = '0' then
            sv_sel <= 1;
            g1 <= (others => '1');
            g2 <= (others => '1');
            count <= 0;
            ca_chip_o <= '0';
        elsif rising_edge(clk_i) then
            if sv_sel /= sv_sel_i then
                sv_sel <= sv_sel_i;
                g1 <= (others => '1');
                g2 <= (others => '1');
                count <= 0;
                ca_chip_o <= '0';
            else
                -- LFSR Polynomial G1: 1 + x^3 + x^10
                g1 <= g1(8 downto 0) & (g1(2) xor g1(9));

                -- LFSR Polynomial G2: 1 + x^2 + x^3 + x^6 + x^8 + x^9 + x^10
                g2 <= g2(8 downto 0) & (g2(1) xor g2(2) xor g2(5) xor g2(7) xor g2(8) xor g2(9));

                ca_chip_o <= g1(9) xor g2_taps;
                if count < 1023 then
                    count <= count + 1;
                else
                    count <= 1;
                end if;
            end if;
        end if;
    end process;

end Behavioral;

