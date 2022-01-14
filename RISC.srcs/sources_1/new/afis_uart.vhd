----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/10/2022 10:56:31 AM
-- Design Name: 
-- Module Name: afis_uart - Behavioral
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

entity afis_uart is
  Port ( Clk      : in STD_LOGIC;
           Rst      : in STD_LOGIC;
           AdrInstr : in STD_LOGIC_VECTOR (31 downto 0);
           Instr    : in STD_LOGIC_VECTOR (31 downto 0);
           RA       : in STD_LOGIC_VECTOR (31 downto 0);
           RB       : in STD_LOGIC_VECTOR (31 downto 0);
           F        : in STD_LOGIC_VECTOR (31 downto 0);
           Send     : in STD_LOGIC;
           Tx       : out STD_LOGIC;
           Rdy      : out STD_LOGIC);
end afis_uart;

architecture Behavioral of afis_uart is
    signal Data1    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data2    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data3    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data4    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data5    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data6    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data7    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data8    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    
begin

    conv_uart_i:    entity WORK.conv_uart port map (
                        AdrInstr => AdrInstr,
                        Instr => Instr,
                        RA => RA,
                        RB => RB,
                        F  => F,
                        Data1 => Data1,
                        Data2 => Data2,
                        Data3 => Data3,
                        Data4 => Data4,
                        Data5 => Data5,
                        Data6 => Data6,
                        Data7 => Data7,
                        Data8 => Data8);

    uart_send64_i:  entity WORK.uart_send64 port map (
                        Clk => Clk,
                        Rst => Rst,
                        Data1 => Data1,
                        Data2 => Data2,
                        Data3 => Data3,
                        Data4 => Data4,
                        Data5 => Data5,
                        Data6 => Data6,
                        Data7 => Data7,
                        Data8 => Data8,
                        Send => Send,
                        Tx => Tx,
                        Rdy => Rdy);


end Behavioral;
