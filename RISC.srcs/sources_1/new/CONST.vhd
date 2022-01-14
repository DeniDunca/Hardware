----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2022 10:46:32 AM
-- Design Name: 
-- Module Name: CONST - Behavioral
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

entity CONST is
  Port (x: in std_logic_vector(15 downto 0);
         SelC: in std_logic;
         y: out std_logic_vector(31 downto 0));
end CONST;

architecture Behavioral of CONST is

begin

    y <= "0000000000000000" & x when SelC = '0' else 
          "0000000000000000" & x when SelC = '1' and x(15) = '0' else
          "1111111111111111" & x when SelC = '1' and x(15) = '1';

end Behavioral;
