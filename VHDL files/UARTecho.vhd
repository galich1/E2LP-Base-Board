----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:15:05 03/19/2021 
-- Design Name: 
-- Module Name:    UARTecho - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UARTecho is
port(
 clk : in std_logic; -- signal takta	
 r_data : in std_logic_vector (7 downto 0); 
 w_data : out std_logic_vector (7 downto 0); 
 r_done : in std_logic; 
 w_done : in std_logic; 
w_start : out std_logic
);
end UARTecho;

architecture Behavioral of UARTecho is

begin

PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			if w_done = '1' then
				if r_done = '1' then
					
					w_data <= r_data;
					w_start <= '1';
				else 
					w_start <= '0';
					end if;
				else
					w_start <= '0';
				end if;
			end if;
			end process;
end Behavioral;

