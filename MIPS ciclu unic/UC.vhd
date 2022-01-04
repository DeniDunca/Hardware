----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2021 02:34:49 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
    Port ( instruction : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           Branch : out STD_LOGIC;
           BranchLTZ : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUsrc : out STD_LOGIC;
           MEMwrite : out STD_LOGIC;
           MEMtoREG : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           ALUop : out STD_LOGIC_VECTOR (2 downto 0));
end UC;

architecture Behavioral of UC is

begin
process(instruction)
begin 
    case instruction is
        when "000" =>--tip R
            RegWrite <= '1';
            RegDst <= '1';
            ALUsrc <= '0';
            ExtOp <= '0';
            ALUop <= instruction;
            MEMwrite <= '0';
            MEMtoREG <= '0';
            Branch <= '0';
            Jump <= '0';
            BranchLTZ <= '0';
    
            
        when "001" =>--addi
            RegWrite <= '1';
            RegDst <= '0';
            ALUsrc <= '1';
            ExtOp <= '1';
            ALUop <= instruction;
            MEMwrite <= '0';
            MEMtoREG <= '0';
            Branch <= '0';
            Jump <= '0';
            BranchLTZ <= '0';       

        when "010" =>--lw
            RegWrite <= '0';
            RegDst <= '0';
            ALUsrc <= '1';
            ExtOp <= '1';
            ALUop <= instruction;
            MEMwrite <= '0';
            MEMtoREG <= '1';
            Branch <= '0';
            Jump <= '0';
            BranchLTZ <= '0';
   
        when "011" =>--sw
            RegWrite <= '0';
            RegDst <= '0';
            ALUsrc <= '1';
            ExtOp <= '1';
            ALUop <= instruction;
            MEMwrite <= '1';
            MEMtoREG <= '0';
            Branch <= '0';
            Jump <= '0';
            BranchLTZ <= '0';       
       
        when "100" =>--beq
            RegWrite <= '0';
            RegDst <= '0';
            ALUsrc <= '1';
            ExtOp <= '1';
            ALUop <= instruction;
            MEMwrite <= '0';
            MEMtoREG <= '0';
            Branch <= '1';
            Jump <= '0';
            BranchLTZ <= '0';
            
        when "101" =>--ori
            RegWrite <= '1';
            RegDst <= '0';
            ALUsrc <= '0';
            ExtOp <= '1';
            ALUop <= instruction;
            MEMwrite <= '0';
            MEMtoREG <= '0';
            Branch <= '0';
            Jump <= '0';
            BranchLTZ <= '0';
            
        when "110" =>--jump
            RegWrite <= '0';
            RegDst <= '0';
            ALUsrc <= '0';
            ExtOp <= '0';
            ALUop <= instruction;
            MEMwrite <= '0';
            MEMtoREG <= '0';
            Branch <= '0';
            Jump <= '1';
            BranchLTZ <= '0';
            
        when others =>--bltz
            RegWrite <= '0';
            RegDst <= '0';
            ALUsrc <= '0';
            ExtOp <= '1';
            ALUop <= instruction;
            MEMwrite <= '0';
            MEMtoREG <= '0';
            Branch <= '1';
            Jump <= '0';
            BranchLTZ <= '1';
      
    end case;
end process;
  
end Behavioral;
