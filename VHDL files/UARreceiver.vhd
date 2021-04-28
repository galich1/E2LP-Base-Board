----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:28:00 03/17/2021 
-- Design Name: 
-- Module Name:    UARTreceiver - Behavioral 
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
USE ieee.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY UARTreceiver IS
	PORT (
		reset : IN STD_LOGIC; -- signal reseta	
		rx : IN STD_LOGIC;
		tick : IN STD_LOGIC;
		d_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		rx_done : OUT STD_LOGIC;
		clk : IN STD_LOGIC
	);
END UARTreceiver;

	ARCHITECTURE Behavioral OF UARTreceiver IS

	TYPE Stanje IS (Pocetno, Aktivno, Podatkovno, Izlazno);
	SIGNAL trenutnoStanje : Stanje := Pocetno;
	SIGNAL sljedeceStanje : Stanje := Pocetno;
	SIGNAL brojac : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL brojBitovaPrenesenih : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
	SIGNAL shiftRegistar :  STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
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
			if reset = '1' then
				rx_done <='0';
				sljedeceStanje <= Pocetno;
			else
			
				CASE trenutnoStanje IS
					WHEN Pocetno =>
						rx_done <= '0';
						IF rx = '0' THEN
							sljedeceStanje <= Aktivno;
						END IF;
					WHEN Aktivno =>
						brojac <= brojac + 1;
						IF brojac = 7 THEN
							sljedeceStanje <= Podatkovno;
							brojac <= "0000";
						END IF;

					WHEN Podatkovno =>
						brojac <= brojac + 1;
						IF brojac = 15 THEN
							IF brojBitovaPrenesenih = 7 THEN
								shiftRegistar <='0' & shiftRegistar(7 downto 1);
								shiftRegistar(7) <= rx;
								sljedeceStanje <= Izlazno;
								brojac <= "0000";
								brojBitovaPrenesenih <= "000";
							ELSE
								shiftRegistar <='0' & shiftRegistar(7 downto 1);
								shiftRegistar(7) <= rx;
								brojac <= "0000";
								brojBitovaPrenesenih <= brojBitovaPrenesenih + 1;

							END IF;
						END IF;

					WHEN Izlazno =>
						brojac <= brojac + 1;
						IF brojac = 15 THEN
							sljedeceStanje <= Pocetno;
							rx_done <= '1';
							
							brojac <= "0000";
						END IF;
					WHEN OTHERS =>
						NULL;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
d_out <= shiftRegistar;
	

END Behavioral;----------------------------------------------------------------------------------
