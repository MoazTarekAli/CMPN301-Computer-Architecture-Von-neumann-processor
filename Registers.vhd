LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Registers IS
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
END ENTITY Registers;

ARCHITECTURE Registers_arch OF Registers IS
    COMPONENT Reg32 IS
        PORT(
            clk: IN std_logic;
            Reset: IN std_logic;
            enable: IN std_logic;
            InputValue: IN std_logic_vector(31 DOWNTO 0);
            StoredValue: OUT std_logic_vector(31 DOWNTO 0));
    END COMPONENT Reg32;

    SIGNAL RegWriteEnable : std_logic_vector(7 DOWNTO 0); 
    SIGNAL RegReadData0, RegReadData1, RegReadData2, RegReadData3, RegReadData4, RegReadData5, RegReadData6, RegReadData7 : std_logic_vector(31 DOWNTO 0);
	BEGIN
        -- Defining registers --
        Reg0 : Reg32 PORT MAP(clk => clk, Reset => Reset, enable => RegWriteEnable(0), InputValue => RegWriteData, StoredValue => RegReadData0);
        Reg1 : Reg32 PORT MAP(clk => clk, Reset => Reset, enable => RegWriteEnable(1), InputValue => RegWriteData, StoredValue => RegReadData1);
        Reg2 : Reg32 PORT MAP(clk => clk, Reset => Reset, enable => RegWriteEnable(2), InputValue => RegWriteData, StoredValue => RegReadData2);
        Reg3 : Reg32 PORT MAP(clk => clk, Reset => Reset, enable => RegWriteEnable(3), InputValue => RegWriteData, StoredValue => RegReadData3);
        Reg4 : Reg32 PORT MAP(clk => clk, Reset => Reset, enable => RegWriteEnable(4), InputValue => RegWriteData, StoredValue => RegReadData4);
        Reg5 : Reg32 PORT MAP(clk => clk, Reset => Reset, enable => RegWriteEnable(5), InputValue => RegWriteData, StoredValue => RegReadData5);
        Reg6 : Reg32 PORT MAP(clk => clk, Reset => Reset, enable => RegWriteEnable(6), InputValue => RegWriteData, StoredValue => RegReadData6);
        Reg7 : Reg32 PORT MAP(clk => clk, Reset => Reset, enable => RegWriteEnable(7), InputValue => RegWriteData, StoredValue => RegReadData7);

        ReadData1 <= RegReadData0 WHEN Rsrc1 = "000"
        ELSE RegReadData1 WHEN Rsrc1 = "001"
        ELSE RegReadData2 WHEN Rsrc1 = "010"
        ELSE RegReadData3 WHEN Rsrc1 = "011"
        ELSE RegReadData4 WHEN Rsrc1 = "100"
        ELSE RegReadData5 WHEN Rsrc1 = "101"
        ELSE RegReadData6 WHEN Rsrc1 = "110"
        ELSE RegReadData7;

        ReadData2 <= RegReadData0 WHEN Rsrc2 = "000"
        ELSE RegReadData1 WHEN Rsrc2 = "001"
        ELSE RegReadData2 WHEN Rsrc2 = "010"
        ELSE RegReadData3 WHEN Rsrc2 = "011"
        ELSE RegReadData4 WHEN Rsrc2 = "100"
        ELSE RegReadData5 WHEN Rsrc2 = "101"
        ELSE RegReadData6 WHEN Rsrc2 = "110"
        ELSE RegReadData7;

        RegWriteEnable <= "00000001" WHEN Rdst = "000" and RegWriteFlag = '1'
        ELSE "00000010" WHEN Rdst = "001" and RegWriteFlag = '1'
        ELSE "00000100" WHEN Rdst = "010" and RegWriteFlag = '1'
        ELSE "00001000" WHEN Rdst = "011" and RegWriteFlag = '1'
        ELSE "00010000" WHEN Rdst = "100" and RegWriteFlag = '1'
        ELSE "00100000" WHEN Rdst = "101" and RegWriteFlag = '1'
        ELSE "01000000" WHEN Rdst = "110" and RegWriteFlag = '1'
        ELSE "10000000" WHEN Rdst = "111" and RegWriteFlag = '1'
        ELSE "00000000";

END Registers_arch;
