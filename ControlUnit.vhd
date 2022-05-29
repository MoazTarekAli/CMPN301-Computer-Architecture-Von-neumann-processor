LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ControlUnit IS
	PORT(
        Clk : IN STD_LOGIC;
        InterruptFlag : IN STD_LOGIC;
        ResetFlag : IN STD_LOGIC;
        FlushFrom_HU : IN STD_LOGIC;
        DelayFrom_HU : IN STD_LOGIC;
        OPCode : IN STD_LOGIC_VECTOR(4 downto 0);

        -- HU Signals
        HLTFlag : OUT std_logic;
        SwapOrInterruptDelay : OUT std_logic;
        
        -- Ex Signals
        OutputPortAllow : OUT std_logic;
        ALUOrInputSelector : OUT std_logic;
        SwapSelector : OUT std_logic;
        NeedFU : OUT std_logic;
        SetC : OUT std_logic;
        JumpAllow : OUT std_logic;
        JumpType : OUT std_logic_vector(1 downto 0);
        FlagsAllowUpdate : OUT std_logic_vector(1 downto 0);
        EXOperandType : OUT std_logic_vector(1 downto 0);
        ALUControlSignals : OUT std_logic_vector(2 downto 0);

        -- MEM Signals
        SPSelector : OUT std_logic;
        PushOrPopSelector : OUT std_logic;
        CallOrReturnSelector : OUT std_logic;
        MemoryRead : OUT std_logic;
        MemoryWrite : OUT std_logic;
        AddressSelector : OUT std_logic_vector(1 downto 0);
        WriteDateSelector : OUT std_logic;
        InterruptOrCallOrReturn : OUT std_logic;
        
        -- WB Signals
        RegWriteFlag : OUT std_logic;
        MEMDataOrEXResultSelector : OUT std_logic);
END ENTITY ControlUnit;

