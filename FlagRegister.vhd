LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY FlagRegister IS
    PORT(
        clk: IN std_logic;
        SetC: IN std_logic;
        Int_Ret_CallFlag: IN std_logic;
        JumpAllow: IN std_logic;
        FlagsAllow: IN std_logic_vector(1 downto 0);
        JumpUpdateFlags: IN std_logic_vector(2 downto 0);
        ALUFlags : IN std_logic_vector(2 downto 0);
        Flags : OUT std_logic_vector(2 downto 0)
        );
END ENTITY FlagRegister;

ARCHITECTURE FlagRegister_arch OF FlagRegister IS
    SIGNAL temp : std_logic;
    BEGIN
        PROCESS(clk)	
        BEGIN
            IF (rising_edge(clk)) THEN
                IF (Int_Ret_CallFlag = '1') THEN
                    temp <= '0';
                ELSIF (Setc = '1') THEN
                    Flags(2) <= '1';
                ELSIF (FlagsAllow = "11") THEN
                    Flags <= ALUFlags;
                ELSIF (FlagsAllow(0) = '1') THEN
                    Flags(1 DOWNTO 0) <= ALUFlags(1 downto 0);
                ELSIF (FlagsAllow(1) = '1') THEN
                    Flags(2) <= ALUFlags(2);
                ELSIF (JumpAllow = '1') THEN
                    Flags <= JumpUpdateFlags;
                END IF;
            END IF;
        END PROCESS;
END FlagRegister_arch;	