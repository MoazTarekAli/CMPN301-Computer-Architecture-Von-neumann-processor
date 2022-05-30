LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Register20BitsForSP IS
    PORT(
        clk: IN std_logic;
        Reset: IN std_logic;
        enable: IN std_logic;
        InputValue: IN std_logic_vector(19 DOWNTO 0);
        StoredValue: OUT std_logic_vector(19 DOWNTO 0));
END ENTITY Register20BitsForSP;

ARCHITECTURE Register20BitsForSP_arch OF Register20BitsForSP IS
    BEGIN
        PROCESS(clk, Reset)	
        BEGIN
            IF Reset = '1' THEN
                StoredValue <= (others => '1');
            ELSIF falling_edge(clk) AND enable = '1' THEN
                StoredValue <= InputValue;
            END IF;
        END PROCESS;
END Register20BitsForSP_arch;	