----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2022 06:20:08 PM
-- Design Name: 
-- Module Name: I2C - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity I2C is
  generic (clk_in : INTEGER :=100000000; -- viteza clock
           clk_bus: INTEGER :=40000); -- viteza scl
  Port ( clk: in STD_LOGIC;
         reset: in STD_LOGIC;
         start: in STD_LOGIC; -- 1 = incepe programul
         rw: in STD_LOGIC;-- 0=write 1=read
         data_in: in STD_LOGIC_VECTOR(7 downto 0);-- master scrie la slave
         adr: in STD_LOGIC_VECTOR(6 downto 0);--adresa slave -ului
         busy: out STD_LOGIC; -- se intampla ceva
         ack_err: buffer STD_LOGIC; -- eroare la bitul de acknowledge
         data_out: out STD_LOGIC_VECTOR(7 downto 0);-- masterul citeste de la slave
         sda: inout STD_LOGIC; -- serial data line
         scl: inout STD_LOGIC ); -- serial clock line
end I2C;

architecture Behavioral of I2C is
constant cons : INTEGER := (clk_in/clk_bus)/4; -- numarul de timpi intr-un sfert de scl clock

type stari is (ready, start_bit, command, slv_ack1, read, write, slv_ack2, master_ack, stop); -- straile automatului i2c
signal stare : stari;

signal cntbit: integer range 0 to 7 := 7; -- bit counter

signal data_clock : STD_LOGIC; -- informatia de la clock pt sda
signal prev_data_clock : STD_LOGIC; -- previous data clock
signal scl_clock : STD_LOGIC; -- clock intern al scl
signal scl_enable : STD_LOGIC := '0';--enables internal scl to output
signal sda_int: std_logic := '1'; --internal sda
signal sda_enable: std_logic; --enables internal sda to output
signal adr_rw: std_logic_vector(7 downto 0); --address & read/write
signal data_tx: std_logic_vector(7 downto 0); --data trimisa la slave
signal data_rx: std_logic_vector(7 downto 0); --data primita de la slave
signal stretch: std_logic := '0'; --slave stretching scl   

begin
--proces pentru generare de ceas pt data si bus
p1:process(clk, reset)
 variable i : INTEGER range 0 to cons*4; -- pentru generare clock
   begin
       if(reset = '0') then -- se reseteaza
           stretch <= '0';
           i := 0;
       elsif(rising_edge(clk)) then
           prev_data_clock <= data_clock; -- stocam data anterioara in data_clock
           if(i = cons*4 -1) then -- daca se termina ciclul de ceas
               i := 0; -- reset
           elsif(stretch = '0') then -- daca nu se face streching
               i := i + 1; -- se continua generarea procesului de clock
           end if;
           case i is
               when 0 to cons-1 => scl_clock <= '0'; -- 1/4
                                     data_clock <= '0';
               when cons to cons*2-1 => scl_clock <= '0'; -- 2/4
                                            data_clock <= '1';
               when cons*2 to cons*3-1 => scl_clock <= '1'; -- 3/4
                                                if(scl = '0') then -- verificam daca e streching
                                                   stretch <= '1';
                                                else
                                                   stretch <= '0';
                                                end if;
                                                data_clock <= '1';
               when others => scl_clock <= '1'; --4/4
                              data_clock <= '0';
            end case;
          end if;
end process;

