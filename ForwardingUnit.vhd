LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ForwardingUnit IS
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
END ENTITY ForwardingUnit;

ARCHITECTURE ForwardingUnit_arch OF ForwardingUnit IS
    BEGIN
    FUFirstOperand <= "01" WHEN Rsrc1 = RdstMEM and RegWriteFlagInMEM = '1' and needFUFlag = '1' and SwapSelector = '0'
    ELSE "10" WHEN Rsrc1 = RdstWB and RegWriteFlagInWB = '1' and needFUFlag = '1' 
    ELSE "00";

    FUSecondOperand <= "01" WHEN Rsrc2 = RdstMEM and RegWriteFlagInMEM = '1' and needFUFlag = '1'
    ELSE "10" WHEN Rsrc2 = RdstWB and RegWriteFlagInWB = '1' and needFUFlag = '1'
    ELSE "00";
END ForwardingUnit_arch;