ARCHITECTURE ControlUnit_arch OF ControlUnit IS
    BEGIN
    PROCESS (Clk, DelayFrom_HU, FlushFrom_HU, ResetFlag)
        VARIABLE SWAPState, InterruptState : std_logic:= '0';
    BEGIN
        IF (ResetFlag = '1' OR FlushFrom_HU = '1') THEN
            -- Reseting States
            SWAPState := '0';
            InterruptState := '0';
            -- HU SIgnals
            HLTFlag <= '0';
            SwapOrInterruptDelay <= '0';
            -- Ex Signals
            OutputPortAllow <= '0';
            ALUOrInputSelector <= '0';
            SwapSelector <= '0';
            NeedFU <= '0';
            SetC <= '0';
            JumpAllow <= '0';
            JumpType <= "00";
            FlagsAllowUpdate <= "00";
            EXOperandType <= "00";
            ALUControlSignals <= "000";
            -- MEM Signals
            SPSelector <= '0';
            PushOrPopSelector <= '0';
            CallOrReturnSelector <= '0';
            MemoryRead <= '0';
            MemoryWrite <= '0';
            AddressSelector <= "00";
            WriteDateSelector <= '0';
            InterruptOrCallOrReturn <= '0';
            -- WB Signals
            RegWriteFlag <= '0';
            MEMDataOrEXResultSelector <= '0';

        ELSIF (rising_edge(Clk) and DelayFrom_HU = '0') THEN
            ------ One Operand ------
            -- NOP
            IF (OPcode = "00000") THEN 
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '0';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "000";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '0';
                MEMDataOrEXResultSelector <= '0';
            -- HLT
            ELSIF (OPcode = "00001") THEN 
                -- HU SIgnals
                HLTFlag <= '1';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '0';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "000";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '0';
                MEMDataOrEXResultSelector <= '0';
            -- SETC
            ELSIF (OPcode = "00010") THEN 
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '0';
                SetC <= '1';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "000";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '0';
                MEMDataOrEXResultSelector <= '0';
            -- NOT Rdst
            ELSIF (OPcode = "00011") THEN 
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "01";
                EXOperandType <= "00";
                ALUControlSignals <= "100";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '1';
                MEMDataOrEXResultSelector <= '0'; -- ExResult is 0
            -- INC Rdst
            ELSIF (OPcode = "00100") THEN 
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "11";
                EXOperandType <= "00";
                ALUControlSignals <= "101";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '1';
                MEMDataOrEXResultSelector <= '0'; -- ExResult is 0
            -- OUT RDST
            ELSIF (OPcode = "00101") THEN 
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '1';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "000";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '0';
                MEMDataOrEXResultSelector <= '0';
            -- IN RDST
            ELSIF (OPcode = "00110") THEN 
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '1';
                SwapSelector <= '0';
                NeedFU <= '0';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "000";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '1';
                MEMDataOrEXResultSelector <= '0';
            ------ TWO Operands ------
            -- MOV Rsrc, Rdst
            ELSIF (OPcode = "01000") THEN 
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "000";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '1';
                MEMDataOrEXResultSelector <= '0';
            -- Swap Rsrc, Rdst First Cycle Write in Rdst
            ELSIF (OPcode = "01001" AND SWAPState = '0') THEN
                SWAPState := '1'; 
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '1';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "111";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '1';
                MEMDataOrEXResultSelector <= '0';
            -- Swap Rsrc, Rdst Second Cycle Write in Rsrc
            ELSIF (OPcode = "01001" AND SWAPState = '1') THEN
                SWAPState := '0'; 
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '1';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "000";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '1';
                MEMDataOrEXResultSelector <= '0';
            -- ADD Rdst, Rscr1, Rscrc2
            ELSIF (OPcode = "01010") THEN
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "11";
                EXOperandType <= "00";
                ALUControlSignals <= "001";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '1';
                MEMDataOrEXResultSelector <= '0';
            -- SUB Rdst, Rscr1, Rscrc2
            ELSIF (OPcode = "01011") THEN
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "11";
                EXOperandType <= "00";
                ALUControlSignals <= "010";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '1';
                MEMDataOrEXResultSelector <= '0';
            -- AND Rdst, Rscr1, Rscrc2
            ELSIF (OPcode = "01100") THEN
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "01";
                EXOperandType <= "00";
                ALUControlSignals <= "011";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '1';
                MEMDataOrEXResultSelector <= '0';
            -- IADD Rdst, Rscr1, Rscrc2
            ELSIF (OPcode = "01101") THEN
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "11";
                EXOperandType <= "10";
                ALUControlSignals <= "001";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '1';
                MEMDataOrEXResultSelector <= '0';
            ------ MEMORY operations ------
            -- PUSH Rdst
            ELSIF (OPcode = "10000") THEN
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "000";
                -- MEM Signals
                SPSelector <= '1';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '1';
                AddressSelector <= "10"; -- Final SP
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '0';
                MEMDataOrEXResultSelector <= '0';
            -- POP Rdst
            ELSIF (OPcode = "10001") THEN
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '0';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "000";
                -- MEM Signals
                SPSelector <= '1';
                PushOrPopSelector <= '1';
                CallOrReturnSelector <= '0';
                MemoryRead <= '1';
                MemoryWrite <= '0';
                AddressSelector <= "10"; -- Final SP
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '1';
                MEMDataOrEXResultSelector <= '1';
            -- LDM Rdst
            ELSIF (OPcode = "10010") THEN
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "10";
                ALUControlSignals <= "111";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '1';
                MemoryWrite <= '0';
                AddressSelector <= "01"; -- EX Result
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '1';
                MEMDataOrEXResultSelector <= '1';
            -- LDD Rdst
            ELSIF (OPcode = "10011") THEN
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "10";
                ALUControlSignals <= "001";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '1';
                MemoryWrite <= '0';
                AddressSelector <= "01"; -- EX Result
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '1';
                MEMDataOrEXResultSelector <= '1';
            -- STD Rdst
            ELSIF (OPcode = "10100") THEN
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '1';
                SetC <= '0';
                JumpAllow <= '0';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "11";
                ALUControlSignals <= "001";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '1';
                AddressSelector <= "01"; -- EX Result
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '0';
                MEMDataOrEXResultSelector <= '0';
            ------ BRANCH operations ------
            -- JZ Imm
            ELSIF (OPcode = "11000") THEN
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '0';
                SetC <= '0';
                JumpAllow <= '1';
                JumpType <= "00";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "000";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '0';
                MEMDataOrEXResultSelector <= '0';
            -- JN Imm
            ELSIF (OPcode = "11001") THEN
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '0';
                SetC <= '0';
                JumpAllow <= '1';
                JumpType <= "01";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "000";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '0';
                MEMDataOrEXResultSelector <= '0';
            -- JC Imm
            ELSIF (OPcode = "11010") THEN
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '0';
                SetC <= '0';
                JumpAllow <= '1';
                JumpType <= "10";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "000";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '0';
                MEMDataOrEXResultSelector <= '0';
            -- JMP Imm
            ELSIF (OPcode = "11011") THEN
                -- HU SIgnals
                HLTFlag <= '0';
                SwapOrInterruptDelay <= '0';
                -- Ex Signals
                OutputPortAllow <= '0';
                ALUOrInputSelector <= '0';
                SwapSelector <= '0';
                NeedFU <= '0';
                SetC <= '0';
                JumpAllow <= '1';
                JumpType <= "11";
                FlagsAllowUpdate <= "00";
                EXOperandType <= "00";
                ALUControlSignals <= "000";
                -- MEM Signals
                SPSelector <= '0';
                PushOrPopSelector <= '0';
                CallOrReturnSelector <= '0';
                MemoryRead <= '0';
                MemoryWrite <= '0';
                AddressSelector <= "00";
                WriteDateSelector <= '0';
                InterruptOrCallOrReturn <= '0';
                -- WB Signals
                RegWriteFlag <= '0';
                MEMDataOrEXResultSelector <= '0';
            -- Call Imm
            END IF;
        END IF;
    END PROCESS;
END ControlUnit_arch;
