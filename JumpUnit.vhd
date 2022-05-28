LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY JumpUnit IS
    PORT(
        JumpAllow: IN std_logic;
        JumpType : IN std_logic_vector(1 downto 0);
        Flags: IN std_logic_vector(2 downto 0);
        UpdatedFlags : OUT std_logic_vector(2 downto 0);
        JumpFlag : OUT std_logic
        );
END ENTITY JumpUnit;

ARCHITECTURE JumpUnit_arch OF JumpUnit IS
BEGIN
    JumpFlag <= '1' WHEN (JumpType = "00" and Flags(0) = '1') OR (JumpType = "01" and Flags(1) = '1') OR (JumpType = "10" and Flags(2) = '1') OR (JumpType = "11")
    ELSE '0';
    UpdatedFlags(0) <= '0' WHEN JumpType = "00" and Flags(0) = '1'
    ELSE Flags(0);
    UpdatedFlags(1) <= '0' WHEN JumpType = "01" and Flags(1) = '1'
    ELSE Flags(1);
    UpdatedFlags(2) <= '0' WHEN JumpType = "10" and Flags(2) = '1'
    ELSE Flags(2);
END JumpUnit_arch;	