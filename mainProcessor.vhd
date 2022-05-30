LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY mainProcessor IS
    PORT(
        Clk : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        Interrupt : IN STD_LOGIC;
        InputPort : IN STD_LOGIC_VECTOR(31 downto 0);
        OutputPort : OUT STD_LOGIC_VECTOR(31 downto 0)
        );
END ENTITY mainProcessor;

ARCHITECTURE mainProcessor_arch OF mainProcessor IS
-- Fetch Stage
COMPONENT ProgramCounter IS
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
END COMPONENT ProgramCounter;
-- Hazard Detection Unit
COMPONENT HazardDetectionUnit IS
	PORT(
        HLTFlag : IN std_logic;
        Reset : IN std_logic;
        SwapOrInterruptDelay : IN std_logic;
        JumpFlag : IN std_logic;
        MEM_Read : IN std_logic;
        MEM_Write : IN std_logic;
        Call_Ret_IntFlag : IN std_logic;
        NeedFUFlag : IN std_logic;
        Rsrc1_EX : IN std_logic_vector(2 DOWNTO 0);
        Rsrc2_EX : IN std_logic_vector(2 DOWNTO 0);
        Rdst_MEM : IN std_logic_vector(2 DOWNTO 0);
        
        PCSelector : OUT std_logic_vector(1 DOWNTO 0);
        -- These Signals represent FlushAtNextFall, FlushNow, Enable
        IF_ID_Signals : OUT std_logic_vector(2 DOWNTO 0);
        ID_EX_Signals : OUT std_logic_vector(2 DOWNTO 0);
        EX_MEM_Signals : OUT std_logic_vector(2 DOWNTO 0);

        CU_Flush : OUT std_logic;
        CU_Delay : OUT std_logic);
END COMPONENT HazardDetectionUnit;
-- Control Unit
COMPONENT ControlUnit IS
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
END COMPONENT ControlUnit;
-- Memory
COMPONENT Memory IS
	PORT(
		clk         : IN std_logic;
		WriteEnable : IN std_logic;
		ReadEnable  : IN std_logic;
		Reset       : IN std_logic; 
		address     : IN  std_logic_vector(19 DOWNTO 0);
        ProgramCounter : IN  std_logic_vector(19 DOWNTO 0);
		datain      : IN  std_logic_vector(31 DOWNTO 0);
		dataout     : OUT std_logic_vector(31 DOWNTO 0);
        Intruction  : OUT std_logic_vector(31 DOWNTO 0));
END COMPONENT Memory;
-- IF/ID Buffer
COMPONENT IF_IDBuffer IS
    PORT(
        clk: IN std_logic;
        FlushAtNextFall: IN std_logic;
        FlushNow: IN std_logic;
        Enable: IN std_logic;
        InterruptFlag : IN std_logic;
        InputPort: IN std_logic_vector(31 DOWNTO 0);
        PC : IN std_logic_vector(19 DOWNTO 0);
        Instruction : IN std_logic_vector(31 DOWNTO 0);
        
        OpCode : OUT std_logic_vector(4 DOWNTO 0);
        PCOut : OUT std_logic_vector(19 DOWNTO 0);
        InterruptFlagOut : OUT std_logic;
        Rsrc1 : OUT std_logic_vector(2 DOWNTO 0);
        Rsrc2 : OUT std_logic_vector(2 DOWNTO 0);
        Rdst : OUT std_logic_vector(2 DOWNTO 0);
        Immediate : OUT std_logic_vector(31 DOWNTO 0);
        InputPortOut : OUT std_logic_vector(31 DOWNTO 0));
END COMPONENT IF_IDBuffer;
-- Registers
COMPONENT Registers IS
	PORT(
        clk : IN std_logic;
        Reset : IN std_logic;
        RegWriteFlag : IN std_logic;
		Rsrc1 : IN std_logic_vector(2 DOWNTO 0);
        Rsrc2 : IN std_logic_vector(2 DOWNTO 0);
        Rdst  : IN std_logic_vector(2 DOWNTO 0);
        RegWriteData : IN std_logic_vector(31 DOWNTO 0);
        ReadData1 : OUT std_logic_vector(31 DOWNTO 0);
        ReadData2 : OUT std_logic_vector(31 DOWNTO 0));
END COMPONENT Registers;
-- ID/EX Buffer
COMPONENT ID_EXBuffer IS
    PORT(
        clk: IN std_logic;
        FlushAtNextFall: IN std_logic;
        FlushNow: IN std_logic;
        Enable: IN std_logic;

        ReadData1 : IN std_logic_vector(31 downto 0);
        ReadData2 : IN std_logic_vector(31 downto 0);
        Immediate : IN std_logic_vector(31 DOWNTO 0);
        InputPort : IN std_logic_vector(31 DOWNTO 0);
        PC : IN std_logic_vector(19 DOWNTO 0);
        Rsrc1 : IN std_logic_vector(2 DOWNTO 0);
        Rsrc2 : IN std_logic_vector(2 DOWNTO 0);
        Rdst : IN std_logic_vector(2 DOWNTO 0);
        
        ReadData1Out : OUT std_logic_vector(31 downto 0);
        ReadData2Out : OUT std_logic_vector(31 downto 0);
        ImmediateOut : OUT std_logic_vector(31 DOWNTO 0);
        InputPortOut : OUT std_logic_vector(31 DOWNTO 0);
        PCOut: OUT std_logic_vector(19 DOWNTO 0);
        Rsrc1Out : OUT std_logic_vector(2 DOWNTO 0);
        Rsrc2Out : OUT std_logic_vector(2 DOWNTO 0);
        RdstOut : OUT std_logic_vector(2 DOWNTO 0));
