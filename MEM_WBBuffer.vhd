
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MEM_WBBuffer IS
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
END ENTITY MEM_WBBuffer;

ARCHITECTURE MEM_WBBuffer_arch OF MEM_WBBuffer IS
    BEGIN
        PROCESS(clk, FlushAtNextFall, FlushNow)	
        BEGIN
            IF (falling_edge(clk) AND FlushAtNextFall = '1') OR FlushNow = '1' THEN
                DataMemoryOut <= (others => '0');
                EXResultOut <= (others => '0');
                RdstOut <= (others => '0');
            ELSIF falling_edge(clk) AND Enable = '1' THEN
                DataMemoryOut <= DataMemory;
                EXResultOut <= EXResult;
                RdstOut <= Rdst;
            END IF;
        END PROCESS;
END MEM_WBBuffer_arch;	