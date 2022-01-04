----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2021 03:02:45 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG 
    port (en : out STD_LOGIC;
           input : in STD_LOGIC;
           clock : in STD_LOGIC);
end component MPG;

component SSD
 Port ( clk : in STD_LOGIC;
          input0 : in STD_LOGIC_VECTOR (3 downto 0);
          input1 : in STD_LOGIC_VECTOR (3 downto 0);
          input2 : in STD_LOGIC_VECTOR (3 downto 0);
          input3 : in STD_LOGIC_VECTOR (3 downto 0);
          an : out STD_LOGIC_VECTOR (3 downto 0);
          cat : out STD_LOGIC_VECTOR (6 downto 0));
end component SSD;

component InstrF 
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           jump : in STD_LOGIC;
           PCsrc : in STD_LOGIC;
           jadr : in STD_LOGIC_VECTOR (15 downto 0);
           badr : in STD_LOGIC_VECTOR (15 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0);
           pc1 : out STD_LOGIC_VECTOR (15 downto 0));
end component InstrF;

component UC 
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
end component UC;

component ID 
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
end component ID;

component EX 
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
end component EX;

component MEM 
    Port ( MemWrite : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResMem : out STD_LOGIC_VECTOR (15 downto 0));
end component MEM;

signal semnal: STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000";
signal enable: STD_LOGIC := '0';
signal enable2: STD_LOGIC := '0';
--signal enable3: STD_LOGIC := '0';
signal adresa : STD_LOGIC_VECTOR(7 downto 0) :="00000000";
signal semnal2: STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000";
signal semnal3: STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000";
signal instr: STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000";

signal regdst : STD_LOGIC := '0';
signal regwrite : STD_LOGIC := '0';
signal alusrc : STD_LOGIC := '0';
signal extop : STD_LOGIC := '0';
signal aluop : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal memwrite : STD_LOGIC := '0';
signal memtoreg : STD_LOGIC := '0';
signal branch : STD_LOGIC := '0';
signal jump : STD_LOGIC := '0';
signal branchltz : STD_LOGIC := '0';

signal regwr : STD_LOGIC := '0';
signal writedata: STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000";
signal readdata1: STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000";
signal readdata2: STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000";
signal extimm: STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000";
signal func: STD_LOGIC_VECTOR(2 downto 0) :="000";
signal shift : STD_LOGIC := '0';

signal alures: STD_LOGIC_VECTOR(15 downto 0);
signal zero: STD_LOGIC;
signal ltz: STD_LOGIC;
signal memdata: STD_LOGIC_VECTOR(15 downto 0);


signal memwrite2 : std_logic :='0';

signal pcsrc: STD_LOGIC;

signal jumpadr: STD_LOGIC_VECTOR(15 downto 0);
signal branchadr: STD_LOGIC_VECTOR(15 downto 0);

begin
    p: MPG port map(en => enable, input => btn(0), clock =>clk);
    p2: MPG port map(en => enable2, input => btn(1), clock =>clk);
   -- p3: MPG port map(en => enable3, input => btn(2), clock =>clk);
    s: SSD port map(clk => clk, input0 => semnal(3 downto 0), input1 => semnal(7 downto 4), input2 => semnal(11 downto 8), input3 => semnal(15 downto 12), an=>an, cat=>cat);
    i: INSTRF port map(clk => clk, reset => enable, enable => enable2, jump => jump, PCsrc =>pcsrc,jadr =>jumpadr, badr => branchadr, instr => instr, pc1 => semnal3);  
    idd: ID port map(instr => instr, rw => regwr, rd => regdst, extOp =>extop, clk => clk, writeData => writedata, readData1=>readdata1, readData2 =>readdata2, imm =>extimm, func => func, shift=>shift);
    u: UC port map(instruction =>instr(15 downto 13), RegDst => regdst,ExtOp => extop,Branch =>branch ,BranchLTZ=>branchltz,Jump => jump ,ALUsrc =>alusrc, MEMwrite =>memwrite ,MEMtoREG =>memtoreg ,RegWrite =>regwrite,ALUop =>aluop);
    e: EX port map( readData1=>readdata1,readData2=>readdata2 ,ext_imm=>extimm ,PC =>semnal3,aluSRC=>alusrc ,shift=>shift ,aluOP=>aluop ,aluRES=>alures ,func=>func,zero=>zero, branchadr => branchadr,ltz =>ltz);
    m: MEM port map( MemWrite=>memwrite2,ALURes=>alures ,RD2=>readdata2 ,clk=>clk ,MemData=>memdata ,ALUResMem=>alures);

writedata <= MemData when MemToReg = '1' else alures;
regwr <= regwrite and enable;
memwrite2 <= enable and memwrite;
pcsrc <= (branch and zero) or (branchltz and ltz);
jumpadr <= "000" & instr(12 downto 0);

process(sw(7 downto 5))
begin 
case sw(7 downto 5) is
    when "000" => semnal <= instr;
    when "001" => semnal <= semnal3;
    when "010" => semnal <= readdata1;
    when "011" => semnal <= readdata2;
    when "100" => semnal <= writedata; 
    when "101" => semnal <= extimm;
    when "110" => semnal <= alures;
    when others => semnal <= memdata;
end case;
end process;         
    
    led(15 downto 12) <= "0000";
    led(11) <= regdst;
    led(10) <= regwrite;
    led(9) <= branchltz;
    led(8) <= extop ;
    led(7) <= alusrc;
    led(6) <= memwrite;
    led(5) <= memtoreg;
    led(4) <= branch;
    led(3) <= jump;
    led(2 downto 0) <= aluop;
   
end Behavioral;