END COMPONENT ID_EXBuffer;
-- EX_CU Buffer
COMPONENT EX_CU_Buffer IS
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
END COMPONENT EX_CU_Buffer;
-- MEM_CU Buffer
COMPONENT MEM_CU_Buffer IS
    PORT(
        clk: IN std_logic;
        FlushAtNextFall: IN std_logic;
        FlushNow: IN std_logic;
        Enable: IN std_logic;
        
        SPSelector : IN std_logic;
        PushOrPopSelector : IN std_logic;
        CallOrReturnSelector : IN std_logic;
        MemoryRead : IN std_logic;
        MemoryWrite : IN std_logic;
        AddressSelector : IN std_logic_vector(1 downto 0);
        WriteDateSelector : IN std_logic;
        InterruptOrCallOrReturn : IN std_logic;
        
        SPSelectorOut : OUT std_logic;
        PushOrPopSelectorOut : OUT std_logic;
        CallOrReturnSelectorOut : OUT std_logic;
        MemoryReadOut : OUT std_logic;
        MemoryWriteOut : OUT std_logic;
        AddressSelectorOut : OUT std_logic_vector(1 downto 0);
        WriteDateSelectorOut : OUT std_logic;
        InterruptOrCallOrReturnOut : OUT std_logic);
END COMPONENT MEM_CU_Buffer;
-- WB_CU Buffer
COMPONENT WB_CU_Buffer IS
    PORT(
        clk: IN std_logic;
        FlushAtNextFall: IN std_logic;
        FlushNow: IN std_logic;
        Enable: IN std_logic;
        
        RegWriteFlag : IN std_logic;
        MEMDataOrEXResultSelector : IN std_logic;
        
        RegWriteFlagOut : OUT std_logic;
        MEMDataOrEXResultSelectorOut : OUT std_logic);
END COMPONENT WB_CU_Buffer;
-- Execution Stage
COMPONENT ExecutionStageALU IS
    PORT(
        Rsrc1 : IN std_logic_vector(2 downto 0);
        Rdst : IN std_logic_vector(2 downto 0);
        SwapSelector : IN std_logic;
        InputPort : IN std_logic_vector(31 downto 0);
        Rdata1 : IN std_logic_vector(31 downto 0);
        Rdata2 : IN std_logic_vector(31 downto 0);
        Immediate : IN std_logic_vector(31 downto 0);
        ExexutionResultInMemory : IN std_logic_vector(31 downto 0);
        MemoryResultInWriteBack : IN std_logic_vector(31 downto 0);
        FuFirstOperandSelector : IN std_logic_vector(1 downto 0);
        FuSecondOperandSelector : IN std_logic_vector(1 downto 0);
        EXOperandsSelector : IN std_logic_vector(1 downto 0);
        ALUControlSignals : IN std_logic_vector(2 downto 0);
        ALUorInputSelector : IN std_logic;

        FinalRdst: OUT std_logic_vector(2 downto 0);
        EXResult : OUT std_logic_vector(31 downto 0);
        FUdata1Mem : OUT std_logic_vector(31 downto 0);
        FLags : OUT std_logic_vector(2 downto 0)
        );
END COMPONENT ExecutionStageALU;
-- Flag Register 
COMPONENT FlagRegister IS
    PORT(
        clk: IN std_logic;
        Reset : IN std_logic;
        SetC: IN std_logic;
        Int_Ret_CallFlag: IN std_logic;
        JumpAllow: IN std_logic;
        FlagsAllow: IN std_logic_vector(1 downto 0);
        JumpUpdateFlags: IN std_logic_vector(2 downto 0);
        ALUFlags : IN std_logic_vector(2 downto 0);
        Flags : OUT std_logic_vector(2 downto 0)
        );
END COMPONENT FlagRegister;
-- Jump Unit
COMPONENT JumpUnit IS
    PORT(
        JumpAllow: IN std_logic;
        JumpType : IN std_logic_vector(1 downto 0);
        Flags: IN std_logic_vector(2 downto 0);
        UpdatedFlags : OUT std_logic_vector(2 downto 0);
        JumpFlag : OUT std_logic
        );
END COMPONENT JumpUnit;
-- EX/MEM Buffer
COMPONENT EX_MEMBuffer IS
    PORT(
        clk: IN std_logic;
        FlushAtNextFall: IN std_logic;
        FlushNow: IN std_logic;
        Enable: IN std_logic;

        ReadData1 : IN std_logic_vector(31 downto 0);
        EXResult : IN std_logic_vector(31 DOWNTO 0);
        PC : IN std_logic_vector(19 DOWNTO 0);
        Flags : IN std_logic_vector(2 DOWNTO 0);
        Rdst : IN std_logic_vector(2 DOWNTO 0);
        
        ReadData1Out : OUT std_logic_vector(31 downto 0);
        EXResultOut : OUT std_logic_vector(31 DOWNTO 0);
        FlagsConcatenatedPCOut: OUT std_logic_vector(31 DOWNTO 0);
        RdstOut : OUT std_logic_vector(2 DOWNTO 0));
END COMPONENT EX_MEMBuffer;
-- Stack Pointer
COMPONENT StackPointer IS
    PORT(
        clk: IN std_logic;
        Reset: IN std_logic;
        PushOrPopSelector: IN std_logic;
        SPSelector: IN std_logic;
        SPToMemory: OUT std_logic_vector(19 DOWNTO 0));
