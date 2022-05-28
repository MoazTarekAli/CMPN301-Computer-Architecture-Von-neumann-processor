LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Memory IS
	PORT(
		clk         : IN std_logic;
		WriteEnable : IN std_logic;
		ReadEnable  : IN std_logic;
		Reset       : IN std_logic; 
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
		PROCESS(clk, Reset) IS
			BEGIN
				-- checking for reset to get M[0]
				IF (Reset = '1') THEN
					Intruction <= ram(0);
					dataout <= (others => 'Z');
				ELSIF rising_edge(clk) THEN			
					-- checking for write
					IF WriteEnable = '1' THEN
						ram(to_integer(unsigned(address))) <= datain;
						Intruction <= (others => 'Z');
						dataout <= (others => 'Z');
						-- checking for read
					ELSIF ReadEnable = '1' THEN
						dataout <= ram(to_integer(unsigned(address)));
						Intruction <= (others => 'Z');
					-- default taking PC
					ELSE
						Intruction <= ram(to_integer(unsigned(ProgramCounter)));
						dataout <= (others => 'Z');
					END IF;               
				END IF;
		END PROCESS;
END syncrama;
