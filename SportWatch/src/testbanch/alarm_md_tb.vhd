--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:56:37 02/03/2016
-- Design Name:   
-- Module Name:   C:/Users/qhsam/Desktop/VHDLv2/smt_watch/alarm_md_tb.vhd
-- Project Name:  smt_watch
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Alarm_Module
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY alarm_md_tb IS
END alarm_md_tb;
 
ARCHITECTURE behavior OF alarm_md_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Alarm_Module
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         enb : IN  std_logic;
         event_btn2 : IN  std_logic;
         event_btn3 : IN  std_logic;
         hold_btn3 : IN  std_logic;
         hours : IN  std_logic_vector(15 downto 0);
         minues : IN  std_logic_vector(15 downto 0);
         seconds : IN  std_logic_vector(15 downto 0);
         alarm_flag : INOUT  std_logic;
         al_blink : OUT  std_logic_vector(7 downto 0);
         al_bcd : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal enb : std_logic := '0';
   signal event_btn2 : std_logic := '0';
   signal event_btn3 : std_logic := '0';
   signal hold_btn3 : std_logic := '0';
   signal hours : std_logic_vector(15 downto 0) := (others => '0');
   signal minues : std_logic_vector(15 downto 0) := (others => '0');
   signal seconds : std_logic_vector(15 downto 0) := (others => '0');

	--BiDirs
   signal alarm_flag : std_logic;

 	--Outputs
   signal al_blink : std_logic_vector(7 downto 0);
   signal al_bcd : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
 
--         change to source codes
-- 				--if (counter = 999999) then
--				if (counter = 1) then-- used for simulation 10ns stand for 1s
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Alarm_Module PORT MAP (
          clk => clk,
          rst => rst,
          enb => enb,
          event_btn2 => event_btn2,
          event_btn3 => event_btn3,
          hold_btn3 => hold_btn3,
          hours => hours,
          minues => minues,
          seconds => seconds,
          alarm_flag => alarm_flag,
          al_blink => al_blink,
          al_bcd => al_bcd
        );

 -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 	
	-- simulation for operation
   operation_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		rst<='1';--rest signal keep 100ns
	   wait for 100 ns;	
		rst<='0';
      wait for 100 ns;	
				
		--------------alarm setting buttons is enabled--------------------
		enb <= '1';
		--al_blink will equal to constant BL01: SSD_BLINK_STATE := "00001000";
		--SET_MIN state active
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 50 ns;
		
		--hold button3 
		--minute will increase
		hold_btn3 <= '1';	
		wait for 10000 ns;
		hold_btn3 <= '0';	
		wait for 20 ns;
	
			
		--al_blink will equal to constant BL23 : SSD_BLINK_STATE := "01000000";
		--SET_HOUR state active
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 20 ns;
		
		--hold button3 
		--hour will increase
		hold_btn3 <= '1';	
		wait for 10000 ns;
		hold_btn3 <= '0';	
		wait for 20 ns;
		
		--al_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		--READY state active
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 100 ns;
		
		--active alarm, alarm_flag will output '1'
		hours<=std_logic_vector(to_unsigned(7,hours'LENGTH));
		minues<=std_logic_vector(to_unsigned(14,minues'LENGTH));
		seconds<=std_logic_vector(to_unsigned(1,seconds'LENGTH));
		wait for 100 ns;
		
		--al_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		--CLEAN state active, hours and minutes will be zero
		event_btn3 <= '1';	
		wait for 10 ns;
		event_btn3 <= '0';	
		wait for 200 ns;
		
	
		
		--------------alarm setting buttons is not enabled--------------------
		enb <= '0';
		wait for 200 ns;
		-- press button2 will do nothing
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 20 ns;
	   
      --see the change of time
		wait for 10000 ns;	
      
   end process;

END;
