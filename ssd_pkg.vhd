
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.FSM_process_pkg.all;

package ssd_pkg is

-- Bin to BCD function, 16-bit binary number convert on 20bit BCD
-- with 5 groups of 4-bit, each representing 1 digit
	function Bin2BCD (bin: std_logic_vector(15 downto 0)) return std_logic_vector;
	
-- BCD to 7seg display (ssd), 4-bit BCD value conver to 7-bit
-- representing the 7 segments for the LCD display
	function BCD2ssd (bcd: std_logic_vector(3 downto 0)) return std_logic_vector;
	
-- 7seg blink proccess
	procedure ssd_Blink_Display(	signal blink_flag : in SSD_BLINK_STATE;	
											variable delay_cnt : inout integer;
											constant BLINK_TM  : in integer;
											variable bcd0	: in std_logic_vector (7 downto 0);
											variable bcd1	: in std_logic_vector (7 downto 0);
											variable bcd2	: in std_logic_vector (7 downto 0);
											variable bcd3	: in std_logic_vector (7 downto 0);	
											signal ssd0 : out std_logic_vector(7 downto 0);
											signal ssd1 : out std_logic_vector(7 downto 0);
											signal ssd2 : out std_logic_vector(7 downto 0);
											signal ssd3 : out std_logic_vector(7 downto 0)
										);

	procedure Days_InMonth(
				variable I_MONTH: in  std_logic_vector(15 downto 0);
				variable I_Year : in  std_logic_vector(15 downto 0);
				signal O_DAYS_IN_MONTH : out std_logic_vector(15 downto 0)
   );

end ssd_pkg;

package body ssd_pkg is
--- binary to bcd conversion function----
	function Bin2BCD(bin: std_logic_vector(15 downto 0)) return std_logic_vector is
		variable i : integer := 0;
		variable BCD: std_logic_vector(19 downto 0):= (others => '0');
		variable Bin_tmp: std_logic_vector(15 downto 0):= bin;
	begin 
		for i in 0 to 15 loop
			BCD(19 downto 1) := BCD(18 downto 0); --shift left
			BCD(0) := Bin_tmp(15);
			Bin_tmp(15 downto 1) := Bin_tmp(14 downto 0);
			Bin_tmp(0) := '0';
			
			if(i<15 and BCD(3 downto 0)>"0100" ) then
				BCD(3 downto 0) :=std_logic_vector(unsigned(BCD(3 downto 0)) + 3);
			end if;
			
			if(i<15 and BCD(7 downto 4)>"0100" ) then
				BCD(7 downto 4) := std_logic_vector(unsigned(BCD(7 downto 4)) + 3);
			end if;
			
			if(i<15 and BCD(11 downto 8)>"0100" ) then
				BCD(11 downto 8) := std_logic_vector(unsigned(BCD(11 downto 8)) + 3);
			end if;
			
			if(i<15 and BCD(15 downto 12)>"0100" ) then
				BCD(15 downto 12) := std_logic_vector(unsigned(BCD(15 downto 12)) + 3);
			end if;	

			if(i<15 and BCD(19 downto 16)>"0100" ) then
				BCD(19 downto 16) := std_logic_vector(unsigned(BCD(19 downto 16)) + 3);
			end if;	
			
		end loop;
		return BCD;
	end Bin2BCD;

-- BCD to 7segment display conversion function ---
	function BCD2ssd (bcd:std_logic_vector(3 downto 0)) return std_logic_vector is
		variable SSEG : std_logic_vector(6 downto 0):= (others => '1');
	begin
		case bcd is
			when "0000" => SSEG:="0000001"; -- 0 --
			when "0001" => SSEG:="1001111"; -- 1 --
			when "0010" => SSEG:="0010010"; -- 2 --
			when "0011" => SSEG:="0000110"; -- 3 --
			when "0100" => SSEG:="1001100"; -- 4 --
			when "0101" => SSEG:="0100100"; -- 5 --
			when "0110" => SSEG:="0100000"; -- 6 --
			when "0111" => SSEG:="0001111"; -- 7 --
			when "1000" => SSEG:="0000000"; -- 8 --
			when "1001" => SSEG:="0000100"; -- 9 --
			when "1010" => SSEG:="0001000"; -- a --
			when "1011" => SSEG:="1100000"; -- b --
			when "1100" => SSEG:="0110001"; -- c --
			when "1101" => SSEG:="1000010"; -- d --
			when "1110" => SSEG:="0110000"; -- e --
			when "1111" => SSEG:="0111000"; -- f --			
			when others => SSEG:="1111111";
		end case;
		return SSEG;
	end BCD2ssd;
 

