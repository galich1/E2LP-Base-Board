----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:44:44 03/18/2021 
-- Design Name: 
-- Module Name:    baudRateGenerator - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY baudRateGenerator IS
	PORT (
		tick : OUT STD_LOGIC;
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC
	);
END baudRateGenerator;

ARCHITECTURE Behavioral OF baudRateGenerator IS

	SIGNAL brojac : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000"; -- 175 clk je 1 tick (omjer 27MHz i 16*9600baud rate)

BEGIN

	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF reset = '1' THEN
				brojac <= "00000000";
				tick <= '0';
			ELSE
				IF brojac = 175 THEN
					brojac <= "00000000";
					tick <= '1';
				ELSE
					tick <= '0';
					brojac <= brojac + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;

END Behavioral;