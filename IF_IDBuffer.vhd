LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY IF_IDBuffer IS
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
END ENTITY IF_IDBuffer;

ARCHITECTURE IF_IDBuffer_arch OF IF_IDBuffer IS
    BEGIN
        PROCESS(clk, FlushAtNextFall, FlushNow)	
        BEGIN
            IF (falling_edge(clk) AND FlushAtNextFall = '1') OR FlushNow = '1' THEN
                OpCode <= (others => '0');
                PCOut <= (others => '0');
                InterruptFlagOut <= '0';
                Rsrc1 <= (others => '0');
                Rsrc2 <= (others => '0');
                Rdst <= (others => '0');
                Immediate <= (others => '0');
                InputPortOut <= (others => '0');
            ELSIF falling_edge(clk) AND Enable = '1' THEN
                OpCode <= Instruction(31 downto 27);
                Rdst <= Instruction(26 downto 24);
                Rsrc1 <= Instruction(23 downto 21);
                Rsrc2 <= Instruction(20 downto 18);
                Immediate(15 downto 0) <= Instruction(15 downto 0); 
                Immediate(31 downto 16) <= (others => '0');
                PCOut <= PC;
                InterruptFlagOut <= InterruptFlag;
                InputPortOut <= InputPort;
            END IF;
        END PROCESS;
END IF_IDBuffer_arch;	