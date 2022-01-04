----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2021 02:48:02 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
    Port ( readData1 : in STD_LOGIC_VECTOR (15 downto 0);
           readData2 : in STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
           PC : in STD_LOGIC_VECTOR (15 downto 0);
           aluSRC : in STD_LOGIC;
           shift : in STD_LOGIC;
           aluOP : in STD_LOGIC_VECTOR (2 downto 0);
           aluRES : out STD_LOGIC_VECTOR (15 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           zero : out STD_LOGIC;
           branchadr : out STD_LOGIC_VECTOR (15 downto 0);
           ltz : out STD_LOGIC
           );
end EX;

architecture Behavioral of EX is
signal mux : STD_LOGIC_VECTOR (15 downto 0);
signal aluCTRL: STD_LOGIC_VECTOR (2 downto 0);
signal op2 : STD_LOGIC_VECTOR (15 downto 0);
signal less: STD_LOGIC;
signal result : STD_LOGIC_VECTOR (15 downto 0);

begin
branchadr <= PC + 1 + ext_imm;
process(aluSRC)
begin
    if aluSRC = '1' then
        mux <= ext_imm;
    else
        mux <= readData2;
    end if;
end process;

process(aluOP, func)
begin
case aluOP is
    when "000" =>
            case func is
                when "000" => aluCTRL <= "000";--add
                when "001" => aluCTRL <= "001";--sub
                when "010" => aluCTRL <= "010";--sll
                when "011" => aluCTRL <= "011";--srl
                when "100" => aluCTRL <= "100";--and
                when "101" => aluCTRL <= "101";--or
                when "110" => aluCTRL <= "110";--multu
                when others => aluCTRL <= "111";--xor
            end case;
    when "001" => aluCTRL <= "000";--addi
    when "010" => aluCTRL <= "000";--lw
    when "011" => aluCTRL <= "000";--sw
    when "100" => aluCTRL <= "001";--beq
    when "101" => aluCTRL <= "101";--ori
    when "111" => aluCTRL <= "001";--bltz
    when others => aluCTRL <= "000";--jump
end case;
end process;
      
process(readData1, aluCTRL, op2)
begin
case(aluCTRL) is
      when "000" => result <= readData1 + op2;--add
      when "001" => result <= readData1 - op2;--sub
      when "010" => --sll
      if shift = '0' then result <= readData1(14 downto 0) &'0';
      else result <= readData1 (13 downto 0) & "00";
      end if;
      
      when "011" => --sr
      if shift = '0' then result <= '0' & readData1(15 downto 1);
      else result <= "00" & readData1(15 downto 2);
      end if;
      
      when "100" => result <= readData1 and op2;--and
      when "101" => result <= readData1 or op2;--or
      when "110" => result <= readData1(7 downto 0) * op2(7 downto 0);--multu cu srl
      when others => result <= readData1 xor op2;--xor
end case;
end process;

alures <= result;

process(result)
begin
    if result = x"0000" then 
        zero <= '1';
    else
        zero <= '0';
    end if;
end process;


process(result)
begin
    if result(15) = '1' then 
        ltz <= '1';
    else
        ltz <= '0';
    end if;
end process;

end Behavioral;
