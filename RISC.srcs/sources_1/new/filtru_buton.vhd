----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/10/2022 10:48:19 AM
-- Design Name: 
-- Module Name: filtru_buton - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filtru_buton is
  Port ( Clk  : in  STD_LOGIC;
           Rst  : in  STD_LOGIC;
           Din  : in  STD_LOGIC;
           Qout : out STD_LOGIC);
end filtru_buton;

architecture Behavioral of filtru_buton is
    signal Cnt : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal Q1  : STD_LOGIC := '0';
    signal Q2  : STD_LOGIC := '0';
    signal Q3  : STD_LOGIC := '0';
begin

    process (Clk)
    begin
        if rising_edge (Clk) then
            if Rst = '1' then
                Cnt <= (others => '0');
            else
                Cnt <= Cnt + 1;
            end if;
        end if;
    end process;		   

    process (Clk)
    begin
        if rising_edge (Clk) then
            if (Rst = '1') then
                Q1 <= '0';
            elsif Cnt = x"FFFF" then
                Q1 <= Din;
            end if;
        end if;
    end process;	  

    process (Clk)
    begin
        if rising_edge (Clk) then
            if (Rst = '1') then
                Q2 <= '0';
                Q3 <= '0'; 
            else
                Q2 <= Q1;
                Q3 <= Q2;
            end if;
        end if;
    end process;
 
    Qout <= Q2 and (not Q3);
end Behavioral;
