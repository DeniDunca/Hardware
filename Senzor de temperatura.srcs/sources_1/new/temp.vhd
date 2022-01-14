----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2022 07:02:53 PM
-- Design Name: 
-- Module Name: temp - Behavioral
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

entity temp is
generic(clk_in: integer := 100_000_000; --viteza clock-ului
		resolution: integer := 13; -- resolutia senzorului de temperatura (13 /16 biti)
	    temp_adr: std_logic_vector(6 downto 0) := "1001011"); --adresa senzorului pentru comunicare cu i2c
	port(clk: in std_logic;
		 reset: in std_logic;
		 scl: inout std_logic;
		 sda: inout std_logic;
		 ack_err: buffer std_logic;
	     temperature: out std_logic_vector(resolution - 1 downto 0));
end temp;

architecture Behavioral of temp is
type stari is (start, set_res, read_data1, read_data2, output_temp); -- starile automatului slave
signal stare : stari;

signal t_start: STD_LOGIC;
signal t_data_in : STD_LOGIC_VECTOR (7 downto 0 ); 
signal t_adr : STD_LOGIC_VECTOR (6 downto 0 );
signal t_rw: STD_LOGIC := '0';
signal t_data_out: STD_LOGIC_VECTOR (7 downto 0);
signal t_final: STD_LOGIC := '0';
signal t_busy : STD_LOGIC := '0';
signal prev_busy : STD_LOGIC:= '0';
signal temp_data : STD_LOGIC_VECTOR (15 downto 0);
signal config_reg: STD_LOGIC_VECTOR( 7 downto 0);-- pentru registrul de configurare

begin
--port map la master
i2c: entity WORK.I2C generic map (clk_in => clk_in, clk_bus => 400000)
                     port map ( clk => clk,
                                reset => reset,
                                start => t_start,
                                rw => t_rw,
                                data_in => t_data_in,
                                adr => t_adr,
                                busy =>t_busy,
                                ack_err => ack_err,
                                data_out => t_data_out,
                                sda => sda,
                                scl => scl);
                                
-- setam resolutia
with resolution select config_reg <= "00000000" when 13, "00000001" when 16, "00000000" when others;             
                    
-- automatul de stari pt slave                                
p1: process(clk, reset)
    variable i : INTEGER range 0 to clk_in/10 := 0;
    variable command : INTEGER range 0 to 2 := 0; -- ne ajuta sa vedem la ce comanda suntem
    begin
         if(reset = '0') then -- se face reset
                i := 0;
                t_start <='0';
                temperature <= (others => '0'); -- temp devine 0
                command := 0;
                stare <= start;
         elsif (rising_edge(clk)) then
                case stare is
                    when start => if(i < clk_in / 10) then
                                        i := i + 1;
                                  else
                                        i := 0;
                                        stare <= set_res;
                                  end if;
                    when set_res =>-- setam resolutia
                                   prev_busy <= t_busy;
                                   if(prev_busy = '0' and t_busy = '1') then
                                        command := command + 1;
                                   end if;
                                   case command is
                                            when 0 => -- nu este nici o comanda
                                                    t_start <='1'; --pornim i2c ul
                                                    t_adr <= temp_adr;-- setam adresa pt senzor
                                                    t_rw <= '0';
                                                    t_data_in <= "00000011";-- setam config
                                            when 1 => -- scriem o noua valoare la config
                                                    t_data_in <= config_reg;
                                            when 2 => -- se opreste comunicarea
                                                    t_start <= '0';
                                                    if(t_busy = '0') then
                                                        command := 0;
                                                        stare <= read_data1;
                                                    end if;
                                            when others => null;
                                   end case;
                    when read_data1 => -- citeste cei mai semnificativi biti
                                      prev_busy <= t_busy; -- valoarea i2c ului anterior
                                      if(prev_busy = '0' and t_busy = '1') then -- daca e pe rising edge
                                          command := command + 1; --comand devine 1
                                      end if;
                                      case command is
                                             when 0 => -- no comand
                                                      t_start <= '1';
                                                      t_adr <= temp_adr;
                                                      t_rw <= '0';
                                                      t_data_in <= "00000000"; -- setam config MSB
                                             when 1 => -- trimitere de date completa
                                                      t_start <= '0';
                                                      if(t_busy = '0') then
                                                         temp_data(15 downto 8) <= t_data_out; -- temp data primeste primii biti
                                                         command := 0;
                                                         stare <= read_data2;
                                                       end if;
                                             when others => null;
                                      end case;
                    when read_data2 => -- cei mai putini semnificativi biti de temperatura
                                      prev_busy <= t_busy;
                                      if(prev_busy = '0' and t_busy = '1') then
                                          command := command + 1;
                                      end if;
                                      case command is
                                             when 0 => --nu e comanda
                                                     t_start <= '1';
                                                     t_adr <= temp_adr;
                                                     t_rw <= '1';
                                                     t_data_in <= "00000001"; -- setam config LSB
                                             when 1 =>-- trimitere completa
                                                     t_start <= '0';
                                                     if(t_busy = '0') then
                                                           temp_data(7 downto 0) <= t_data_out; -- temp_data primeste si ceilalti biti de temperatura
                                                           command := 0;
                                                           stare <= output_temp;
                                                     end if;
                                             when others => null;
                                      end case;
                    when output_temp => -- se pun toti bitii din te,p data luati anterior in temperature
                                      temperature <= temp_data(15 downto 16 - resolution);
                                      stare <= read_data1; -- mergem sa citim urmatoaea tempera
                    when others =>
                                  stare <= start;     
            end case;
       end if;
end process;
                 
                           
                                  
end Behavioral;
