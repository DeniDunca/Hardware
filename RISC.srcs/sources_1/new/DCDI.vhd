----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2022 11:01:37 AM
-- Design Name: 
-- Module Name: DCDI - Behavioral
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

entity DCDI is
 Port (Op: in std_logic_vector(31 downto 0);
         RegWr: out std_logic;
         AdrD: out std_logic_vector(3 downto 0);
         MxD: out std_logic_vector(1 downto 0);
         SSalt: out std_logic_vector(1 downto 0);
         CSalt: out std_logic;
         MemWr: out std_logic;
         OpUAL: out std_logic_vector(3 downto 0);
         MxA: out std_logic;
         MxB: out std_logic;
         AdrSA: out std_logic_vector(3 downto 0);
         AdrSB: out std_logic_vector(3 downto 0);
         SelC: out std_logic);
end DCDI;

architecture Behavioral of DCDI is

begin
process(Op)
begin
    --noop
    RegWr <= '0';
    MxD <= "00";
    SSalt <= "00";
    CSalt <= '0';
    MemWr <= '0';
    MxA <= '0';
    MxB <= '0';
    SelC <= '0';
    
    case Op(31 downto 24) is
        when x"40" =>  --mova
            RegWr <= '1';
        when x"02" =>  --add
            RegWr <= '1';
        when x"05" =>  --sub
            RegWr <= '1';
        when x"08" =>  --and
            RegWr <= '1';
        when x"09" =>  --or
            RegWr <= '1';
        when x"0A" =>  --xor
            RegWr <= '1';
        when x"0B" =>  --not
            RegWr <= '1';
        when x"22" =>  --addi
            RegWr <= '1';
            MxB <= '1';
            SelC <= '1';
        when x"25" =>  --subi
            RegWr <= '1';
            MxB <= '1';
            SelC <= '1';
        when x"28" =>  --andi
            RegWr <= '1';
            MxB <= '1';
        when x"29" =>  --ori
            RegWr <= '1';
            MxB <= '1';
        when x"2A" =>  --xori
            RegWr <= '1';
            MxB <= '1';
        when x"42" =>  --addu
            RegWr <= '1';
            MxB <= '1';
         when x"45" =>  --subu
            RegWr <= '1';
            MxB <= '1';
        when x"0C" =>  --movb
            RegWr <= '1';
        when x"0D" =>  --shr
            RegWr <= '1';
        when x"0E" =>  --shl 
            RegWr <= '1';          
        when x"70" =>  --jmpr
            SSalt <= "10";
        when x"60" =>  --bz
            SSalt <= "01";
            MxB <= '1';
            SelC <= '1';           
        when x"50" =>  --bnz
            SSalt <= "01";
            CSalt <= '1';
            MxB <= '1';
            SelC <= '1'; 
        when x"68" =>  --jmp
            SSalt <= "11";
            MxB <= '1';
            SelC <= '1';
        when x"69" =>  --halt
            SSalt <= "11";
            CSalt <= '1';
        when others => 
            SelC <= '0';
     end case;
end process;

AdrD <= Op(23 downto 20);
AdrSA <= Op(19 downto 16);
AdrSB <= Op(15 downto 12);
OpUAL <= Op(27 downto 24);
end Behavioral;
