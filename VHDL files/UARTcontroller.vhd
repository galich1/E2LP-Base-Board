----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:40:57 03/19/2021 
-- Design Name: 
-- Module Name:    UARTcontroller - Behavioral 
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

entity UARTcontroller is
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
end UARTcontroller;

architecture Behavioral of UARTcontroller is

component UARTreceiver
port(
 reset : in std_logic; -- signal reseta	
rx : in std_logic;
tick : in std_logic;
d_out : out std_logic_vector(7 downto 0);
rx_done : out std_logic;
clk : in std_logic
);
end component;

component UARTtransmitter
port(
reset : in std_logic; -- signal reseta	
tx : out std_logic;
tick : in std_logic;
d_in : in std_logic_vector(7 downto 0);
tx_done : out std_logic; 
tx_start : in std_logic;
clk : in std_logic
);
end component;

component baudRateGenerator
port(
tick: out std_logic;
clk : in std_logic;
reset : in std_logic
);
end component;

signal tick : std_logic;
begin

rec : component UARTreceiver port map (clk => clk,reset => reset,rx => rx, d_out => r_data,rx_done => r_done, tick => tick);
trans : component UARTtransmitter port map (clk => clk,reset => reset,tx => tx, d_in => w_data,tx_done => w_done, tick => tick, tx_start => w_start);
baud : component baudRateGenerator port map (clk => clk, reset => reset, tick => tick);


end Behavioral;

