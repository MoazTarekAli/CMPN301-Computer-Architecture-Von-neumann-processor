LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY EX_CU_Buffer IS
    PORT(
        clk: IN std_logic;
        FlushAtNextFall: IN std_logic;
        FlushNow: IN std_logic;
        Enable: IN std_logic;
        
        OutputPortAllow : IN std_logic;
        ALUOrInputSelector : IN std_logic;
        SwapSelector : IN std_logic;
        NeedFU : IN std_logic;
        SetC : IN std_logic;
        JumpAllow : IN std_logic;
        JumpType : IN std_logic_vector(1 downto 0);
        FlagsAllowUpdate : IN std_logic_vector(1 downto 0);
        EXOperandType : IN std_logic_vector(1 downto 0);
        ALUControlSignals : IN std_logic_vector(2 downto 0);

        OutputPortAllowOut : OUT std_logic;
        ALUOrInputSelectorOut : OUT std_logic;
        SwapSelectorOut : OUT std_logic;
        NeedFUOut : OUT std_logic;
        SetCOut : OUT std_logic;
        JumpAllowOut : OUT std_logic;
        JumpTypeOut : OUT std_logic_vector(1 downto 0);
        FlagsAllowUpdateOut : OUT std_logic_vector(1 downto 0);
        EXOperandTypeOut : OUT std_logic_vector(1 downto 0);
        ALUControlSignalsOut : OUT std_logic_vector(2 downto 0));
END ENTITY EX_CU_Buffer;

ARCHITECTURE EX_CU_Buffer_arch OF EX_CU_Buffer IS
    BEGIN
        PROCESS(clk, FlushAtNextFall, FlushNow)	
        BEGIN
            IF (falling_edge(clk) AND FlushAtNextFall = '1') OR FlushNow = '1' THEN
                OutputPortAllowOut <= '0';
                ALUOrInputSelectorOut <= '0';
                SwapSelectorOut <= '0';
                NeedFUOut <= '0';
                SetCOut <= '0';
                JumpAllowOut <= '0';
                JumpTypeOut <= "00";
                FlagsAllowUpdateOut <= "00";
                EXOperandTypeOut <= "00";
                ALUControlSignalsOut <= "000";
            ELSIF falling_edge(clk) AND Enable = '1' THEN
                OutputPortAllowOut <= OutputPortAllow;
                ALUOrInputSelectorOut <= ALUOrInputSelector;
                SwapSelectorOut <= SwapSelector;
                NeedFUOut <= NeedFU;
                SetCOut <= SetC;
                JumpAllowOut <= JumpAllow;
                JumpTypeOut <= JumpType;
                FlagsAllowUpdateOut <= FlagsAllowUpdate;
                EXOperandTypeOut <= EXOperandType;
                ALUControlSignalsOut <= ALUControlSignals;
            END IF;
        END PROCESS;
END EX_CU_Buffer_arch;	