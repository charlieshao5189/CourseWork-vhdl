----------------------------------------------------------------------------------
-- Company: HSN	
-- Engineer: Group 4 (Qinghui Liu, Zhili Shao,  Joseph Fotso)
-- 
-- Create Date:    13:08:05 02/01/2016 
-- Design Name: 
-- Module Name:    inside FSM process for timer module 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use work.ssd_pkg.all;
use work.FSM_process_pkg.all;

entity Timer_Module is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enb : in  STD_LOGIC;
           event_btn2 : in  STD_LOGIC;
           event_btn3 : in  STD_LOGIC;
			  hold_btn3  : in  STD_LOGIC;
			  tm_alarm : inout  STD_LOGIC;
           tm_blink : out  SSD_BLINK_STATE;--STD_LOGIC_VECTOR (7 downto 0);			  
           tm_bcd : out  STD_LOGIC_VECTOR (31 downto 0));
end Timer_Module;

architecture Behavioral of Timer_Module is
	signal tmpr_state, tmnx_state : TIMER_STATE;
	signal hunSecPulse	: std_logic ;	-- 0.01 seconds pulse signal

	signal timerHH : std_logic_vector(15 downto 0) := x"0000";
	signal timerLL : std_logic_vector(15 downto 0) := x"0000";
	
   signal hours 	:  std_logic_vector (15 downto 0):= x"0000";
   signal minues	: std_logic_vector (15 downto 0):= x"0000";
	signal seconds	: std_logic_vector (15 downto 0):= x"0000";
	
