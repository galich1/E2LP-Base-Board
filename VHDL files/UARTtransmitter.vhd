----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:20:33 03/17/2021 
-- Design Name: 
-- Module Name:    UARTtransmitter - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
USE IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY UARTtransmitter IS
	PORT (
		reset : IN STD_LOGIC; -- signal reseta	
		tx : OUT STD_LOGIC;
		tick : IN STD_LOGIC;
		d_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		tx_done : OUT STD_LOGIC ;
		tx_start : IN STD_LOGIC;
		clk : IN STD_LOGIC
	);
END UARTtransmitter;

ARCHITECTURE Behavioral OF UARTtransmitter IS
	TYPE Stanje IS (Pocetno, Aktivno, Podatkovno, Izlazno);
	SIGNAL omoguciPrijelaz : STD_LOGIC;
	SIGNAL trenutnoStanje : Stanje := Pocetno;
	SIGNAL sljedeceStanje : Stanje := Pocetno;
	SIGNAL brojac : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL brojBitovaPrenesenih : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
	SIGNAL shiftRegistar : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
BEGIN

	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF reset = '1' THEN
				trenutnoStanje <= Pocetno;
			ELSE
				trenutnoStanje <= sljedeceStanje;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (tick)
	BEGIN
		IF rising_edge(tick) THEN
			IF reset = '1' THEN
					tx_done <='1';
					sljedeceStanje <= Pocetno;
					
			else
					CASE trenutnoStanje IS
						WHEN Pocetno =>
							tx <='1';
							tx_done <='1';
							if tx_start = '1' then
								tx_done <='0';
								tx <= '0';
								sljedeceStanje <= Podatkovno;
								shiftRegistar <= d_in;
							end if;

						WHEN Podatkovno =>
							brojac <= brojac + 1;
							IF brojac = 15 THEN
								IF brojBitovaPrenesenih = 7 THEN
									tx <= shiftRegistar(0);
									shiftRegistar <='0' & shiftRegistar(7 downto 1);
									sljedeceStanje <= Izlazno;
									brojac <= "0000";
									brojBitovaPrenesenih <= "000";
								ELSE
									tx <= shiftRegistar(0);
									
									shiftRegistar <='0' & shiftRegistar(7 downto 1);
									brojBitovaPrenesenih <= brojBitovaPrenesenih + 1;
									brojac <= "0000";

								END IF;
							END IF;

						WHEN Izlazno =>
							brojac <= brojac + 1;
							IF brojac = 15 THEN
								sljedeceStanje <= Pocetno;
								tx <= '1';
								tx_done <= '1';
								
								brojac <= "0000";
							END IF;

						WHEN OTHERS =>
							NULL;
					END CASE;
				END IF;
		END IF;
	END PROCESS;

END Behavioral;