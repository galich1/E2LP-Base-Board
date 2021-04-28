----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:21:26 03/17/2021 
-- Design Name: 
-- Module Name:    UARTtop - Behavioral 
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
USE ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UARTtop is
port(
 clk : in std_logic; -- signal takta
 reset : in std_logic; -- signal reseta	
 rx : in std_logic;
 tx : out std_logic
);
end UARTtop;

architecture Behavioral of UARTtop is

component UARTcontroller
port(
 clk : in std_logic; -- signal takta
 reset : in std_logic; -- signal reseta	
 rx : in std_logic;
 tx : out std_logic;
 r_data : out std_logic_vector (7 downto 0); 
 w_data : in std_logic_vector (7 downto 0); 
 r_done : out std_logic; 
 w_done : out std_logic; 
w_start : in std_logic
);
end component;



component UARTecho
port(
 clk : in std_logic; -- signal takta	
 r_data : in std_logic_vector (7 downto 0); 
 w_data : out std_logic_vector (7 downto 0); 
 r_done : in std_logic; 
 w_done : in std_logic; 
w_start : out std_logic
);
end component;

signal rDataTransfer : std_logic_vector(7 downto 0);
signal recieveDoneTransfer : std_logic;
signal wDataTransfer : std_logic_vector(7 downto 0);
signal transmitDoneTransfer : std_logic;
signal transmitStartTransfer : std_logic;


begin



cont : component UARTcontroller port map (clk => clk,reset => reset,rx => rx, tx => tx, r_data => rDataTransfer,r_done => recieveDoneTransfer, w_data => wDataTransfer, w_done => transmitDoneTransfer, w_start =>transmitStartTransfer );
echo : component UARTecho port map(clk => clk,r_data => rDataTransfer,r_done => recieveDoneTransfer, w_data => wDataTransfer, w_done => transmitDoneTransfer, w_start =>transmitStartTransfer );
end Behavioral;