END COMPONENT StackPointer;
-- MEM/WB Buffer
COMPONENT MEM_WBBuffer IS
    PORT(
        clk: IN std_logic;
        FlushAtNextFall: IN std_logic;
        FlushNow: IN std_logic;
        Enable: IN std_logic;

        DataMemory : IN std_logic_vector(31 downto 0);
        EXResult : IN std_logic_vector(31 DOWNTO 0);
        Rdst : IN std_logic_vector(2 DOWNTO 0);
        
        EXResultOut : OUT std_logic_vector(31 DOWNTO 0);
        DataMemoryOut : OUT std_logic_vector(31 DOWNTO 0);
        RdstOut : OUT std_logic_vector(2 DOWNTO 0));
END COMPONENT MEM_WBBuffer;
-- Forawrding Unit
COMPONENT ForwardingUnit IS
	PORT(
        needFUFlag : IN STD_LOGIC;
        RegWriteFlagInMEM : IN std_logic;
        RegWriteFlagInWB : IN std_logic;
        SwapSelector : IN std_logic;
		Rsrc1 : IN std_logic_vector(2 DOWNTO 0);
        Rsrc2 : IN std_logic_vector(2 DOWNTO 0);
        RdstMEM : IN std_logic_vector(2 DOWNTO 0);
        RdstWB : IN std_logic_vector(2 DOWNTO 0);

        FUFirstOperand : OUT std_logic_vector(1 DOWNTO 0);
        FUSecondOperand : OUT std_logic_vector(1 DOWNTO 0));
END COMPONENT ForwardingUnit;

-- END

SIGNAL Memory_Address : std_logic_vector(19 DOWNTO 0) := (others=>'0');
SIGNAL Memory_Write_Data : std_logic_vector(31 DOWNTO 0) := (others=>'0');

SIGNAL FINAL_WB : std_logic_vector(31 DOWNTO 0) := (others=>'0');

-- Program Counter Signals Out
    SIGNAL PC_To_Memory : std_logic_vector(19 DOWNTO 0);
    SIGNAL PC_To_IF_ID_Buffer : std_logic_vector(19 DOWNTO 0);

-- Memory Signals Out
    SIGNAL Memory_DataOut : std_logic_vector(31 DOWNTO 0);
    SIGNAL Memory_Instruction : std_logic_vector(31 DOWNTO 0);

-- IF/ID Buffer Out
    SIGNAL IF_ID_Buffer_PCOut : std_logic_vector(19 DOWNTO 0);
    SIGNAL IF_ID_Buffer_OpCode : std_logic_vector(4 DOWNTO 0);
    SIGNAL IF_ID_Buffer_InterruptFlag : std_logic;
    SIGNAL IF_ID_Buffer_Rsrc1 : std_logic_vector(2 DOWNTO 0);
    SIGNAL IF_ID_Buffer_Rsrc2 : std_logic_vector(2 DOWNTO 0);
    SIGNAL IF_ID_Buffer_Rdst : std_logic_vector(2 DOWNTO 0);
    SIGNAL IF_ID_Buffer_Immediate : std_logic_vector(31 DOWNTO 0);
    SIGNAL IF_ID_Buffer_InputPort : std_logic_vector(31 DOWNTO 0);

-- Hazard Detection Unit Signals Out
    SIGNAL HDU_PC_Selector : std_logic_vector(1 DOWNTO 0);
    SIGNAL HDU_IF_ID_Signals : std_logic_vector(2 DOWNTO 0);
    SIGNAL HDU_ID_EX_Signals : std_logic_vector(2 DOWNTO 0);
    SIGNAL HDU_EX_MEM_Signals : std_logic_vector(2 DOWNTO 0);
    SIGNAL HDU_CU_Flush : std_logic;
    SIGNAL HDU_CU_Delay : std_logic;

-- Registers Signals Out
    SIGNAL Registers_ReadData1 : std_logic_vector(31 DOWNTO 0);
    SIGNAL Registers_ReadData2 : std_logic_vector(31 DOWNTO 0);
-- Control Unit Signals Out
    SIGNAL CU_HLTFlag : std_logic;
    SIGNAL CU_SwapOrInterruptDelay : std_logic;
        -- Ex Signals
    SIGNAL CU_OutputPortAllow : std_logic;
    SIGNAL CU_ALUOrInputSelector : std_logic;
    SIGNAL CU_SwapSelector : std_logic;
    SIGNAL CU_NeedFU : std_logic;
    SIGNAL CU_SetC : std_logic;
    SIGNAL CU_JumpAllow : std_logic;
    SIGNAL CU_JumpType : std_logic_vector(1 downto 0);
    SIGNAL CU_FlagsAllowUpdate : std_logic_vector(1 downto 0);
    SIGNAL CU_EXOperandType : std_logic_vector(1 downto 0);
    SIGNAL CU_ALUControlSignals : std_logic_vector(2 downto 0);

        -- MEM Signals
    SIGNAL CU_SPSelector : std_logic;
    SIGNAL CU_PushOrPopSelector : std_logic;
    SIGNAL CU_CallOrReturnSelector : std_logic;
    SIGNAL CU_MemoryRead : std_logic;
    SIGNAL CU_MemoryWrite : std_logic;
    SIGNAL CU_AddressSelector : std_logic_vector(1 downto 0);
    SIGNAL CU_WriteDateSelector : std_logic;
    SIGNAL CU_InterruptOrCallOrReturn : std_logic;
        
        -- WB Signals
    SIGNAL CU_RegWriteFlag : std_logic;
    SIGNAL CU_MEMDataOrEXResultSelector : std_logic;
