----------------------------------------------------------------------------------
-- Company: HSN	
-- Engineer: Group 4 (Qinghui Liu, Zhili Shao,  Joseph Fotso)
-- 
-- Create Date:    14:27:31 02/01/2016  
-- Design Name: 
-- Module Name:    blink function process for each module selected
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use work.ssd_pkg.all;
use work.FSM_process_pkg.all;


entity MD_BLINK is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           modul_sel : in  MODULE_STATES;
           blink_flag : in  SSD_BLINK_STATE;
           ck_bcd : in  STD_LOGIC_VECTOR (31 downto 0);
           al_bcd : in  STD_LOGIC_VECTOR (31 downto 0);
           cd_bcd : in  STD_LOGIC_VECTOR (31 downto 0);
           sw_bcd : in  STD_LOGIC_VECTOR (31 downto 0);
           tm_bcd : in  STD_LOGIC_VECTOR (31 downto 0);
           ssd0 : out  STD_LOGIC_VECTOR (7 downto 0);
			  ssd1 : out  STD_LOGIC_VECTOR (7 downto 0);
			  ssd2 : out  STD_LOGIC_VECTOR (7 downto 0);
			  ssd3 : out  STD_LOGIC_VECTOR (7 downto 0));
end MD_BLINK;

architecture Behavioral of MD_BLINK is
	signal hunSecPulse	: std_logic ;	-- 0.01 seconds pulse signal
begin
--generate a pulse signal per 0.01 seconds for calculating time.
	process (clk, rst)
		variable counter, counter_next : natural := 0;
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				counter_next := 0;
			else
				counter := counter_next;
				counter_next := counter + 1;
				if (counter = 999999) then
					counter_next := 0;
					hunSecPulse <= '1';
				else
					hunSecPulse <= '0';
				end if;
			end if;
		end if;
	end process;
	
	process (clk, hunSecPulse, blink_flag, modul_sel)
		constant BLINK_TM  : integer := 30; -- blink 1 second
		variable delay_cnt : integer range 0 to 9999;
		
		variable bcd0	: std_logic_vector (7 downto 0);
		variable bcd1	: std_logic_vector (7 downto 0);
		variable bcd2	: std_logic_vector (7 downto 0);
		variable bcd3	: std_logic_vector (7 downto 0);	
		
	begin 
		if (hunSecPulse = '1') then
			delay_cnt := delay_cnt + 1;
		end if;
		
		if rising_edge(clk) then
		case modul_sel is
			when CLOCK_MD =>	-- Clock mode display 
				bcd0 := ck_bcd(7 downto 0); 
				bcd1 := ck_bcd(15 downto 8);  
				bcd2 := ck_bcd(23 downto 16);  
				bcd3 := ck_bcd(31 downto 24); 		
			when ALARM_MD =>	
				bcd0 := al_bcd(7 downto 0); 
				bcd1 := al_bcd(15 downto 8);  
				bcd2 := al_bcd(23 downto 16);  
				bcd3 := al_bcd(31 downto 24);
			when CALENDAR_MD =>
				bcd0 := cd_bcd(7 downto 0); 
				bcd1 := cd_bcd(15 downto 8);  
				bcd2 := cd_bcd(23 downto 16);  
				bcd3 := cd_bcd(31 downto 24);
			when STOPWATCH_MD =>
				bcd0 := sw_bcd(7 downto 0); 
				bcd1 := sw_bcd(15 downto 8);  
				bcd2 := sw_bcd(23 downto 16);  
				bcd3 := sw_bcd(31 downto 24);			
			when TIMER_MD =>
				bcd0 := tm_bcd(7 downto 0); 
				bcd1 := tm_bcd(15 downto 8);  
				bcd2 := tm_bcd(23 downto 16);  
				bcd3 := tm_bcd(31 downto 24);				
			when others => 
				bcd0 := ck_bcd(7 downto 0); 
				bcd1 := ck_bcd(15 downto 8);  
				bcd2 := ck_bcd(23 downto 16);  
				bcd3 := ck_bcd(31 downto 24);						
		end case;
		ssd_Blink_Display( blink_flag, delay_cnt, BLINK_TM,
								 bcd0, bcd1, bcd2, bcd3,
								 ssd0, ssd1, ssd2, ssd3  
								);	
		end if; 
	end process;


end Behavioral;

