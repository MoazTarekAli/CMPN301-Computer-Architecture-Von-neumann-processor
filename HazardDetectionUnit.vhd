LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY HazardDetectionUnit IS
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
END ENTITY HazardDetectionUnit;

ARCHITECTURE HazardDetectionUnit_arch OF HazardDetectionUnit IS
    BEGIN

    -- First Check For reset --
    IF_ID_Signals <= "011" WHEN Reset = '1'
    -- Then for HLTFlag to freeze 
    ELSE "000" WHEN HLTFlag = '1'
    -- Then for Interrupt/Call/Return in Memory
    ELSE "101" WHEN Call_Ret_IntFlag = '1'
    -- Then For Load/Use Case
    ELSE "000" WHEN (Rsrc1_EX = Rdst_MEM OR Rsrc2_EX = Rdst_MEM) and MEM_Read = '1' and NeedFUFlag = '1'
    -- Then For Jump
    ElSE "101" WHEN JumpFlag = '1'
    -- Then For Swap/Interrupt in CU
    ElSE "000" WHEN SwapOrInterruptDelay = '1'
    -- Then for Structural hazards
    ELSE "010" WHEN (MEM_Write = '1' OR MEM_Read = '1')
    -- Then default
    ELSE "001";
    
    -- First Check For reset --
    ID_EX_Signals <= "011" WHEN Reset = '1'
    -- Then for HLTFlag to freeze 
    ELSE "000" WHEN HLTFlag = '1'
    -- Then for Interrupt/Call/Return in Memory
    ELSE "101" WHEN Call_Ret_IntFlag = '1'
    -- Then For Load/Use Case
    ELSE "000" WHEN (Rsrc1_EX = Rdst_MEM OR Rsrc2_EX = Rdst_MEM) and MEM_Read = '1' and NeedFUFlag = '1'
    -- Then For Jump
    ElSE "101" WHEN JumpFlag = '1'
    -- Then For Swap/Interrupt in CU
    ElSE "001" WHEN SwapOrInterruptDelay = '1'
    -- Then for Structural hazards
    ELSE "010" WHEN (MEM_Write = '1' OR MEM_Read = '1')
    -- Then default
    ELSE "001";

    -- First Check For reset --
    EX_MEM_Signals <= "011" WHEN Reset = '1'
    -- Then for HLTFlag to freeze 
    ELSE "000" WHEN HLTFlag = '1'
    -- Then for Interrupt/Call/Return in Memory
    ELSE "101" WHEN Call_Ret_IntFlag = '1'
    -- Then For Load/Use Case
    ELSE "100" WHEN (Rsrc1_EX = Rdst_MEM OR Rsrc2_EX = Rdst_MEM) and MEM_Read = '1' and NeedFUFlag = '1'
    -- Then For Jump
    ElSE "001" WHEN JumpFlag = '1'
    -- Then For Swap/Interrupt in CU
    ElSE "001" WHEN SwapOrInterruptDelay = '1'
    -- Then for Structural hazards
    ELSE "001" WHEN (MEM_Write = '1' OR MEM_Read = '1')
    -- Then default
    ELSE "001";
    
    -- First Check For reset --
    CU_Flush <= '1' WHEN Reset = '1'
    -- Then for HLTFlag to freeze 
    ELSE '0' WHEN HLTFlag = '1'
    -- Then for Interrupt/Call/Return in Memory
    ELSE '1' WHEN Call_Ret_IntFlag = '1'
    -- Then For Load/Use Case
    ELSE '0' WHEN (Rsrc1_EX = Rdst_MEM OR Rsrc2_EX = Rdst_MEM) and MEM_Read = '1' and NeedFUFlag = '1'
    -- Then For Jump
    ElSE '1' WHEN JumpFlag = '1'
    -- Then For Swap/Interrupt in CU
    ElSE '0' WHEN SwapOrInterruptDelay = '1'
    -- Then for Structural hazards
    ELSE '0' WHEN (MEM_Write = '1' OR MEM_Read = '1')
    -- Then default
    ELSE '0';

    -- First Check For reset --
    CU_Delay <= '0' WHEN Reset = '1'
    -- Then for HLTFlag to freeze 
    ELSE '0' WHEN HLTFlag = '1'
    -- Then for Interrupt/Call/Return in Memory
    ELSE '0' WHEN Call_Ret_IntFlag = '1'
    -- Then For Load/Use Case
    ELSE '1' WHEN (Rsrc1_EX = Rdst_MEM OR Rsrc2_EX = Rdst_MEM) and MEM_Read = '1' and NeedFUFlag = '1'
    -- Then For Jump
    ElSE '0' WHEN JumpFlag = '1'
    -- Then For Swap/Interrupt in CU
    ElSE '0' WHEN SwapOrInterruptDelay = '1'
    -- Then for Structural hazards
    ELSE '0' WHEN (MEM_Write = '1' OR MEM_Read = '1')
    -- Then default
    ELSE '0';

    -- First Check For reset --
    PCSelector <= "11" WHEN Reset = '1'
    -- Then for HLTFlag to freeze 
    ELSE "11" WHEN HLTFlag = '1'
    -- Then for Interrupt/Call/Return in Memory
    ELSE "10" WHEN Call_Ret_IntFlag = '1'
    -- Then For Load/Use Case
    ELSE "11" WHEN (Rsrc1_EX = Rdst_MEM OR Rsrc2_EX = Rdst_MEM) and MEM_Read = '1' and NeedFUFlag = '1'
    -- Then For Jump
    ElSE "01" WHEN JumpFlag = '1'
    -- Then For Swap/Interrupt in CU
    ElSE "11" WHEN SwapOrInterruptDelay = '1'
    -- Then for Structural hazards
    ELSE "11" WHEN (MEM_Write = '1' OR MEM_Read = '1')
    -- Then default
    ELSE "00";

END HazardDetectionUnit_arch;
