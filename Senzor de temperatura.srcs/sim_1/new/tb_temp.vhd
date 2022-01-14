----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2022 09:33:09 PM
-- Design Name: 
-- Module Name: tb_temp - Behavioral
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

entity tb_temp is
end tb_temp;

architecture Behavioral of tb_temp is
signal Clk, Rst, not_rst: std_logic;
signal ack_err, sda, scl: std_logic;
signal data_in, data_out: std_logic_vector(7 downto 0);
signal temp: std_logic_vector(12 downto 0);
constant CLK_PERIOD : TIME := 10 ns;
begin
i2c: entity work.temp port map(Clk, not_rst, scl, sda, ack_err, temp);
nRst <= not Rst;

clk_gen: process
begin
    Clk <= '0';
    wait for (clk_period/2);
    Clk <= '1';
    wait for (clk_period/2);
end process;

gen_scl: process
begin
    scl <= '0';
    wait for clk_period;
    scl <= 'H';
    wait for clk_period;
end process;

sim: process
begin
    wait for 100 ns;
    Rst <= '1';
    wait for 100 ns;
    Rst <= '0';
    wait for 100 ns;
    sda <= 'H';
    wait for 15 ns;
    sda <= '0'; 
 wait;
end process;

end Behavioral;
