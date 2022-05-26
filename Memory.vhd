LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Memory IS
	PORT(
		clk         : IN std_logic;
		WriteEnable : IN std_logic;
		ReadEnable  : IN std_logic;
		address     : IN  std_logic_vector(19 DOWNTO 0);
        ProgramCounter : IN  std_logic_vector(19 DOWNTO 0);
		datain      : IN  std_logic_vector(31 DOWNTO 0);
		dataout     : OUT std_logic_vector(31 DOWNTO 0);
        Intruction  : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY Memory;

ARCHITECTURE syncrama OF Memory IS
	TYPE ram_type IS ARRAY(0 TO 249999) OF std_logic_vector(31 DOWNTO 0);
	SIGNAL ram : ram_type;
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN
                    -- checking for write
					IF WriteEnable = '1' THEN
						ram(to_integer(unsigned(address))) <= datain;
					END IF;

                    -- checking for read
					IF ReadEnable = '1' THEN
						dataout <= ram(to_integer(unsigned(address)));
					ELSE
						dataout <= (others => 'Z');
					END IF;

                    -- checking for instruction
                    IF ReadEnable = '0' and WriteEnable = '0' THEN
						Intruction <= ram(to_integer(unsigned(ProgramCounter)));
					ELSE
						Intruction <= (others => 'Z');
					END IF;                    
				END IF;
		END PROCESS;
END syncrama;