-- ID/EX Signals Out
    SIGNAL ID_EX_Buffer_ReadData1Out : std_logic_vector(31 downto 0);
    SIGNAL ID_EX_Buffer_ReadData2Out : std_logic_vector(31 downto 0);
    SIGNAL ID_EX_Buffer_ImmediateOut : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_EX_Buffer_InputPortOut : std_logic_vector(31 DOWNTO 0);
    SIGNAL ID_EX_Buffer_PCOut: std_logic_vector(19 DOWNTO 0);
    SIGNAL ID_EX_Buffer_Rsrc1Out : std_logic_vector(2 DOWNTO 0);
    SIGNAL ID_EX_Buffer_Rsrc2Out : std_logic_vector(2 DOWNTO 0);
    SIGNAL ID_EX_Buffer_RdstOut : std_logic_vector(2 DOWNTO 0);
-- EX_CU Signals Out
    SIGNAL EX_CU_Buffer_OutputPortAllowOut : std_logic;
    SIGNAL EX_CU_Buffer_ALUOrInputSelectorOut : std_logic;
    SIGNAL EX_CU_Buffer_SwapSelectorOut : std_logic;
    SIGNAL EX_CU_Buffer_NeedFUOut : std_logic;
    SIGNAL EX_CU_Buffer_SetCOut : std_logic;
    SIGNAL EX_CU_Buffer_JumpAllowOut : std_logic;
    SIGNAL EX_CU_Buffer_JumpTypeOut : std_logic_vector(1 downto 0);
    SIGNAL EX_CU_Buffer_FlagsAllowUpdateOut : std_logic_vector(1 downto 0);
    SIGNAL EX_CU_Buffer_EXOperandTypeOut : std_logic_vector(1 downto 0);
    SIGNAL EX_CU_Buffer_ALUControlSignalsOut : std_logic_vector(2 downto 0);
-- MEM_CU Signals Out 1st Buffer
    SIGNAL MEM_CU_1st_Buffer_SPSelectorOut : std_logic;
    SIGNAL MEM_CU_1st_Buffer_PushOrPopSelectorOut : std_logic;
    SIGNAL MEM_CU_1st_Buffer_CallOrReturnSelectorOut : std_logic;
    SIGNAL MEM_CU_1st_Buffer_MemoryReadOut : std_logic;
    SIGNAL MEM_CU_1st_Buffer_MemoryWriteOut : std_logic;
    SIGNAL MEM_CU_1st_Buffer_AddressSelectorOut : std_logic_vector(1 downto 0);
    SIGNAL MEM_CU_1st_Buffer_WriteDateSelectorOut : std_logic;
    SIGNAL MEM_CU_1st_Buffer_InterruptOrCallOrReturnOut : std_logic;
-- MEM_CU Signals Out 2nd Buffer
    SIGNAL MEM_CU_2nd_Buffer_SPSelectorOut : std_logic;
    SIGNAL MEM_CU_2nd_Buffer_PushOrPopSelectorOut : std_logic;
    SIGNAL MEM_CU_2nd_Buffer_CallOrReturnSelectorOut : std_logic;
    SIGNAL MEM_CU_2nd_Buffer_MemoryReadOut : std_logic;
    SIGNAL MEM_CU_2nd_Buffer_MemoryWriteOut : std_logic;
    SIGNAL MEM_CU_2nd_Buffer_AddressSelectorOut : std_logic_vector(1 downto 0);
    SIGNAL MEM_CU_2nd_Buffer_WriteDateSelectorOut : std_logic;
    SIGNAL MEM_CU_2nd_Buffer_InterruptOrCallOrReturnOut : std_logic;
-- WB_CU Signals Out 1st Buffer
    SIGNAL WB_CU_1st_Buffer_RegWriteFlagOut : std_logic;
    SIGNAL WB_CU_1st_Buffer_MEMDataOrEXResultSelectorOut : std_logic;
-- WB_CU Signals Out 2nd Buffer
    SIGNAL WB_CU_2nd_Buffer_RegWriteFlagOut : std_logic;
    SIGNAL WB_CU_2nd_Buffer_MEMDataOrEXResultSelectorOut : std_logic;
-- WB_CU Signals Out 3rd Buffer
    SIGNAL WB_CU_3rd_Buffer_RegWriteFlagOut : std_logic;
    SIGNAL WB_CU_3rd_Buffer_MEMDataOrEXResultSelectorOut : std_logic;
-- EX stage Signals Out
    SIGNAL EX_FinalRdst : std_logic_vector(2 downto 0);
    SIGNAL EX_Result : std_logic_vector(31 downto 0);
    SIGNAL EX_FUdata1Mem : std_logic_vector(31 downto 0);
    SIGNAL EX_FLags : std_logic_vector(2 downto 0);
-- Flags Register Signals Out
    SIGNAL FLAGS_Register : std_logic_vector(2 downto 0);
-- Jump Unit Signals Out
    SIGNAL JumpUnit_UpdatedFlags : std_logic_vector(2 downto 0);
    SIGNAL JumpUnit_Flag : std_logic;
-- Ex/MEM Buffer Signals Out
    SIGNAL EX_MEM_Buffer_ReadData1Out : std_logic_vector(31 downto 0);
    SIGNAL EX_MEM_Buffer_EXResultOut : std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_MEM_Buffer_FlagsConcatenatedPCOut: std_logic_vector(31 DOWNTO 0);
    SIGNAL EX_MEM_Buffer_RdstOut : std_logic_vector(2 DOWNTO 0);
