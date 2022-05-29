LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Reg32 IS
    PORT(
        clk: IN std_logic;
        Reset: IN std_logic;
        enable: IN std_logic;
        InputValue: IN std_logic_vector(31 DOWNTO 0);
        StoredValue: OUT std_logic_vector(31 DOWNTO 0));
END ENTITY Reg32;

ARCHITECTURE archReg32 OF Reg32 IS
    BEGIN
        PROCESS(clk, Reset)	
        BEGIN
            IF Reset = '1' THEN
                StoredValue <= (others => '0');
                -- It doesn't matter if it was rising or falling edge as value is readed asynchronously --
            ELSIF rising_edge(clk) AND enable = '1' THEN
                StoredValue <= InputValue;
            END IF;
        END PROCESS;
END archReg32;	