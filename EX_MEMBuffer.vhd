LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY EX_MEMBuffer IS
    PORT(
        clk: IN std_logic;
        FlushAtNextFall: IN std_logic;
        FlushNow: IN std_logic;
        Enable: IN std_logic;

        ReadData1 : IN std_logic_vector(31 downto 0);
        EXResult : IN std_logic_vector(31 DOWNTO 0);
        PC : IN std_logic_vector(19 DOWNTO 0);
        Flags : IN std_logic_vector(3 DOWNTO 0);
        Rdst : IN std_logic_vector(2 DOWNTO 0);
        
        ReadData1Out : OUT std_logic_vector(31 downto 0);
        EXResultOut : OUT std_logic_vector(31 DOWNTO 0);
        FlagsConcatenatedPCOut: OUT std_logic_vector(31 DOWNTO 0);
        RdstOut : OUT std_logic_vector(2 DOWNTO 0));
END ENTITY EX_MEMBuffer;

ARCHITECTURE EX_MEMBuffer_arch OF EX_MEMBuffer IS
    BEGIN
        PROCESS(clk, FlushAtNextFall, FlushNow)	
        BEGIN
            IF (falling_edge(clk) AND FlushAtNextFall = '1') OR FlushNow = '1' THEN
                ReadData1Out <= (others => '0');
                EXResultOut <= (others => '0');
                FlagsConcatenatedPCOut <= (others => '0');
                RdstOut <= (others => '0');
            ELSIF falling_edge(clk) AND Enable = '1' THEN
                ReadData1Out <= ReadData1;
                EXResultOut <= EXResult;
                FlagsConcatenatedPCOut(23 DOWNTO 0) <= Flags & PC;
                FlagsConcatenatedPCOut(31 DOWNTO 24) <= (others => '0');
                RdstOut <= Rdst;
            END IF;
        END PROCESS;
END EX_MEMBuffer_arch;	