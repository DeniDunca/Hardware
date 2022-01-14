----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/10/2022 10:57:12 AM
-- Design Name: 
-- Module Name: implem_RISC - Behavioral
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
use WORK.RISC_pkg.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity implem_RISC is
  Port ( Clk     : in  STD_LOGIC;
           Rst     : in  STD_LOGIC;
           BtnStep : in  STD_LOGIC;
           Tx      : out STD_LOGIC;
           Rdy     : out STD_LOGIC;
           ZF      : out STD_LOGIC;
           CF      : out STD_LOGIC);
end implem_RISC;

architecture Behavioral of implem_RISC is

    signal AdrInstr : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal Instr    : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal RA       : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal RB       : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal F        : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal Data1    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data2    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data3    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data4    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data5    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data6    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data7    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal Data8    : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
    signal ClkStep  : STD_LOGIC := '0';

begin

    proc_RISC_i:    entity WORK.proc_RISC  port map (
                        Clk => ClkStep,
                        Rst => Rst,
                        AdrInstr => AdrInstr,
                        Instr => Instr,
                        Data => open,
                        RA => RA,
                        RB => RB,
                        F  => F,
                        ZF => ZF,
                        CF => CF);

    filtru_buton_i: entity WORK.filtru_buton port map (
                        Clk => Clk,
                        Rst => Rst,
                        Din => BtnStep,
                        Qout => ClkStep);

    afis_uart_i:    entity work.afis_uart port map (
                        Clk => Clk,
                        Rst => Rst,
                        AdrInstr => AdrInstr,
                        Instr => Instr,
                        RA => RA,
                        RB => RB,
                        F => F,
                        Send => ClkStep,
                        Tx => Tx,
                        Rdy => Rdy);


end Behavioral;