-- automatul de stari de la i2c
p2:process(clk, reset)
    begin
        if (reset = '0') then -- se face reset
            stare <= ready; -- se merge in starea initiala
            busy <= '1';
            scl_enable <= '0';
            sda_int <= '1';
            ack_err <= '0';
            cntbit <= 7;
            data_out <= "00000000";
        elsif (rising_edge(clk)) then
            if(data_clock = '1' and prev_data_clock = '0') then -- rising_edge
                case stare is
                    when ready =>
                        if start = '1' then
                            busy <= '1'; -- suntem in proces
                            adr_rw <= adr & rw; -- se stocheaza adresa slaveului si comanda
                            data_tx <= data_in; -- masterul trimite date
                            stare <= start_bit; -- se trece in urmatoarea stare
                        else
                            busy <= '0'; -- nu suntem in proces
                            stare <= ready; -- mergem la ready
                       end if;
                   when start_bit =>
                            busy <= '1';
                            sda_int <= adr_rw(cntbit); -- se trimite primul bit de adresa
                            stare <= command; -- mergem la command
                   when command =>
                        if(cntbit = 0) then -- daca s-a terminat de trimis
                            sda_int <= '1'; -- slave ul nu mai stie de sda
                            cntbit <= 7;
                            stare <= slv_ack1;
                        else
                            cntbit <= cntbit - 1;
                            sda_int <= adr_rw(cntbit - 1);-- altfel se trimite urmatorul bit
                            stare <= command;
                        end if;
                   when slv_ack1 => 
                        if(adr_rw(0) = '0') then -- pregatim pentru write
                            sda_int <= data_tx(cntbit);
                            stare <= write;
                        else
                            sda_int <= '1'; -- pregatim pentru read
                            stare <= read;
                        end if;
                   when write =>
                            busy <= '1';
                        if(cntbit = 0) then -- daca s-a terminat de trimis
                            sda_int <= '1';-- slave ul nu mai stie de sda
                            cntbit <= 7;
                            stare <= slv_ack2;
                        else
                            cntbit <= cntbit - 1; -- altfel se continua sa scrie
                            sda_int <= data_tx(cntbit - 1);
                            stare <= write;
                        end if;
                   when read =>
                            busy <= '1';
                        if(cntbit = 0) then -- daca s-a terminat de trimis
                            if( start = '1' and adr_rw = adr & rw) then -- daca s-a citit aceeasi adresa
                                sda_int <= '0'; -- slave stie (ack)
                            else
                                sda_int <= '1'; -- slave nu stie (not ack)
                            end if;
                            cntbit <= 7;
                            data_out <= data_rx;
                            stare <= master_ack;
                        else
                            cntbit <= cntbit - 1;
                            stare <= read;
                        end if;
                    when slv_ack2 => -- in caz ca se mai scrie 
                        if (start = '1') then
                            busy <= '0';
                            adr_rw <= adr & rw;
                            data_tx <= data_in;
                            if(adr_rw = adr & rw) then
                                sda_int <= data_in(cntbit);
                                stare <= write;
                            else
                                stare <= start_bit;
                            end if;
                        else
                            stare <= stop;
                        end if;
                    when master_ack => -- dupa de s-a citit, ce stie masterul
                        if(start = '1')then
                            busy <= '0';
                            adr_rw <= adr & rw;
                            data_tx <= data_in;
                            if(adr_rw = adr & rw) then
                                sda_int <= '1';
                                stare <= read;
                            else
                                stare <= start_bit;
                            end if;
                        else
                            stare <= stop;
                        end if;
                    when stop =>   
                            busy <= '0';
                            stare <= ready;
                    when others => null;
            end case;
      elsif(data_clock = '0' and prev_data_clock = '1') then -- daca suntem pe falling edge
            case stare is
                when start_bit => 
                    if(scl_enable = '0') then -- incepem o noua procedura de comunicatie
                        scl_enable <= '1';
                        ack_err <= '0';
                    end if;
                when slv_ack1 => -- comanda pt slave
                    if(sda /= '0' or ack_err = '1' ) then -- nu e ack
                        ack_err <= '1';
                    end if;
                when read =>
                    data_rx(cntbit) <= sda;
                when slv_ack2 => -- write in slave
                    if(sda /= '0' or ack_err = '1') then -- nu e ack
                        ack_err <= '1';
                    end if;
                when stop =>
                    scl_enable <= '0';
                when others => null;
           end case;
      end if;
   end if;
end process;
                    
with stare select sda_enable <= prev_data_clock when start_bit,
                                not prev_data_clock when stop,
                                sda_int when others;
                                                          
scl <= '0' when (scl_enable = '1' and scl_clock = '0') else 'Z';
sda <= '0' when sda_enable = '0'  else 'Z';                        
                            
end Behavioral;
