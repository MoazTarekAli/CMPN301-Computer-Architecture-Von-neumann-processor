LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY ID_EXBuffer IS
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
END ENTITY ID_EXBuffer;

ARCHITECTURE ID_EXBuffer_arch OF ID_EXBuffer IS
    BEGIN
        PROCESS(clk, FlushAtNextFall, FlushNow)	
        BEGIN
            IF (falling_edge(clk) AND FlushAtNextFall = '1') OR FlushNow = '1' THEN
                ReadData1Out <= (others => '0');
                ReadData2Out <= (others => '0');
                ImmediateOut <= (others => '0');
                InputPortOut <= (others => '0');
                PCOut <= (others => '0');
                Rsrc1Out <= (others => '0');
                Rsrc2Out <= (others => '0');
                RdstOut <= (others => '0');
            ELSIF falling_edge(clk) AND Enable = '1' THEN
                ReadData1Out <= ReadData1;
                ReadData2Out <= ReadData2;
                ImmediateOut <= Immediate;
                InputPortOut <= InputPort;
                PCOut <= PC;
                Rsrc1Out <= Rsrc1;
                Rsrc2Out <= Rsrc2;
                RdstOut <= Rdst;
            END IF;
        END PROCESS;
END ID_EXBuffer_arch;	