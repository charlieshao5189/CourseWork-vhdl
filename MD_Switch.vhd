----------------------------------------------------------------------------------
-- Company: HSN	
-- Engineer: Group 4 (Qinghui Liu, Zhili Shao,  Joseph Fotso)
-- 
-- Create Date:    14:27:31 02/01/2016 
-- Design Name: 
-- Module Name:    inside FSM process for smtWatch 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ssd_pkg.all;
use work.FSM_process_pkg.all;

entity MD_Switch is
    Port ( envent_btn1 : in  STD_LOGIC;
			  pr_modul 	  : in  MODULE_STATES;--STD_LOGIC_VECTOR (5 downto 0);
			  ck_blink    : in SSD_BLINK_STATE;
			  al_blink    : in SSD_BLINK_STATE;
			  cd_blink    : in SSD_BLINK_STATE;
			  sw_blink    : in SSD_BLINK_STATE;
			  tm_blink    : in SSD_BLINK_STATE;
			  clock_alarm : in  STD_LOGIC;
			  timer_alarm : in  STD_LOGIC;
           nx_modul : out MODULE_STATES;-- STD_LOGIC_VECTOR (5 downto 0);
           modul_set : out  STD_LOGIC_VECTOR (4 downto 0);
           blink_flag : out SSD_BLINK_STATE ); --STD_LOGIC_VECTOR (7 downto 0)
end MD_Switch;

architecture Behavioral of MD_Switch is

begin

	process (pr_modul, envent_btn1, clock_alarm, timer_alarm, 
				ck_blink, tm_blink, al_blink, cd_blink, sw_blink )
	begin
		nx_modul <= pr_modul;
		
		case pr_modul is
			when UNKNOWN => 
				modul_set <= "11111"; -- ALl 5 LEDs lit on LED_SET
			
				if (envent_btn1 = '1' ) then 
					nx_modul <= CLOCK_MD;	-- switch to next mode after button release			
				end if;
			
			when CLOCK_MD =>
				modul_set <= "00001";  --LED[0] lit on and enable Clock_modul
				blink_flag <= ck_blink;	
							  
				if (envent_btn1 = '1' ) then 
					nx_modul <= ALARM_MD; 
				else 
					nx_modul <= CLOCK_MD;
				end if;
						
			when ALARM_MD =>
				modul_set <= "00010";  --LED[1] lit on, and enable Alarm_modul 	
				blink_flag <= al_blink;	
				
				if (envent_btn1 = '1' ) then 
					nx_modul <= CALENDAR_MD; 
				else 
					nx_modul <= ALARM_MD;
				end if;

			when CALENDAR_MD =>
				modul_set <= "00100";	--LED[2] lit on and enable Calendar_modul
				blink_flag <= cd_blink;	

				if (envent_btn1 = '1' ) then 
					nx_modul <= STOPWATCH_MD; 
				else
					nx_modul <= CALENDAR_MD;
				end if;
			
			when STOPWATCH_MD =>
				modul_set <= "01000";	--LED[3] lit on
				blink_flag <= sw_blink;		
				
				if (envent_btn1 = '1' ) then 
					nx_modul <= TIMER_MD; 	
				else
					nx_modul <= STOPWATCH_MD;
				end if;	
						
			when TIMER_MD =>
				modul_set <= "10000";  --LED[4] lit on
				blink_flag <= tm_blink;	

				if (envent_btn1 = '1' ) then 
					nx_modul <= CLOCK_MD; 
				else
					nx_modul <= TIMER_MD; 
				end if;		
			
			when others =>
				modul_set <= "11111"; 
				nx_modul <= UNKNOWN;				
				blink_flag <= BLALL;		
				if (envent_btn1 = '1' ) then 
					nx_modul <= CLOCK_MD; 
				else
					nx_modul <= UNKNOWN; 
				end if;					
		end case;
		
		if (clock_alarm = '1') then
			nx_modul<= ALARM_MD;
			blink_flag <= BLALL;
		elsif (timer_alarm = '1') then
			nx_modul<= TIMER_MD;
			blink_flag <= BLALL;			
		end if;
			
	end process;

end Behavioral;

