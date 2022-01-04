----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2021 02:14:13 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
    Port ( instr : in STD_LOGIC_VECTOR (15 downto 0);
           rw : in STD_LOGIC;
           rd : in STD_LOGIC;
           extOp : in STD_LOGIC;
           clk : in STD_LOGIC;
           writeData : in STD_LOGIC_VECTOR (15 downto 0);
           readData1 : out STD_LOGIC_VECTOR (15 downto 0);
           readData2 : out STD_LOGIC_VECTOR (15 downto 0);
           imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           shift : out STD_LOGIC);
end ID;

architecture Behavioral of ID is
type reg is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
signal sreg : reg := ( others => "0000000000000000");
signal swa : STD_LOGIC_VECTOR (2 downto 0) := "000";--intra ce iese de la mux
begin
--regfile
process(clk)
begin
    if clk='1' and clk'event then
        if rw = '1' then
            sreg(conv_integer(swa)) <= writeData;
        end if;
    end if;
end process;

--swa <= Instr(9 downto 7 ) when rd = '0' else Instr(6 downto 4);--mux
--mux
process(rd)
begin
    if rd = '0' then
        swa <= Instr(9 downto 7 );
    else
        swa <= Instr(6 downto 4 );
    end if;
end process;
--extop
process(Instr(6 downto 0), extOp)
begin
    if extOp = '1' then
        if Instr(6) = '1' then
            imm <= "111111111" & Instr( 6 downto 0);
        end if;
    else
        imm <= "000000000" & Instr(6 downto 0);
    end if;
end process;

readData1 <= sreg(conv_integer(Instr(12 downto 10)));
readData2 <= sreg(conv_integer(Instr(9 downto 7)));

func <= Instr(2 downto 0);
shift <= Instr(3);

end Behavioral;
