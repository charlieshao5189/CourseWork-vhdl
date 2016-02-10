----------------------------------------------------------------------------------
-- Company: HSN	
-- Engineer: Group 4 (Qinghui Liu, Zhili Shao,  Joseph Fotso)
-- 
-- Create Date:    14:27:31 02/01/2016  
-- Design Name: 
-- Module Name:    inside FSM process for alarm module 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use work.ssd_pkg.all;
use work.FSM_process_pkg.all;

entity Alarm_Module is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enb : in  STD_LOGIC;
           event_btn2 : in  STD_LOGIC;
           event_btn3 : in  STD_LOGIC;
			  hold_btn3  : in  STD_LOGIC;
           hours 		: in STD_LOGIC_VECTOR (15 downto 0);
           minues 	: in  STD_LOGIC_VECTOR (15 downto 0);
           seconds 	: in  STD_LOGIC_VECTOR (15 downto 0);
			  alarm_flag  : inout  STD_LOGIC;
			  al_blink	  : out SSD_BLINK_STATE; --STD_LOGIC_VECTOR (7 downto 0);
           al_bcd : out  STD_LOGIC_VECTOR (31 downto 0));
end Alarm_Module;

architecture Behavioral of Alarm_Module is

	signal alpr_state, alnx_state : ALARM_STATE;
	signal hunSecPulse	: std_logic ;	-- 0.01 seconds pulse signal
	
	signal alarmHH : std_logic_vector(15 downto 0) := x"0000";
	signal alarmMM : std_logic_vector(15 downto 0) := x"0000";
	

begin
--lower section of state transitions process--
	process(clk, rst)
	begin	
		if(clk'EVENT and clk = '1') then
			if (rst = '1') then
				alpr_state <= ALM_RESET;
			else 
				alpr_state <= alnx_state;
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

	process (enb, alpr_state, alnx_state, event_btn2, event_btn3,alarm_flag)
	begin 
		if (enb = '1') then
				ALARM_FSM(   alpr_state, event_btn2, event_btn3, alarm_flag,
								 al_blink, alnx_state);
		end if;
	end process;
	
--	type ALARM_STATE is (READY, SET_MIN, SET_HOUR, ALARMING, CLEAN);
	process (clk, hunSecPulse, alpr_state, hold_btn3)
		-- a delay counter for time counting in hundth seconds;
		variable HOLDMAX : integer := 100; -- 100 x 0.01 seconds;
		variable hold_tm : integer := 0; 
		variable secNo : integer range 0 to 99; -- 1 second
		variable alarmCounter : integer range 0 to 49; -- wait for 50 sec to remove alarm 
	begin
		if rising_edge(clk) then	
			case alpr_state is			
				when READY =>
					secNo := 0;
					alarmCounter := 0;
					alarm_flag <= '0';
					if (alarmHH = x"0000" and alarmMM =x"0000") then
						 alarm_flag <= '0';
					elsif (alarmHH = hours and alarmMM = minues and seconds = x"0001") then
						 alarm_flag <= '1';
					end if;
					
				when SET_MIN =>
					if (enb = '1') then
						alarm_flag <= '0';
						SetValueByHoldBtn	(hold_btn3,hunSecPulse,
												 HOLDMAX, hold_tm, 20, x"003B",x"0000",
												 alarmMM);	
					end if;
					
				when SET_HOUR =>	
					if (enb = '1') then
						alarm_flag <= '0';
						SetValueByHoldBtn	(hold_btn3,hunSecPulse,
												 HOLDMAX, hold_tm, 10, x"0017",x"0000",
												 alarmHH);		
					end if;
				
				when ALARMING =>
					if (alarm_flag = '1') then
						if (hunSecPulse = '1') then						
							if (secNo = 99) then
								 secNo := 0;	
								if (alarmCounter = 49) then -- wait for 50 seconds, auto remove alarm
									alarm_flag <= '0';
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
					
				when CLEAN =>
					alarm_flag <= '0';
					secNo := 0;
					alarmCounter := 0;
					hold_tm := 0;
					alarmHH <= x"0000";
					alarmMM <= x"0000";
					
				when others =>
					secNo := 0;
					alarmCounter := 0;
					hold_tm := 0;
					alarm_flag <= '0';	
					alarmHH <= x"0000";
					alarmMM <= x"0000";					
			end case;
		end if;
	end process;
	
	process (clk, enb, hunSecPulse, alarmMM, alarmHH)
		variable bcd_tm : std_logic_vector (19 downto 0);
	begin
			if (rising_edge(clk)) then
				if (enb = '1') then
					bcd_tm := Bin2BCD(alarmMM);	
					al_bcd(7 downto 0) <=  '1' & BCD2ssd(bcd_tm(3 downto 0));
					al_bcd(15 downto 8) <=  '1' & BCD2ssd(bcd_tm(7 downto 4));
					bcd_tm := Bin2BCD(alarmHH);
					al_bcd(23 downto 16) <= '0' & BCD2ssd(bcd_tm(3 downto 0));
					al_bcd(31 downto 24) <= '1' & BCD2ssd(bcd_tm(7 downto 4));
					
				end if;
			end if;			
	end process;
	
end Behavioral;