-- Stack Pointer Signals Out
    SIGNAL SP_ToMemory : std_logic_vector(19 downto 0);
-- MEM/WB Buffer Signals Out
    SIGNAL MEM_WB_Buffer_EXResultOut : std_logic_vector(31 DOWNTO 0);
    SIGNAL MEM_WB_Buffer_DataMemoryOut : std_logic_vector(31 DOWNTO 0);
    SIGNAL MEM_WB_Buffer_RdstOut : std_logic_vector(2 DOWNTO 0);
-- ForwardingUnit Signals Out
    SIGNAL FU_FirstOperand : std_logic_vector(1 downto 0);
    SIGNAL FU_SecondOperand : std_logic_vector(1 downto 0);
--
BEGIN
-- Connecting to Fetch Stage
FetchStage: ProgramCounter PORT MAP (clk => Clk,
                             Reset => Reset, 
                             Interrupt => Interrupt, 
                             CallRetSelector => MEM_CU_2nd_Buffer_CallOrReturnSelectorOut, 
                             PCSelector => HDU_PC_Selector, 
                             MemoryInstructionReset => Memory_Instruction,
                             IMMFromEXForJumping => ID_EX_Buffer_ImmediateOut,
                             IMMFromMEMForCall => EX_MEM_Buffer_EXResultOut,
                             ReadDataFromMEM => Memory_DataOut,

                             PCToBeStoredInInterrupts => PC_To_IF_ID_Buffer,
                             PCToMemory => PC_To_Memory);

-- Connecting to memory
Memorym: Memory PORT MAP    (clk => Clk,     
                             WriteEnable => MEM_CU_2nd_Buffer_MemoryWriteOut,
                             ReadEnable  => MEM_CU_2nd_Buffer_MemoryReadOut,
                             Reset => Reset,
                             address => Memory_Address,
                             ProgramCounter => PC_To_Memory,
                             datain => Memory_Write_Data,  
                             
                             dataout => Memory_DataOut,
                             Intruction => Memory_Instruction);

-- Connecting to IF/ID Buffer
IF_ID_Buffer: IF_IDBuffer PORT MAP (clk => Clk,
                             FlushAtNextFall => HDU_IF_ID_Signals(2),
                             FlushNow => HDU_IF_ID_Signals(1),
                             Enable => HDU_IF_ID_Signals(0),
                             InterruptFlag => Interrupt,
                             InputPort => InputPort,
                             PC => PC_To_IF_ID_Buffer,
                             Instruction => Memory_Instruction,
                            
                             OpCode => IF_ID_Buffer_OpCode,
                             PCOut => IF_ID_Buffer_PCOut,
                             InterruptFlagOut => IF_ID_Buffer_InterruptFlag,
                             Rsrc1 => IF_ID_Buffer_Rsrc1,
                             Rsrc2 => IF_ID_Buffer_Rsrc2,
                             Rdst => IF_ID_Buffer_Rdst,
                             Immediate => IF_ID_Buffer_Immediate,
                             InputPortOut => IF_ID_Buffer_InputPort);

-- Connecting to Register File
RegisterFile: Registers PORT MAP (clk => Clk,
                             Reset => Reset,
                             RegWriteFlag => WB_CU_3rd_Buffer_RegWriteFlagOut,
                             Rsrc1 => IF_ID_Buffer_Rsrc1,
                             Rsrc2 => IF_ID_Buffer_Rsrc2,
                             Rdst  => MEM_WB_Buffer_RdstOut,
                             RegWriteData => FINAL_WB,

                             ReadData1 => Registers_ReadData1,
                             ReadData2 => Registers_ReadData2);

-- Connecting to Control Unit
CU : ControlUnit PORT MAP (Clk => Clk,
                             InterruptFlag => IF_ID_Buffer_InterruptFlag,
                             ResetFlag => Reset,
                             FlushFrom_HU => HDU_CU_Flush,
                             DelayFrom_HU => HDU_CU_Delay,
                             OPCode => IF_ID_Buffer_OpCode,
 
                             -- HU Signals
                             HLTFlag => CU_HLTFlag,
                             SwapOrInterruptDelay => CU_SwapOrInterruptDelay,
                             
                             -- Ex Signals
                             OutputPortAllow => CU_OutputPortAllow,
                             ALUOrInputSelector => CU_ALUOrInputSelector,
                             SwapSelector => CU_SwapSelector,
                             NeedFU => CU_NeedFU,
                             SetC => CU_SetC,
                             JumpAllow => CU_JumpAllow,
                             JumpType => CU_JumpType,
                             FlagsAllowUpdate => CU_FlagsAllowUpdate,
                             EXOperandType => CU_EXOperandType,
                             ALUControlSignals => CU_ALUControlSignals,
 
                            -- MEM Signals
                             SPSelector => CU_SPSelector,
                             PushOrPopSelector => CU_PushOrPopSelector,
                             CallOrReturnSelector => CU_CallOrReturnSelector,
                             MemoryRead => CU_MemoryRead,
                             MemoryWrite => CU_MemoryWrite,
                             AddressSelector => CU_AddressSelector,
                             WriteDateSelector => CU_WriteDateSelector,
                             InterruptOrCallOrReturn => CU_InterruptOrCallOrReturn,
                             
                             -- WB Signals
                             RegWriteFlag => CU_RegWriteFlag,
                             MEMDataOrEXResultSelector => CU_MEMDataOrEXResultSelector);

