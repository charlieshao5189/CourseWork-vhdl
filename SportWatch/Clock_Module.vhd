----------------------------------------------------------------------------------
-- Company: HSN	
-- Engineer: Group 4 (Qinghui Liu, Zhili Shao,  Joseph Fotso)
-- 
-- Create Date:    14:27:31 02/01/2016 
-- Design Name: 
-- Module Name:    inside FSM process for clock module 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use work.ssd_pkg.all;
use work.FSM_process_pkg.all;

entity Clock_Module is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enb : in  STD_LOGIC;
           event_btn2 : in  STD_LOGIC;
           event_btn3 : in  STD_LOGIC;
           ck_blink : out  SSD_BLINK_STATE;--STD_LOGIC_VECTOR (7 downto 0);
           hours 		: inout  STD_LOGIC_VECTOR (15 downto 0);
           minues 	: inout  STD_LOGIC_VECTOR (15 downto 0);
           seconds 	: inout  STD_LOGIC_VECTOR (15 downto 0);			  
           ck_bcd : out  STD_LOGIC_VECTOR (31 downto 0));
end Clock_Module;

architecture Behavioral of Clock_Module is
	signal ckpr_state, cknx_state : CLOCK_STATE;
	signal hunSecPulse	: std_logic ;	-- 0.01 seconds pulse signal

begin
--lower section of state transitions process--
	process(clk, rst)
	begin	
		if(clk'EVENT and clk = '1') then
			if (rst = '1') then
				ckpr_state <= CLK_RESET;
			else 
				ckpr_state <= cknx_state;
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
	
	process (enb,ckpr_state, event_btn2, cknx_state)
	begin 
		if (enb = '1') then
			Clock_FSM( ckpr_state, event_btn2,
						  ck_blink, cknx_state ); 					
		end if;
	end process;

-- process clock mode
	process (clk, hunSecPulse, ckpr_state, event_btn3)
		-- a delay counter for time counting in hundth seconds;
		variable HOLDMAX : integer := 100; -- 100 x 0.01 seconds;
		variable secNo : integer range 0 to 100; -- 60 seconds
		variable hold_tm : integer := 0; 

	begin
		if rising_edge(clk) then	
			case ckpr_state is			
				when CLOCK =>
					if (hunSecPulse = '1') then						
						if (secNo = 99) then
							secNo := 0;
							if (seconds = x"003B") then -- 59
								seconds <= x"0000";	
								if (minues = x"003B") then
									minues <= x"0000";
									if (hours = x"0018" ) then
										hours <= x"0001";
									else										
										hours <= std_logic_vector(unsigned(hours) + 1);	
									end if;
								else
									minues <= std_logic_vector(unsigned(minues) + 1);
								end if;
							else
								seconds <= std_logic_vector(unsigned(seconds) + 1);	
							end if;
						else
							secNo := secNo + 1;						
						end if;
					end if;
					
				when SET_MIN =>
				if (enb = '1') then
					SetValueByHoldBtn	(event_btn3,hunSecPulse,
											 HOLDMAX, hold_tm, 20, x"003B",x"0000",
										    minues);	
				end if;
				
				when SET_HOUR =>	
				if (enb = '1') then				
					SetValueByHoldBtn	(event_btn3,hunSecPulse,
											 HOLDMAX, hold_tm, 10, x"0017",x"0000",
											 hours);			
				end if;
				
				when others =>
					secNo := 0;
					seconds <= x"0000";
					minues <= x"0000";
					hours	 <= x"0000";
			end case;
		end if;
	end process;

	process (clk, enb, hunSecPulse, minues, hours)
		variable bcd_tm : std_logic_vector (19 downto 0);
	begin
			if (rising_edge(clk)) then
				if (enb = '1') then
					bcd_tm := Bin2BCD(minues);	
					ck_bcd(7 downto 0) <=  '1' & BCD2ssd(bcd_tm(3 downto 0));
					ck_bcd(15 downto 8) <=  '1' & BCD2ssd(bcd_tm(7 downto 4));
					bcd_tm := Bin2BCD(hours);
					ck_bcd(23 downto 16) <= '0' & BCD2ssd(bcd_tm(3 downto 0));
					ck_bcd(31 downto 24) <= '1' & BCD2ssd(bcd_tm(7 downto 4));
				end if;
			end if;			
	end process;
	
end Behavioral;

