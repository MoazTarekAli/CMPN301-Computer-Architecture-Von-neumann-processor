LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MEM_CU_Buffer IS
    PORT(
        clk: IN std_logic;
        Flush: IN std_logic;
        Enable: IN std_logic;
        
        SPSelector : IN std_logic;
        PushOrPopSelector : IN std_logic;
        CallOrReturnSelector : IN std_logic;
        MemoryRead : IN std_logic;
        MemoryWrite : IN std_logic;
        AddressSelector : IN std_logic_vector(1 downto 0);
        WriteDateSelector : IN std_logic;
        InterruptOrCallOrReturn : IN std_logic;
        
        SPSelectorOut : OUT std_logic;
        PushOrPopSelectorOut : OUT std_logic;
        CallOrReturnSelectorOut : OUT std_logic;
        MemoryReadOut : OUT std_logic;
        MemoryWriteOut : OUT std_logic;
        AddressSelectorOut : OUT std_logic_vector(1 downto 0);
        WriteDateSelectorOut : OUT std_logic;
        InterruptOrCallOrReturnOut : OUT std_logic);
END ENTITY MEM_CU_Buffer;

ARCHITECTURE MEM_CU_Buffer_arch OF MEM_CU_Buffer IS
    BEGIN
        PROCESS(clk, Flush)	
        BEGIN
            IF Flush = '1' THEN
                SPSelectorOut <= '0';
                PushOrPopSelectorOut <= '0';
                CallOrReturnSelectorOut <= '0';
                MemoryReadOut <= '0';
                MemoryWriteOut <= '0';
                AddressSelectorOut <= "00";
                WriteDateSelectorOut <= '0';
                InterruptOrCallOrReturnOut <= '0';
            ELSIF falling_edge(clk) AND Enable = '1' THEN
                SPSelectorOut <= SPSelector;
                PushOrPopSelectorOut <= PushOrPopSelector;
                CallOrReturnSelectorOut <= CallOrReturnSelector;
                MemoryReadOut <= MemoryRead;
                MemoryWriteOut <= MemoryWrite;
                AddressSelectorOut <= AddressSelector;
                WriteDateSelectorOut <= WriteDateSelector;
                InterruptOrCallOrReturnOut <= InterruptOrCallOrReturn;
            END IF;
        END PROCESS;
END MEM_CU_Buffer_arch;	
