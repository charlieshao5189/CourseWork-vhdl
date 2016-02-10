-- Company: HSN	
-- Engineer: Group 4 (Qinghui Liu, Zhili Shao,  Joseph Fotso)
-- 
-- Create Date:    017:49:31 01/31/2016
-- Design Name: 
-- Module Name:    inside FSM process for stopwatch module 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use work.ssd_pkg.all;
use work.FSM_process_pkg.all;

entity Swatch_Module is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enb : in  STD_LOGIC;
           event_btn2 : in  STD_LOGIC;
           event_btn3 : in  STD_LOGIC;
           sw_blink : out  SSD_BLINK_STATE;--STD_LOGIC_VECTOR (7 downto 0);
           sw_bcd : out  STD_LOGIC_VECTOR (31 downto 0));
end Swatch_Module;

architecture Behavioral of Swatch_Module is

	signal swpr_state, swnx_state : STOPWATCH_STATE;
	signal hunSecPulse	: std_logic ;	-- 0.01 seconds pulse signal
	
	signal timerHH : std_logic_vector(15 downto 0) := x"0000";
	signal timerLL : std_logic_vector(15 downto 0) := x"0000";	

begin
--lower section of state transitions process--
	process(clk, rst)
	begin	
		if(clk'EVENT and clk = '1') then
			if (rst = '1') then
				swpr_state <= STW_RESET;
			else 
				swpr_state <= swnx_state;
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

	process (enb, swpr_state, event_btn2, event_btn3, swnx_state)
	begin 
		if (enb = '1') then
				StopWatch_FSM( swpr_state, event_btn2, event_btn3,
									sw_blink, swnx_state);
		end if;
	end process;


-- process stopwatch mode
	process (clk, hunSecPulse, swpr_state)
		variable counter : integer range 0 to 9;
		variable lap_flag : std_logic := '0';
		
		variable tmr_tss : std_logic_vector(15 downto 0) := x"0000";
		variable tmr_ss : std_logic_vector(15 downto 0) := x"0000";
		variable tmr_min : std_logic_vector(15 downto 0) := x"0000";
		variable tmr_hour : std_logic_vector(15 downto 0) := x"0000";

	begin
		if rising_edge(clk) then
			case swpr_state is
				when STOP =>
					tmr_tss := x"0000";
					tmr_ss := x"0000";
					tmr_min := x"0000";
					tmr_hour := x"0000";
					timerHH <= x"0000";
					timerLL <= x"0000";					
					counter := 0;
					lap_flag := '0';
					
				when TIMING =>					
					if (hunSecPulse = '1') then
						if (counter = 9) then
							counter := 0; 						
							if tmr_tss = x"0009" then
								tmr_tss := x"0000";							
								if tmr_ss = x"003B" then -- "003b" = 59
									tmr_ss := x"0000";									
									if tmr_min = x"003B" then -- "003b" = 59
										tmr_min := x"0000";
										tmr_hour:= std_logic_vector(unsigned(tmr_hour) + 1);	-- 1 hours
									else
										tmr_min := std_logic_vector(unsigned(tmr_min) + 1); -- 1 minues
									end if;									
								else
									tmr_ss := std_logic_vector(unsigned(tmr_ss) + 1); --1 s
								end if;							
							else
								tmr_tss := std_logic_vector(unsigned(tmr_tss) + 1);	-- 0.1 s
							end if;							
						else
							counter := counter + 1;
						end if;									
					else
						if tmr_hour > x"0000" then
							timerHH <= tmr_hour;
							timerLL <= tmr_min;
						elsif tmr_min > x"0000" then
							timerHH <= tmr_min;
							timerLL <= tmr_ss;						
						else
							timerHH <= tmr_ss;
							timerLL <= tmr_tss;							
						end if;
				
					end if;

				when PAULSE =>					
					if tmr_hour > x"0000" then
						timerHH <= tmr_hour;
						timerLL <= tmr_min;
					elsif tmr_min > x"0000" then
						timerHH <= tmr_min;
						timerLL <= tmr_ss;						
					else
						timerHH <= tmr_ss;
						timerLL <= tmr_tss;							
					end if;	

				when LAP =>					
					if (hunSecPulse = '1') then
						if (counter = 9) then
							counter := 0; 						
							if unsigned(tmr_tss) = 9 then
								tmr_tss := x"0000";							
								if unsigned(tmr_ss) = 59 then 
									tmr_ss := x"0000";									
									if unsigned(tmr_min) = 59 then
										tmr_min := x"0000";
										tmr_hour:= std_logic_vector(unsigned(tmr_hour) + 1);	-- 1 hours
									else
										tmr_min := std_logic_vector(unsigned(tmr_min) + 1); -- 1 minues
									end if;									
								else
									tmr_ss := std_logic_vector(unsigned(tmr_ss) + 1);--1 s
								end if;							
							else
								tmr_tss := std_logic_vector(unsigned(tmr_tss) + 1); --0.1 s
							end if;							
						else
							counter := counter + 1;
						end if;
					end if;
				
				when others =>
					tmr_tss := (others => '0');
					tmr_ss := (others => '0');
					tmr_min := (others => '0');
					tmr_hour := (others => '0');
					counter := 0;
					lap_flag := '0';		
				
			end case;
		end if;
	end process;

	process (clk, enb, timerHH, timerLL)
		variable bcd_tm : std_logic_vector (19 downto 0);
	begin
			if (rising_edge(clk)) then
				if (enb = '1') then
					bcd_tm := Bin2BCD(timerLL);	
					sw_bcd(7 downto 0) <=  '1' & BCD2ssd(bcd_tm(3 downto 0));
					sw_bcd(15 downto 8) <=  '1' & BCD2ssd(bcd_tm(7 downto 4));
					bcd_tm := Bin2BCD(timerHH);
					sw_bcd(23 downto 16) <= '0' & BCD2ssd(bcd_tm(3 downto 0));
					sw_bcd(31 downto 24) <= '1' & BCD2ssd(bcd_tm(7 downto 4));					
				end if;
			end if;			
	end process;

end Behavioral;

