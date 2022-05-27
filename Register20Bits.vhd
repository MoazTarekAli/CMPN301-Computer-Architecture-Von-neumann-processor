LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Register20Bits IS
    PORT(
        clk: IN std_logic;
        Reset: IN std_logic;
        enable: IN std_logic;
        InputValue: IN std_logic_vector(19 DOWNTO 0);
        StoredValue: OUT std_logic_vector(19 DOWNTO 0));
END ENTITY Register20Bits;

ARCHITECTURE Register20Bits_arch OF Register20Bits IS
    BEGIN
        PROCESS(clk, Reset)	
        BEGIN
            IF Reset = '1' THEN
                StoredValue <= (others => '0');
            ELSIF falling_edge(clk) AND enable = '1' THEN
                StoredValue <= InputValue;
            END IF;
        END PROCESS;
END Register20Bits_arch;	