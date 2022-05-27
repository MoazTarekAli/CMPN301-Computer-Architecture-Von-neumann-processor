LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ALU IS
	PORT(
		ALUControlSignals : IN std_logic_vector(2 DOWNTO 0);
        FirstOperand      : IN std_logic_vector(31 DOWNTO 0);
        SecondOperand     : IN std_logic_vector(31 DOWNTO 0);
        ALUResult         : OUT std_logic_vector(31 DOWNTO 0);
        Flags             : OUT std_logic_vector(3 DOWNTO 0));
END ENTITY ALU;

ARCHITECTURE ALU_arch OF ALU IS
	BEGIN
		PROCESS(ALUControlSignals, FirstOperand, SecondOperand) IS
            VARIABLE ALUResultTemp : std_logic_vector(32 DOWNTO 0);
            VARIABLE FlagsTemp : std_logic_vector(3 DOWNTO 0);
			BEGIN
                -- Intialize FlagsTemp to 0
                FlagsTemp(2) := '0';
                FlagsTemp(3) := '0';

                -- ALU Control Signals and Carry Flag
                IF    (ALUControlSignals = "001") THEN
                    ALUResultTemp := std_logic_vector(to_signed(to_integer(signed(FirstOperand) + signed(SecondOperand)), 33));
                    FlagsTemp(2) := ALUResultTemp(32);
                ELSIF (ALUControlSignals = "010") THEN
                    ALUResultTemp := std_logic_vector(to_signed(to_integer(signed(FirstOperand) - signed(SecondOperand)), 33));
                    IF (FirstOperand > SecondOperand) THEN
                        FlagsTemp(2) := '1';
                    else
                        FlagsTemp(2) := '0';
                    end if;
                ELSIF (ALUControlSignals = "011") THEN
                    ALUResultTemp := '0' & (FirstOperand and SecondOperand);
                ELSIF (ALUControlSignals = "100") THEN
                    ALUResultTemp := '0' & (not FirstOperand);
                ELSIF (ALUControlSignals = "101") THEN
                    ALUResultTemp := std_logic_vector(to_signed(to_integer(signed(FirstOperand) + 1), 33));
                ELSIF (ALUControlSignals = "000") THEN
                    ALUResultTemp := '0' & FirstOperand;
                ELSIF (ALUControlSignals = "111") THEN
                    ALUResultTemp := '0' & SecondOperand;
                ELSE
                    ALUResultTemp := (others => '0');
                END IF;

                -- Check for zero flag
                IF (unsigned(ALUResultTemp) = 0) THEN
                    FlagsTemp(0) := '1';
                ELSE
                    FlagsTemp(0) := '0';
                END IF;

                -- Check for negative flag
                FlagsTemp(1) := ALUResultTemp(31);
                
                -- Assigning results
                ALUResult <= ALUResultTemp(31 DOWNTO 0);
                Flags <= FlagsTemp;
            END PROCESS;
END ALU_arch;
