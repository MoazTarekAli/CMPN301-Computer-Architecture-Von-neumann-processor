LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mainProcessor IS
    PORT(
        Clk : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        Interrupt : IN STD_LOGIC;
        InputPort : IN STD_LOGIC_VECTOR(31 downto 0)
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

-- Control Unit Signals Out
    SIGNAL Control_Unit_HLTFlag : std_logic;
    SIGNAL Control_Unit_SwapOrInterruptDelay : std_logic;
    SIGNAL Control_Unit_OutputPortAllow : std_logic;
    SIGNAL Control_Unit_ALUOrInputSelector : std_logic;
    SIGNAL Control_Unit_SwapSelector : std_logic;
    SIGNAL Control_Unit_NeedFU : std_logic;
    SIGNAL Control_Unit_SetC : std_logic;
    SIGNAL Control_Unit_JumpAllow : std_logic;
    SIGNAL Control_Unit_JumpType : std_logic_vector(1 DOWNTO 0);
    SIGNAL Control_Unit_FlagsAllowUpdate : std_logic_vector(1 DOWNTO 0);
    SIGNAL Control_Unit_EXOperandType : std_logic_vector(1 DOWNTO 0);
    SIGNAL Control_Unit_ALUControlSignals : std_logic_vector(2 DOWNTO 0);
    SIGNAL Control_Unit_SPSelector : std_logic;
    SIGNAL Control_Unit_PushOrPopSelector : std_logic;
    SIGNAL Control_Unit_CallOrReturnSelector : std_logic;
    SIGNAL Control_Unit_MemoryRead : std_logic;
    SIGNAL Control_Unit_MemoryWrite : std_logic;
    SIGNAL Control_Unit_AddressSelector : std_logic_vector(1 DOWNTO 0);
    SIGNAL Control_Unit_WriteDateSelector : std_logic;
    SIGNAL Control_Unit_InterruptOrCallOrReturn : std_logic;
    SIGNAL Control_Unit_RegWriteFlag : std_logic;
    SIGNAL Control_Unit_MEMDataOrEXResultSelector : std_logic;

-- Hazard Detection Unit Signals Out
    SIGNAL HDU_PC_Selector : std_logic_vector(1 DOWNTO 0);
    SIGNAL HDU_IF_ID_Signals : std_logic_vector(2 DOWNTO 0);
    SIGNAL HDU_ID_EX_Signals : std_logic_vector(2 DOWNTO 0);
    SIGNAL HDU_EX_MEM_Signals : std_logic_vector(2 DOWNTO 0);
    SIGNAL HDU_CU_Flush : std_logic;
    SIGNAL HDU_CU_Delay : std_logic;

-- Registers Signals Out
    SIGNAL ReadData1_From_Registers : std_logic_vector(31 DOWNTO 0);
    SIGNAL ReadData2_From_Registers : std_logic_vector(31 DOWNTO 0);
-- 
BEGIN
-- Connecting to Fetch Stage
FetchStage: ProgramCounter PORT MAP (clk => Clk,
                             Reset => Reset, 
                             Interrupt => Interrupt, 
                             CallRetSelector => '1', 
                             PCSelector => HDU_PC_Selector, 
                             MemoryInstructionReset => Memory_Instruction,
                             IMMFromEXForJumping => (others => '0'),
                             IMMFromMEMForCall => (others => '0'),
                             ReadDataFromMEM => (others => '0'),

                             PCToBeStoredInInterrupts => PC_To_IF_ID_Buffer,
                             PCToMemory => PC_To_Memory);

-- Connecting to memory
Memorym: Memory PORT MAP    (clk => Clk,     
                             WriteEnable => '0',
                             ReadEnable  => '0',
                             Reset => Reset,
                             address => (others => '0'),
                             ProgramCounter => PC_To_Memory,
                             datain => (others => '0'),  
                             
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
                             Instruction => Memory_In   struction,
                            
                             OpCode => IF_ID_Buffer_OpCode,
                             PCOut => IF_ID_Buffer_PCOut,
                             InterruptFlagOut => IF_ID_Buffer_InterruptFlag,
                             Rsrc1 => IF_ID_Buffer_Rsrc1,
                             Rsrc2 => IF_ID_Buffer_Rsrc2,
                             Rdst => IF_ID_Buffer_Rdst,
                             Immediate => IF_ID_Buffer_Immediate,
                             InputPortOut => IF_ID_Buffer_InputPort);

END mainProcessor_arch;	