-- ssd blink process
	procedure ssd_Blink_Display(	signal blink_flag : in SSD_BLINK_STATE;	
											variable delay_cnt : inout integer;
											constant BLINK_TM  : in integer;
											variable bcd0	: in std_logic_vector (7 downto 0);
											variable bcd1	: in std_logic_vector (7 downto 0);
											variable bcd2	: in std_logic_vector (7 downto 0);
											variable bcd3	: in std_logic_vector (7 downto 0);	
											signal ssd0 : out std_logic_vector(7 downto 0);
											signal ssd1 : out std_logic_vector(7 downto 0);
											signal ssd2 : out std_logic_vector(7 downto 0);
											signal ssd3 : out std_logic_vector(7 downto 0)	
										) is
	begin
		case blink_flag is
			when NO_BLINK => 
				ssd0  <= bcd0;
				ssd1  <= bcd1;
				ssd2  <= bcd2;
				ssd3  <= bcd3;
				delay_cnt := 0;	
			when BLALL =>
				if (delay_cnt < BLINK_TM/2) then
					ssd0  <= x"FF";
					ssd1  <= x"FF";
					ssd2  <= x"FF";
					ssd3  <= x"FF";
				elsif (delay_cnt  <BLINK_TM ) then						
					ssd0  <= bcd0;
					ssd1  <= bcd1;
					ssd2  <= bcd2;
					ssd3  <= bcd3;	
				else
					delay_cnt := 0;
				end if;
				
			when BL01 =>
				if (delay_cnt < BLINK_TM/2) then
					ssd0  <= x"FF";
					ssd1  <= x"FF";
				elsif (delay_cnt  <BLINK_TM ) then						
					ssd0  <= bcd0;
					ssd1  <= bcd1;
				else
					delay_cnt := 0;
				end if;
				ssd2  <= bcd2;
				ssd3  <= bcd3;	

			when BL23 =>
				if (delay_cnt < BLINK_TM/2) then
					ssd2  <= x"FF";
					ssd3  <= x"FF";
				elsif (delay_cnt  <BLINK_TM ) then						
					ssd2  <= bcd2;
					ssd3  <= bcd3;
				else
					delay_cnt := 0;
				end if;
				ssd0  <= bcd0;
				ssd1  <= bcd1;	

			when BL0 =>
				if (delay_cnt < BLINK_TM/2) then
					ssd0  <= x"FF";
				elsif (delay_cnt  <BLINK_TM ) then						
					ssd0  <= bcd0;					
				else
					delay_cnt := 0;
				end if;
				ssd1  <= bcd1;
				ssd2  <= bcd2;	
				ssd3  <= bcd3;

			when BL1 =>
				if (delay_cnt < BLINK_TM/2) then
					ssd1  <= x"FF";
				elsif (delay_cnt  <BLINK_TM ) then						
					ssd1  <= bcd1;					
				else
					delay_cnt := 0;
				end if;
				ssd0  <= bcd0;
				ssd2  <= bcd2;	
				ssd3  <= bcd3;

			when BL2 =>
				if (delay_cnt < BLINK_TM/2) then
					ssd2  <= x"FF";
				elsif (delay_cnt  <BLINK_TM ) then						
					ssd2  <= bcd2;					
				else
					delay_cnt := 0;
				end if;
				ssd0  <= bcd0;
				ssd1  <= bcd1;	
				ssd3  <= bcd3;

			when BL3 =>
				if (delay_cnt < BLINK_TM/2) then
					ssd3  <= x"FF";
				elsif (delay_cnt  < BLINK_TM ) then						
					ssd3  <= bcd3;					
				else
					delay_cnt := 0;
				end if;
				ssd0  <= bcd0;
				ssd1  <= bcd1;	
				ssd2  <= bcd2;
				
			when others =>
				delay_cnt := 0;
		end case;	
	end;


	procedure Days_InMonth(
					variable I_MONTH: in  std_logic_vector(15 downto 0);
					variable I_Year : in  std_logic_vector(15 downto 0);
					signal O_DAYS_IN_MONTH : out std_logic_vector(15 downto 0)
		) is

		variable month_30d : std_logic;
		variable month_28d : std_logic;
		variable month_31d : std_logic;
		variable month_29d : std_logic;
		variable I_LEAP_YEAR : std_logic;	
		variable I_Year_temp:unsigned(15 downto 0):=unsigned(I_Year);
	begin

		 if I_Year_temp mod 4 =0 then
			if I_Year_temp  mod 100 =0 then
				if I_Year_temp mod 400 =0 then
					I_LEAP_YEAR :='1';
				else 	
					I_LEAP_YEAR :='0';
				end if;
			else 
				I_LEAP_YEAR :='1';
			end if;
		 else 
			I_LEAP_YEAR :='0';
		 end if;	 
		
		if I_MONTH = std_logic_vector(to_unsigned(4,I_MONTH'LENGTH))or --9
			I_MONTH = std_logic_vector(to_unsigned(9,I_MONTH'LENGTH)) or --4
			I_MONTH = std_logic_vector(to_unsigned(6,I_MONTH'LENGTH)) or --6
			I_MONTH = std_logic_vector(to_unsigned(11,I_MONTH'LENGTH)) then  --11 
			month_30d := '1'; 
		else month_30d :='0';
		end if;

		if I_MONTH = std_logic_vector(to_unsigned(2,I_MONTH'LENGTH))and I_LEAP_YEAR = '0' then--2
			month_28d := '1' ; 						 
		else month_28d :='0';
		end if;
		
		if I_MONTH = std_logic_vector(to_unsigned(2,I_MONTH'LENGTH))and I_LEAP_YEAR = '1' then--2
			month_29d := '1' ; 						 
		else month_29d :='0';
		end if;
							  
		if month_30d = '0' and month_28d = '0' and month_29d = '0' then 
		   month_31d := '1' ; 
		else  month_31d := '0';
		end if;
							  
		if month_30d = '1' then
			O_DAYS_IN_MONTH <= std_logic_vector(to_unsigned(30,O_DAYS_IN_MONTH'length));
		elsif month_28d = '1' then
			O_DAYS_IN_MONTH <= std_logic_vector(to_unsigned(28,O_DAYS_IN_MONTH'length));
		elsif month_29d = '1' then
			O_DAYS_IN_MONTH <= std_logic_vector(to_unsigned(29,O_DAYS_IN_MONTH'length));
		else
			O_DAYS_IN_MONTH <= std_logic_vector(to_unsigned(31,O_DAYS_IN_MONTH'length));	
		end if;

	end;

end ssd_pkg;