-- Connecting to Hazard Detection Unit
HDU : HazardDetectionUnit PORT MAP (HLTFlag => CU_HLTFlag,
                             Reset => Reset,
                             SwapOrInterruptDelay => CU_SwapOrInterruptDelay,
                             JumpFlag => JumpUnit_Flag,
                             MEM_Read => MEM_CU_2nd_Buffer_MemoryReadOut,
                             MEM_Write => MEM_CU_2nd_Buffer_MemoryWriteOut,
                             Call_Ret_IntFlag => MEM_CU_2nd_Buffer_InterruptOrCallOrReturnOut,
                             NeedFUFlag => EX_CU_Buffer_NeedFUOut,
                             Rsrc1_EX => ID_EX_Buffer_Rsrc1Out,
                             Rsrc2_EX => ID_EX_Buffer_Rsrc2Out,
                             Rdst_MEM => EX_MEM_Buffer_RdstOut,
                             
                             PCSelector => HDU_PC_Selector,
                             -- These Signals represent FlushAtNextFall, FlushNow, Enable
                             IF_ID_Signals => HDU_IF_ID_Signals,
                             ID_EX_Signals => HDU_ID_EX_Signals,
                             EX_MEM_Signals => HDU_EX_MEM_Signals,
 
                             CU_Flush => HDU_CU_Flush,
                             CU_Delay => HDU_CU_Delay);
-- Connecting to ID/EX Buffer
ID_EX_Buffer: ID_EXBuffer PORT MAP (clk => Clk,
                             FlushAtNextFall => HDU_ID_EX_Signals(2),
                             FlushNow => HDU_ID_EX_Signals(1),
                             Enable => HDU_ID_EX_Signals(0),
                             ReadData1 => Registers_ReadData1,
                             ReadData2 => Registers_ReadData2,
                             Immediate => IF_ID_Buffer_Immediate,
                             InputPort => IF_ID_Buffer_InputPort,
                             PC => IF_ID_Buffer_PCOut,
                             Rsrc1 => IF_ID_Buffer_Rsrc1, 
                             Rsrc2 => IF_ID_Buffer_Rsrc2,
                             Rdst => IF_ID_Buffer_Rdst,
                             
                             ReadData1Out => ID_EX_Buffer_ReadData1Out,
                             ReadData2Out => ID_EX_Buffer_ReadData2Out,
                             ImmediateOut => ID_EX_Buffer_ImmediateOut,
                             InputPortOut => ID_EX_Buffer_InputPortOut,
                             PCOut => ID_EX_Buffer_PCOut,
                             Rsrc1Out => ID_EX_Buffer_Rsrc1Out,
                             Rsrc2Out => ID_EX_Buffer_Rsrc2Out,
                             RdstOut => ID_EX_Buffer_RdstOut);
-- Connecting to 1st EX_CU, MEM_CU, and WB_CU 
EX_CUBuffer: EX_CU_Buffer PORT MAP (clk => Clk,
                             FlushAtNextFall => HDU_ID_EX_Signals(2),
                             FlushNow => HDU_ID_EX_Signals(1),
                             Enable => HDU_ID_EX_Signals(0),

                             OutputPortAllow => CU_OutputPortAllow,
                             ALUOrInputSelector => CU_ALUOrInputSelector,
                             SwapSelector => CU_SwapSelector,
                             NeedFU => CU_NeedFU,
                             SetC => CU_SetC,
                             JumpAllow => CU_JumpAllow,
                             JumpType => CU_JumpType,
                             FlagsAllowUpdate => CU_FlagsAllowUpdate,
                             EXOperandType => CU_EXOperandType,
                             ALUControlSignals => CU_ALUControlSignals,

                             OutputPortAllowOut => EX_CU_Buffer_OutputPortAllowOut,
                             ALUOrInputSelectorOut => EX_CU_Buffer_ALUOrInputSelectorOut,
                             SwapSelectorOut => EX_CU_Buffer_SwapSelectorOut,
                             NeedFUOut => EX_CU_Buffer_NeedFUOut,
                             SetCOut => EX_CU_Buffer_SetCOut,
                             JumpAllowOut => EX_CU_Buffer_JumpAllowOut,
                             JumpTypeOut => EX_CU_Buffer_JumpTypeOut,
                             FlagsAllowUpdateOut => EX_CU_Buffer_FlagsAllowUpdateOut,
                             EXOperandTypeOut => EX_CU_Buffer_EXOperandTypeOut,
                             ALUControlSignalsOut => EX_CU_Buffer_ALUControlSignalsOut); 

MEM_CU_1st_Buffer: MEM_CU_Buffer PORT MAP (clk => Clk,
                             FlushAtNextFall => HDU_ID_EX_Signals(2),
                             FlushNow => HDU_ID_EX_Signals(1),
                             Enable => HDU_ID_EX_Signals(0),

                             SPSelector => CU_SPSelector,
                             PushOrPopSelector => CU_PushOrPopSelector,
                             CallOrReturnSelector => CU_CallOrReturnSelector,
                             MemoryRead => CU_MemoryRead,
                             MemoryWrite => CU_MemoryWrite,
                             AddressSelector => CU_AddressSelector,
                             WriteDateSelector => CU_WriteDateSelector,
                             InterruptOrCallOrReturn => CU_InterruptOrCallOrReturn,
                             
                             SPSelectorOut => MEM_CU_1st_Buffer_SPSelectorOut,
                             PushOrPopSelectorOut => MEM_CU_1st_Buffer_PushOrPopSelectorOut,
                             CallOrReturnSelectorOut => MEM_CU_1st_Buffer_CallOrReturnSelectorOut,
                             MemoryReadOut => MEM_CU_1st_Buffer_MemoryReadOut,
                             MemoryWriteOut => MEM_CU_1st_Buffer_MemoryWriteOut,
                             AddressSelectorOut => MEM_CU_1st_Buffer_AddressSelectorOut,
                             WriteDateSelectorOut => MEM_CU_1st_Buffer_WriteDateSelectorOut,
                             InterruptOrCallOrReturnOut => MEM_CU_1st_Buffer_InterruptOrCallOrReturnOut);