begin
--lower section of state transitions process--
	process(clk, rst)
	begin	
		if(clk'EVENT and clk = '1') then
			if (rst = '1') then
				tmpr_state <= TMR_RESET;
			else 
				tmpr_state <= tmnx_state;
			end if;
		end if;
	end process;

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
	
	-- when module enbaled, to change inside state by btn2,  
	-- provoking TIMER_FSM procedure, refer to FSM_process_pkg
	process (enb,tmpr_state, event_btn2, event_btn3, tm_alarm, tmnx_state)
	begin 
		if (enb = '1') then
			TIMER_FSM( tmpr_state, event_btn2, event_btn3, tm_alarm,
						  tm_blink, tmnx_state);										
		end if;
	end process;

	process (clk, hunSecPulse, hours, minues, tmpr_state, hold_btn3)
		variable HOLDMAX : integer := 100; -- 100 x 0.01 seconds;
		variable hold_tm : integer := 0; 
		variable secNo : integer range 0 to 99; -- 1 second
		variable alarmCounter : integer range 0 to 49; -- wait for 50 sec to remove timer alarm 
	begin
		if rising_edge(clk) then	
			case tmpr_state is
				when READY =>	-- ready to start timer, assign users' setting to reg.
					secNo := 0;
					alarmCounter := 0;
					hours <= timerHH;
					minues <= timerLL;
					seconds <= x"0000";
					tm_alarm <= '0';
				
				when START =>	-- start timer, and counter 1 sec then descrease the timer 
					if (hunSecPulse = '1') then						
						if (secNo = 99) then
							secNo := 0;								
							if (seconds > x"0000") then
								seconds <= std_logic_vector(unsigned(seconds) - 1);
							else 
								if (minues > x"0000") then
									minues <= std_logic_vector(unsigned(minues) - 1);
									seconds <= x"003B";
									if (minues < x"0028") then
										if (hours > x"0000") then
											hours <= std_logic_vector(unsigned(hours) - 1);	
											minues <= std_logic_vector(unsigned(minues) + 60);
										end if;
									end if;
								else 
									if (hours > x"0000") then
									   hours <= std_logic_vector(unsigned(hours) - 1);	
										minues <= x"003B";
										seconds <= x"003B";
									else	-- timer end, generate an alarm
										if (alarmCounter = 0) then
											tm_alarm <= '1';	
										end if;
										
									end if;
								end if;							
							end if;							
						else
							secNo := secNo + 1;						
						end if;
					end if;				
				when PAULSE =>	-- paulse timer, just wait resume 
					tm_alarm <= '0';
					secNo := 0;
					alarmCounter := 0;
					
				when SET_MIN => -- hold btn to reset timer start value of minutes.
					if (enb = '1') then
						tm_alarm <= '0';
						alarmCounter := 0;
						SetValueByHoldBtn	(hold_btn3,hunSecPulse,
												 HOLDMAX, hold_tm, 20, x"003B",x"0000",
												 timerLL);	
					end if;
											 
				when SET_HOUR => -- hold btn to reset timer start value of hours.
					if (enb = '1') then
						tm_alarm <= '0';
						alarmCounter := 0;
						-- setting value of hours up to 99 hours.
						SetValueByHoldBtn	(hold_btn3,hunSecPulse,
												 HOLDMAX, hold_tm, 10, x"0063",x"0000",
											    timerHH);	
					end if;
				when TMR_ALARM => 		
					if (tm_alarm = '1') then
						if (hunSecPulse = '1') then						
							if (secNo = 99) then
								secNo := 0;	
								if (alarmCounter = 49) then 
									tm_alarm <= '0';
									alarmCounter := 0;
								else
									alarmCounter := alarmCounter + 1; -- start to counter 50 seconds
								end if;
							else
								secNo := secNo + 1;
							end if;
							
						end if;
					else 
						secNo := 0;	
						alarmCounter := 0;
					end if;	
					
				when others =>
					secNo := 0;		
					alarmCounter := 0;
					tm_alarm <= '0';
					hours <= x"0000";
					minues <= x"0000";
					seconds <= x"0000";
					timerHH <= x"0000";
					timerLL <= x"0000";
			end case;
		end if;			
	end process;

	-- produce proper output data for ssd according to different states.
	process (clk, enb, tmpr_state, timerHH, timerLL)
		variable bcd_tm : std_logic_vector (19 downto 0);
	begin
			if (rising_edge(clk)) then
				if (enb = '1') then
					if (tmpr_state = SET_MIN or tmpr_state = SET_HOUR) then
					-- output timer setting data with format : HH.MM
						bcd_tm := Bin2BCD(timerLL);	
						tm_bcd(7 downto 0) <=  '1' & BCD2ssd(bcd_tm(3 downto 0));
						tm_bcd(15 downto 8) <=  '1' & BCD2ssd(bcd_tm(7 downto 4));
						bcd_tm := Bin2BCD(timerHH);
						tm_bcd(23 downto 16) <= '0' & BCD2ssd(bcd_tm(3 downto 0));
						tm_bcd(31 downto 24) <= '1' & BCD2ssd(bcd_tm(7 downto 4));
					-- output start data of timer with HH.MM
					elsif (tmpr_state = READY) then
						bcd_tm := Bin2BCD(minues);	
						tm_bcd(7 downto 0) <=  '1' & BCD2ssd(bcd_tm(3 downto 0));
						tm_bcd(15 downto 8) <=  '1' & BCD2ssd(bcd_tm(7 downto 4));
						bcd_tm := Bin2BCD(hours);
						tm_bcd(23 downto 16) <= '0' & BCD2ssd(bcd_tm(3 downto 0));
						tm_bcd(31 downto 24) <= '1' & BCD2ssd(bcd_tm(7 downto 4));						
					else 
					-- output real time timer MM.SS
						bcd_tm := Bin2BCD(seconds);	
						tm_bcd(7 downto 0) <=  '1' & BCD2ssd(bcd_tm(3 downto 0));
						tm_bcd(15 downto 8) <=  '1' & BCD2ssd(bcd_tm(7 downto 4));
						bcd_tm := Bin2BCD(minues);
						tm_bcd(23 downto 16) <= '0' & BCD2ssd(bcd_tm(3 downto 0));
						tm_bcd(31 downto 24) <= '1' & BCD2ssd(bcd_tm(7 downto 4));					
					end if;
				end if;
			end if;			
	end process;

end Behavioral;

