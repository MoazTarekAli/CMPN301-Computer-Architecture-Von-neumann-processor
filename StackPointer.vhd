LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY StackPointer IS
    PORT(
        clk: IN std_logic;
        Reset: IN std_logic;
        PushOrPopSelector: IN std_logic;
        SPSelector: IN std_logic;
        SPToMemory: OUT std_logic_vector(19 DOWNTO 0));
END ENTITY StackPointer;

ARCHITECTURE StackPointer_arch OF StackPointer IS
    COMPONENT Register20Bits IS
    PORT(
        clk: IN std_logic;
        Reset: IN std_logic;
        enable: IN std_logic;
        InputValue: IN std_logic_vector(19 DOWNTO 0);
        StoredValue: OUT std_logic_vector(19 DOWNTO 0));
    END COMPONENT Register20Bits;

    SIGNAL NewSP : std_logic_vector(19 DOWNTO 0) := (others => '1');
    SIGNAL SP : std_logic_vector(19 DOWNTO 0) := (others => '0');

    BEGIN
        SP_Buffer: Register20Bits PORT MAP (clk => clk, Reset => Reset, enable => SPSelector, InputValue => NewSP, StoredValue => SP);
        -- push is 0 
        NewSP <= std_logic_vector(unsigned(SP) - 1) WHEN PushOrPopSelector = '0'
        ELSE std_logic_vector(unsigned(SP) + 1);

        SPToMemory <= SP WHEN PushOrPopSelector = '0'
        ELSE std_logic_vector(unsigned(SP) + 1);
        
END StackPointer_arch;	 