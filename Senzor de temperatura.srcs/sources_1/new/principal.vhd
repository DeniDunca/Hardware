----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2022 08:50:27 PM
-- Design Name: 
-- Module Name: principal - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity principal is
 Port (clk: in STD_LOGIC;
       rst: in STD_LOGIC;
       scl: inout STD_LOGIC;
       sda: inout STD_LOGIC;
       err: buffer STD_LOGIC;
       an: out std_logic_vector(7 downto 0);
       seg: out std_logic_vector(7 downto 0));
end principal;

architecture Behavioral of principal is
signal temperature: std_logic_vector(12 downto 0);
signal temp_out : std_logic_vector(15 downto 0);
signal data: std_logic_vector(31 downto 0);
signal not_rst: STD_LOGIC;
begin

temp_out <= "000" & temperature;
data <= x"0000" & temp_out;
not_rst <= not rst;

temp: entity WORK.temp port map ( clk, not_rst, scl, sda, err,temperature);
                                 
                                  
display: entity WORK.displ7seg port map (clk, rst,data,an, seg);
                                         
                                
debouncer: entity WORK.debouncer port map (clk ,rst, not_rst);
                                           
end Behavioral;
