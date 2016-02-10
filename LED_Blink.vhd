----------------------------------------------------------------------------------
-- Company: HSN	
-- Engineer: Group 4 (Qinghui Liu, Zhili Shao,  Joseph Fotso)
-- 
-- Create Date:    14:27:31 02/01/2016  
-- Design Name: 
-- Module Name:    led blink process for each module selected
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.FSM_process_pkg.all;

entity LED_Blink is
    Port ( clk : in  STD_LOGIC;
			  led_in: in STD_LOGIC_VECTOR (4 downto 0);
           blink_flag : in  STD_LOGIC_VECTOR (7 downto 0);
           led_out : out  STD_LOGIC_VECTOR (4 downto 0));
end LED_Blink;

architecture Behavioral of LED_Blink is
	signal CLK_1HZ: std_logic;
	signal CLK_1KHZ: std_logic;
	constant LED_OFF : STD_LOGIC_VECTOR (4 downto 0):= "00000";
begin
	process (clk)
		variable counter, counter_next, i : natural := 0;
	begin
		if rising_edge(clk) then
				counter := counter_next;
				counter_next := counter + 1;
				if (counter = 999999) then
					counter_next := 0;				
					if (i = 99) then
						i := 0;
						CLK_1HZ <= not CLK_1HZ;
					else 
						i := i + 1;
					end if;
					CLK_1KHZ <= not CLK_1KHZ;
				end if;
		end if;	
	end process;
	
	process (clk, CLK_1KHZ, CLK_1HZ)
	begin 
		if rising_edge(clk) then
			if (blink_flag = NO_BLINK) then
				if (CLK_1KHZ = '1') then
					led_out <= led_in;
				end if;
			else
				if (CLK_1HZ = '1') then
					led_out <= led_in;
				else
					led_out <= LED_OFF;
				end if;				
			end if;
		end if;
	end process;
	
end Behavioral;

