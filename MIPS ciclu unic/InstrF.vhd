----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2021 02:29:01 PM
-- Design Name: 
-- Module Name: InstrF - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstrF is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           jump : in STD_LOGIC;
           PCsrc : in STD_LOGIC;
           jadr : in STD_LOGIC_VECTOR (15 downto 0);
           badr : in STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0);
           pc1 : out STD_LOGIC_VECTOR (15 downto 0));
end InstrF;

architecture Behavioral of InstrF is
type ROM is array(0 to 255) of std_logic_vector(15 downto 0);
signal srom: ROM := (b"000_000_000_000_0_111",
                     b"001_000_001_0000000",
                     b"001_000_010_1111110",
                     b"111_010_000_0001010",
                     b"001_000_011_0000110",
                     b"001_000_100_0000011",
                     b"001_000_101_0000010",
                     b"010_011_110_0000000",
                     b"000_110_100_110_0_110",
                     b"000_110_010_110_0_001",
                     b"000_000_110_110_0_011",
                     b"000_001_110_001_0_000",
                     b"001_010_010_0000001",
                     b"110_0000000000100",
                     b"011_001_111_0000000",
                     others => "0000000000000000");
signal sPC : STD_LOGIC_VECTOR (15 downto 0);
signal nPC : STD_LOGIC_VECTOR (15 downto 0);
signal bmux: STD_LOGIC_VECTOR (15 downto 0);
signal rez: STD_LOGIC_VECTOR (15 downto 0);
signal adr: STD_LOGIC_VECTOR (15 downto 0);
begin

process(PCsrc)
begin
    if PCsrc = '1' then
    bmux <= badr;
    else
    bmux <= nPC;
    end if;
end process; 
        
process(jump)
begin
    if jump = '1' then
        rez <= jadr;
    else
        rez <= bmux;
    end if;
end process;

process (enable, clk, reset, rez)
begin
    if clk='1' and clk'event then
        if reset = '1' then
            sPC <= x"0000";
        elsif enable = '1' then
            sPC <= rez;
        end if;
    end if;
end process;

nPC <= sPC + 1;

 process(clk)
    begin
    if clk='1' and clk'event then
        if enable  ='1' then
            adr <= sPC;
        end if; 
    end if;
    end process;
    
    instr <= srom(conv_integer(sPC));
    pc1 <= nPC;
        

end Behavioral;