WB_CU_1st_Buffer: WB_CU_Buffer PORT MAP (clk => Clk,
                             FlushAtNextFall => HDU_ID_EX_Signals(2),
                             FlushNow => HDU_ID_EX_Signals(1),
                             Enable => HDU_ID_EX_Signals(0),

                             RegWriteFlag => CU_RegWriteFlag,
                             MEMDataOrEXResultSelector => CU_MEMDataOrEXResultSelector,

                             RegWriteFlagOut => WB_CU_1st_Buffer_RegWriteFlagOut,
                             MEMDataOrEXResultSelectorOut => WB_CU_1st_Buffer_MEMDataOrEXResultSelectorOut);                            
-- Connecting to 2nd MEM_CU, and WB_CU
MEM_CU_2nd_Buffer: MEM_CU_Buffer PORT MAP (clk => Clk,
                             FlushAtNextFall => HDU_EX_MEM_Signals(2),
                             FlushNow => HDU_EX_MEM_Signals(1),
                             Enable => HDU_EX_MEM_Signals(0),

                             SPSelector => MEM_CU_1st_Buffer_SPSelectorOut,
                             PushOrPopSelector => MEM_CU_1st_Buffer_PushOrPopSelectorOut,
                             CallOrReturnSelector => MEM_CU_1st_Buffer_CallOrReturnSelectorOut,
                             MemoryRead => MEM_CU_1st_Buffer_MemoryReadOut,
                             MemoryWrite => MEM_CU_1st_Buffer_MemoryWriteOut,
                             AddressSelector => MEM_CU_1st_Buffer_AddressSelectorOut,
                             WriteDateSelector => MEM_CU_1st_Buffer_WriteDateSelectorOut,
                             InterruptOrCallOrReturn => MEM_CU_1st_Buffer_InterruptOrCallOrReturnOut,
                             
                             SPSelectorOut => MEM_CU_2nd_Buffer_SPSelectorOut,
                             PushOrPopSelectorOut => MEM_CU_2nd_Buffer_PushOrPopSelectorOut,
                             CallOrReturnSelectorOut => MEM_CU_2nd_Buffer_CallOrReturnSelectorOut,
                             MemoryReadOut => MEM_CU_2nd_Buffer_MemoryReadOut,
                             MemoryWriteOut => MEM_CU_2nd_Buffer_MemoryWriteOut,
                             AddressSelectorOut => MEM_CU_2nd_Buffer_AddressSelectorOut,
                             WriteDateSelectorOut => MEM_CU_2nd_Buffer_WriteDateSelectorOut,
                             InterruptOrCallOrReturnOut => MEM_CU_2nd_Buffer_InterruptOrCallOrReturnOut);
WB_CU_2nd_Buffer: WB_CU_Buffer PORT MAP (clk => Clk,
                             FlushAtNextFall => HDU_EX_MEM_Signals(2),
                             FlushNow => HDU_EX_MEM_Signals(1),
                             Enable => HDU_EX_MEM_Signals(0),

                             RegWriteFlag => WB_CU_1st_Buffer_RegWriteFlagOut,
                             MEMDataOrEXResultSelector => WB_CU_1st_Buffer_MEMDataOrEXResultSelectorOut,

                             RegWriteFlagOut => WB_CU_2nd_Buffer_RegWriteFlagOut,
                             MEMDataOrEXResultSelectorOut => WB_CU_2nd_Buffer_MEMDataOrEXResultSelectorOut);
-- Connecting to 3rd WB_CU
WB_CU_3rd_Buffer: WB_CU_Buffer PORT MAP (clk => Clk,
                             FlushAtNextFall => '0',
                             FlushNow => '0',
                             Enable => '1',

                             RegWriteFlag => WB_CU_2nd_Buffer_RegWriteFlagOut,
                             MEMDataOrEXResultSelector => WB_CU_2nd_Buffer_MEMDataOrEXResultSelectorOut,

                             RegWriteFlagOut => WB_CU_3rd_Buffer_RegWriteFlagOut,
                             MEMDataOrEXResultSelectorOut => WB_CU_3rd_Buffer_MEMDataOrEXResultSelectorOut);
-- Ex Unit
EUwest: ExecutionStageALU PORT MAP(
                             Rsrc1 => ID_EX_Buffer_Rsrc1Out,
                             Rdst => ID_EX_Buffer_RdstOut,
                             SwapSelector => EX_CU_Buffer_SwapSelectorOut,
                             InputPort => IF_ID_Buffer_InputPort,
                             Rdata1 => ID_EX_Buffer_ReadData1Out,
                             Rdata2 => ID_EX_Buffer_ReadData2Out,
                             Immediate => ID_EX_Buffer_ImmediateOut,
                             ExexutionResultInMemory => EX_MEM_Buffer_EXResultOut,
                             MemoryResultInWriteBack => FINAL_WB,
                             FuFirstOperandSelector => FU_FirstOperand,
                             FuSecondOperandSelector => FU_SecondOperand,
                             EXOperandsSelector => EX_CU_Buffer_EXOperandTypeOut,
                             ALUControlSignals => EX_CU_Buffer_ALUControlSignalsOut,
                             ALUorInputSelector => EX_CU_Buffer_ALUOrInputSelectorOut,

                             FinalRdst => EX_FinalRdst,
                             EXResult => EX_Result,
                             FUdata1Mem => EX_FUdata1Mem,
                             FLags => EX_Flags);
