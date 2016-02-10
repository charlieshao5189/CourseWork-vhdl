----------------------------------------------------------------------------------
-- Company: HSN	
-- Engineer: Group 4 (Qinghui Liu, Zhili Shao,  Joseph Fotso)
-- 
-- Create Date:    09:35:30 01/24/2016 
-- Design Name: 
-- Module Name:    inside FSM process for calendar module 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use work.ssd_pkg.all;
use work.FSM_process_pkg.all;

entity Calendar_Module is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enb : in  STD_LOGIC;
           event_btn2 : in  STD_LOGIC;
           event_btn3 : in  STD_LOGIC;
			  hold_btn3  : in  STD_LOGIC;
           hours 		: in STD_LOGIC_VECTOR (15 downto 0);
           minues 	: in  STD_LOGIC_VECTOR (15 downto 0);
           seconds 	: in  STD_LOGIC_VECTOR (15 downto 0);
			  cd_blink	 : out SSD_BLINK_STATE; --STD_LOGIC_VECTOR (7 downto 0);
           cd_bcd : out  STD_LOGIC_VECTOR (31 downto 0));
end Calendar_Module;

architecture Behavioral of Calendar_Module is
   
	signal cdpr_state, cdnx_state : CALENDAR_STATE;
	signal hunSecPulse	: std_logic ;	-- 0.01 seconds pulse signal
	signal years: std_logic_vector(15 downto 0) := x"0000";	
	signal months, days, daysw : std_logic_vector(15 downto 0) := x"0001";	
	signal daysInMonth : std_logic_vector(15 downto 0) := x"001F";	

begin

