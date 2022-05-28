LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY ProgramCounter IS
    PORT(
        clk: IN std_logic;
        Reset: IN std_logic;
        Interrupt: IN std_logic;
        CallRetSelector: IN std_logic;
        PCSelector: IN std_logic_vector(1 downto 0);
        MemoryInstructionReset : IN std_logic_vector(31 downto 0);
        IMMFromEXForJumping : IN std_logic_vector(31 downto 0);
        IMMFromMEMForCall : IN std_logic_vector(31 downto 0);
        ReadDataFromMEM: IN std_logic_vector(31 downto 0);
        PCToBeStoredInInterrupts: OUT std_logic_vector(19 DOWNTO 0);
        PCToMemory: OUT std_logic_vector(19 DOWNTO 0));
END ENTITY ProgramCounter;

ARCHITECTURE ProgramCounter_arch OF ProgramCounter IS
    COMPONENT Register20Bits IS
    PORT(
        clk: IN std_logic;
        Reset: IN std_logic;
        enable: IN std_logic;
        InputValue: IN std_logic_vector(19 DOWNTO 0);
        StoredValue: OUT std_logic_vector(19 DOWNTO 0));
    END COMPONENT Register20Bits;

    SIGNAL NewPC : std_logic_vector(19 DOWNTO 0) := (others => '0');
    SIGNAL PCToStore : std_logic_vector(19 DOWNTO 0);
    SIGNAL PC : std_logic_vector(19 DOWNTO 0);

    BEGIN
        PC_Buffer: Register20Bits PORT MAP (clk => clk, Reset => '0', enable => '1', InputValue => PCToStore, StoredValue => PC);
        
        NewPC <= std_logic_vector(unsigned(PC) + 1) WHEN PCSelector = "00"
        ELSE IMMFromEXForJumping(19 DOWNTO 0) WHEN PCSelector = "01"
        ELSE IMMFromMEMForCall(19 DOWNTO 0) WHEN PCSelector = "10" and CallRetSelector = '0'
        ELSE ReadDataFromMEM(19 DOWNTO 0) WHEN PCSelector = "10" and CallRetSelector = '1'
        ELSE PC;

        PCToStore <= MemoryInstructionReset(19 DOWNTO 0) WHEN Reset = '1'
        ELSE NewPC;

        PCToMemory <= NewPC;    

        PCToBeStoredInInterrupts <= PC WHEN Interrupt = '1'
        ELSE std_logic_vector(unsigned(PC) + 1);
END ProgramCounter_arch;	 