-- Flag Register
Flagregisteer: FlagRegister PORT MAP(
                             clk => Clk,
                             Reset => Reset,
                             SetC => EX_CU_Buffer_SetCOut,
                             Int_Ret_CallFlag => MEM_CU_2nd_Buffer_InterruptOrCallOrReturnOut,
                             JumpAllow => EX_CU_Buffer_JumpAllowOut,
                             FlagsAllow => EX_CU_Buffer_FlagsAllowUpdateOut,
                             JumpUpdateFlags => JumpUnit_UpdatedFlags,
                             ALUFlags => EX_Flags,

                             Flags => FLAGS_Register);
-- Jump Unit
JU : JumpUnit PORT MAP(JumpAllow => EX_CU_Buffer_JumpAllowOut,
                             JumpType => EX_CU_Buffer_JumpTypeOut,
                             Flags => FLAGS_Register,

                             UpdatedFlags => JumpUnit_UpdatedFlags,
                             JumpFlag => JumpUnit_Flag);
-- Connecting to EX/MEM Buffer 
EX_MemBufffer: EX_MEMBuffer PORT MAP (
                             clk => Clk,
                             FlushAtNextFall => HDU_EX_MEM_Signals(2),
                             FlushNow => HDU_EX_MEM_Signals(1),
                             Enable => HDU_EX_MEM_Signals(0),

                             ReadData1 => EX_FUdata1Mem,
                             EXResult => EX_Result,
                             PC => ID_EX_Buffer_PCOut,
                             Flags => FLAGS_Register,
                             Rdst => EX_FinalRdst,
                             
                             ReadData1Out => EX_MEM_Buffer_ReadData1Out,
                             EXResultOut => EX_MEM_Buffer_EXResultOut,
                             FlagsConcatenatedPCOut => EX_MEM_Buffer_FlagsConcatenatedPCOut,
                             RdstOut => EX_MEM_Buffer_RdstOut);
-- Output port
OutputPort <= Ex_Result; -- WHEN EX_CU_Buffer_OutputPortAllowOut = '1' ELSE (others => 'Z') END;
-- Connecting to Stack
SU: StackPointer PORT MAP (
                             clk => Clk,
                             Reset => Reset,
                             PushOrPopSelector => MEM_CU_2nd_Buffer_PushOrPopSelectorOut,
                             SPSelector => MEM_CU_2nd_Buffer_SPSelectorOut,
                             
                             SPToMemory => SP_ToMemory);
-- Memory address and data
Memory_Address <= (0 => '1',others => '0') WHEN MEM_CU_2nd_Buffer_AddressSelectorOut = "00"
ELSE EX_MEM_Buffer_EXResultOut(19 DOWNTO 0) WHEN MEM_CU_2nd_Buffer_AddressSelectorOut = "01"
ELSE SP_ToMemory WHEN MEM_CU_2nd_Buffer_AddressSelectorOut = "10"
ELSE (others => '0');

Memory_Write_Data <= EX_MEM_Buffer_FlagsConcatenatedPCOut WHEN MEM_CU_2nd_Buffer_WriteDateSelectorOut = '0'
ELSE EX_MEM_Buffer_ReadData1Out;
-- MEM/WB buffer
MEM_WBBUfffer: MEM_WBBuffer PORT MAP (
                             clk => Clk, 
                             FlushAtNextFall => '0',
                             FlushNow => '0',
                             Enable => '1',

                             DataMemory => Memory_DataOut,
                             EXResult => EX_MEM_Buffer_EXResultOut,
                             Rdst => EX_MEM_Buffer_RdstOut,

                             EXResultOut => MEM_WB_Buffer_EXResultOut,
                             DataMemoryOut => MEM_WB_Buffer_DataMemoryOut,
                             RdstOut => MEM_WB_Buffer_RdstOut);
-- Final WB
FINAL_WB <= MEM_WB_Buffer_DataMemoryOut WHEN WB_CU_3rd_Buffer_MEMDataOrEXResultSelectorOut = '1'
ELSE MEM_WB_Buffer_EXResultOut;
-- Forwarding Unit
FuckYou : ForwardingUnit PORT MAP(
                                 needFUFlag => EX_CU_Buffer_NeedFUOut,
                                 RegWriteFlagInMEM => WB_CU_2nd_Buffer_RegWriteFlagOut,
                                 RegWriteFlagInWB => WB_CU_3rd_Buffer_RegWriteFlagOut,
                                 SwapSelector => EX_CU_Buffer_SwapSelectorOut,
                                 Rsrc1 => ID_EX_Buffer_Rsrc1Out,
                                 Rsrc2 => ID_EX_Buffer_Rsrc2Out,
                                 RdstMEM => EX_MEM_Buffer_RdstOut,
                                 RdstWB => MEM_WB_Buffer_RdstOut,
 
                                 FUFirstOperand => FU_FirstOperand,
                                 FUSecondOperand => FU_SecondOperand);


END mainProcessor_arch;	