--lower section of state transitions process--
	process(clk, rst)
	begin	
		if(clk'EVENT and clk = '1') then
			if (rst = '1') then
				cdpr_state <= CLD_RESET;
			else 
				cdpr_state <= cdnx_state;
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

	process (enb,cdpr_state, event_btn2, event_btn3,cdnx_state)
	begin 
		if (enb = '1') then
			Calendar_FSM(cdpr_state, event_btn2, event_btn3,
							 cd_blink, cdnx_state);	
		end if;
	end process;

-- process calendar mode
	process (clk, hunSecPulse, hours, cdpr_state, hold_btn3)
		variable HOLDMAX : integer := 100; -- 100 x 0.01 seconds;
		variable hold_tm : integer := 0; 
		variable day_flag: std_logic := '0';
		variable day_temp, month_temp, year_temp, daysw_temp :  std_logic_vector(15 downto 0);
	begin
		if rising_edge(clk) then
			case cdpr_state is				
				when CALENDAR =>	
					if (hunSecPulse = '1') then 
						day_temp := days;
						daysw_temp := daysw;
						month_temp := months;
						year_temp := years;
						Days_InMonth(month_temp, year_temp, daysInMonth);
						
						if (hours = x"0018" and minues = x"0000" and seconds = x"0000" ) then
							if (day_flag = '0' ) then
								day_flag := '1';
								
								day_temp := std_logic_vector(unsigned(day_temp) + 1);
								daysw_temp := std_logic_vector(unsigned(daysw_temp) + 1);
								if (daysw_temp > x"0007") then 
									 daysw_temp := x"0001";
								end if;						
																		
							
								if (day_temp > daysInMonth or day_temp > x"001F") then  --if (days > x"001F") then
									month_temp := std_logic_vector(unsigned(month_temp) + 1);	
									day_temp := x"0001";
									if (month_temp > x"000c") then
										year_temp := std_logic_vector(unsigned(year_temp) + 1);	
										month_temp := x"0001" ;
									end if;
								end if;
							end if;
						else 
							day_flag := '0';
						end if;
						
						days   <= day_temp;
						daysw  <= daysw_temp;
						months <= month_temp;
						years  <= year_temp;
					end if;
				when SET_DAY =>
				if (enb = '1') then
					day_flag := '0';
					SetValueByHoldBtn	(hold_btn3,hunSecPulse,
											 HOLDMAX, hold_tm, 10, x"001F",x"0001",
											 --HOLDMAX, hold_tm, 10,daysInMonth,x"0001",
											 days);		
				end if;
				
				when SET_MON =>
				if (enb = '1') then
					SetValueByHoldBtn	(hold_btn3,hunSecPulse,
											 HOLDMAX, hold_tm, 0,x"000C",x"0001",
											 months);							
				end if;
				
				when SET_Y0 =>	
				if (enb = '1') then
					if (hold_btn3 = '1') then
						if (hunSecPulse = '1') then
							if hold_tm = HOLDMAX then
								hold_tm := 0;
								years <= std_logic_vector(unsigned(years) + 1);														
							else
								hold_tm := hold_tm + 1;
							end if;
						end if;
					else
						HOLDMAX := 100;
					end if;	
				end if;
				
				when SET_Y1 =>	
				if (enb = '1') then
					if (hold_btn3 = '1') then
						if (hunSecPulse = '1') then
							if hold_tm = HOLDMAX then
								hold_tm := 0;
								years <= std_logic_vector(unsigned(years) + 10);	 --x"000A";																
							else
								hold_tm := hold_tm + 1;
							end if;
						end if;
					else
						HOLDMAX := 100;
					end if;		
				end if;
				
				when SET_Y2 =>	
				if (enb = '1') then
					if (hold_btn3 = '1') then
						if (hunSecPulse = '1') then
							if hold_tm = HOLDMAX then
								hold_tm := 0;
								years <= std_logic_vector(unsigned(years) + 100);	--x"0064";																
							else
								hold_tm := hold_tm + 1;
							end if;
						end if;
					else
						HOLDMAX := 100;
					end if;		
				end if;
				
				when SET_Y3 =>	
				if (enb = '1') then
					if (hold_btn3 = '1') then
						if (hunSecPulse = '1') then
							if hold_tm = HOLDMAX then
								hold_tm := 0;
								years <= std_logic_vector(unsigned(years) + 1000);	--x"03E8";																
							else
								hold_tm := hold_tm + 1;
							end if;
						end if;
					else
						HOLDMAX := 100;
					end if;
				end if;
				
				when SET_DWK =>
				if (enb = '1') then
				SetValueByHoldBtn	(hold_btn3,hunSecPulse,
										 HOLDMAX, hold_tm, 0,x"0007",x"0001",
										 daysw);						
				end if;
				
				when CLD_RESET =>
					day_flag := '0';
					years <= x"0000";	
					months <= x"0001";	
					days <= x"0001"; 
					daysw <= x"0001";
				
				when others =>	
					day_flag := '0';
			end case;
			
		end if;
	end process;

	process (clk, enb, hunSecPulse, cdpr_state, days, months, years)
		variable bcd_tm : std_logic_vector (19 downto 0);
		constant SSEG_a: std_logic_vector (6 downto 0):= "0001000"; -- a --
		constant SSEG_d: std_logic_vector (6 downto 0):= "1000010"; -- d --
	begin
			if (rising_edge(clk)) then
				if (enb = '1') then
					if (cdpr_state = CALENDAR or 
						 cdpr_state = SET_DAY  or 
						 cdpr_state = SET_MON  		) then
						bcd_tm := Bin2BCD(days);
						cd_bcd(7 downto 0) <= '1' & BCD2ssd(bcd_tm(3 downto 0));
						cd_bcd(15 downto 8) <= '1' & BCD2ssd(bcd_tm(7 downto 4));
						bcd_tm := Bin2BCD(months);
						cd_bcd(23 downto 16) <= '0' & BCD2ssd(bcd_tm(3 downto 0));
						cd_bcd(31 downto 24) <= '1' & BCD2ssd(bcd_tm(7 downto 4));
					elsif (cdpr_state = CLD_YEAR or 
							 cdpr_state = SET_Y0	or  cdpr_state = SET_Y1 or 
							 cdpr_state = SET_Y2	or  cdpr_state = SET_Y3 	) then
						bcd_tm := Bin2BCD(years);
						cd_bcd(7 downto 0) <= '1' & BCD2ssd(bcd_tm(3 downto 0));
						cd_bcd(15 downto 8) <= '1' & BCD2ssd(bcd_tm(7 downto 4));
						cd_bcd(23 downto 16) <= '1' & BCD2ssd(bcd_tm(11 downto 8));
						cd_bcd(31 downto 24) <= '1' & BCD2ssd(bcd_tm(15 downto 12));
					elsif (cdpr_state = CLD_DWK or cdpr_state = SET_DWK ) then	
						bcd_tm := Bin2BCD(daysw);
						cd_bcd(7 downto 0) <= '1' & BCD2ssd(bcd_tm(3 downto 0));
						cd_bcd(15 downto 8) <= '1' & BCD2ssd(bcd_tm(7 downto 4));	
						cd_bcd(23 downto 16) <= '0' & SSEG_a;
						cd_bcd(31 downto 24) <= '1' & SSEG_d;
					else 
						bcd_tm := Bin2BCD(years);
						cd_bcd(7 downto 0) <= '1' & BCD2ssd(bcd_tm(3 downto 0));
						cd_bcd(15 downto 8) <= '1' & BCD2ssd(bcd_tm(7 downto 4));
						cd_bcd(23 downto 16) <= '1' & BCD2ssd(bcd_tm(11 downto 8));
						cd_bcd(31 downto 24) <= '1' & BCD2ssd(bcd_tm(15 downto 12));					
					end if;
			  end if;
		end if;			
	end process;
end Behavioral;

