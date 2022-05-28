LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY ExecutionStageALU IS
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
        FLags : OUT std_logic_vector(3 downto 0)
        );
END ENTITY ExecutionStageALU;

ARCHITECTURE ExecutionStageALU_arch OF ExecutionStageALU IS
    
    COMPONENT ALU IS
	PORT(
		ALUControlSignals : IN std_logic_vector(2 DOWNTO 0);
        FirstOperand      : IN std_logic_vector(31 DOWNTO 0);
        SecondOperand     : IN std_logic_vector(31 DOWNTO 0);
        ALUResult         : OUT std_logic_vector(31 DOWNTO 0);
        Flags             : OUT std_logic_vector(3 DOWNTO 0));
    END COMPONENT ALU;

    SIGNAL FUData1, FUData2: std_logic_vector(31 downto 0);
    SIGNAL ALUFirstOperand, ALUSecondOperand, ALUResult: std_logic_vector(31 downto 0);

    BEGIN
    --First FinalRdst
    FinalRdst <= Rsrc1 WHEN SwapSelector = '1'
    ELSE Rdst;
    -- Second FUData1 and FUData2
    FUData1 <= ExexutionResultInMemory WHEN FuFirstOperandSelector = "01"
    ELSE MemoryResultInWriteBack WHEN FuFirstOperandSelector = "10"
    ELSE Rdata1;
    FUData2 <= ExexutionResultInMemory WHEN FuSecondOperandSelector = "01"
    ELSE MemoryResultInWriteBack WHEN FuSecondOperandSelector = "10"
    ELSE Rdata2;
    -- Third ALU Operands
    ALUFirstOperand <= FUData2 WHEN EXOperandsSelector(0) = '1'
    ELSE FUData1;
    ALUSecondOperand <= Immediate WHEN EXOperandsSelector(1) = '1'
    ELSE FUData2;
    -- Connecting to ALU
    ALUEX: ALU PORT MAP( ALUControlSignals => ALUControlSignals, FirstOperand => ALUFirstOperand, SecondOperand => ALUSecondOperand, ALUResult => ALUResult, Flags => FLags);
    -- Connecting to EXResult
    EXResult <= INPUTPORT WHEN ALUorInputSelector = '1'
    ELSE ALUResult;
    -- Connecting to FUdata1Mem
    FUdata1Mem <= FUData1;
END ExecutionStageALU_arch;	 