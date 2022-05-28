LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY WB_CU_Buffer IS
    PORT(
        clk: IN std_logic;
        FlushAtNextFall: IN std_logic;
        FlushNow: IN std_logic;
        Enable: IN std_logic;
        
        RegWriteFlag : IN std_logic;
        MEMDataOrEXResultSelector : IN std_logic;
        
        RegWriteFlagOut : OUT std_logic;
        MEMDataOrEXResultSelectorOut : OUT std_logic);
END ENTITY WB_CU_Buffer;

ARCHITECTURE WB_CU_Buffer_arch OF WB_CU_Buffer IS
    BEGIN
        PROCESS(clk, FlushAtNextFall, FlushNow)	
        BEGIN
            IF (falling_edge(clk) AND FlushAtNextFall = '1') OR FlushNow = '1' THEN
                RegWriteFlagOut <= '0';
                MEMDataOrEXResultSelectorOut <= '0';
            ELSIF falling_edge(clk) AND Enable = '1' THEN
                RegWriteFlagOut <= RegWriteFlag;
                MEMDataOrEXResultSelectorOut <= MEMDataOrEXResultSelector;
            END IF;
        END PROCESS;
END WB_CU_Buffer_arch;	