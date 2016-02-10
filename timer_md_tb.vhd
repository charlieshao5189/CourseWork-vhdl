--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:42:17 02/04/2016
-- Design Name:   
-- Module Name:   C:/Users/Charlie/Documents/smartWatch/timer_md_tb.vhd
-- Project Name:  smartWatch
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Timer_Module
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY timer_md_tb IS
END timer_md_tb;
 
ARCHITECTURE behavior OF timer_md_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Timer_Module
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         enb : IN  std_logic;
         event_btn2 : IN  std_logic;
         event_btn3 : IN  std_logic;
         hold_btn3 : IN  std_logic;
         tm_alarm : INOUT  std_logic;
         tm_blink : OUT  std_logic_vector(7 downto 0);
         tm_bcd : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal enb : std_logic := '0';
   signal event_btn2 : std_logic := '0';
   signal event_btn3 : std_logic := '0';
   signal hold_btn3 : std_logic := '0';

	--BiDirs
   signal tm_alarm : std_logic;

 	--Outputs
   signal tm_blink : std_logic_vector(7 downto 0);
   signal tm_bcd : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
--         change to source codes
-- 		  --if (counter = 999999) then
--			  if (counter = 1) then-- used for simulation 10ns stand for 1s
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Timer_Module PORT MAP (
          clk => clk,
          rst => rst,
          enb => enb,
          event_btn2 => event_btn2,
          event_btn3 => event_btn3,
          hold_btn3 => hold_btn3,
          tm_alarm => tm_alarm,
          tm_blink => tm_blink,
          tm_bcd => tm_bcd
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
		
		--timer mode, inside states declaration
	   --type TIMER_STATE is (READY, START, PAULSE, SET_MIN, SET_HOUR,TMR_ALARM, TMR_RESET);
		
		--tm_blink states
		--7segment LCD blink flag							
		--	subtype SSD_BLINK_STATE is std_logic_vector (7 downto 0); 
		--	constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		--	constant BL0 		: SSD_BLINK_STATE := "00000010";
		--	constant BL1 		: SSD_BLINK_STATE := "00000100";
		--	constant BL01 		: SSD_BLINK_STATE := "00001000";
		--	constant BL2 		: SSD_BLINK_STATE := "00010000";
		--	constant BL3 		: SSD_BLINK_STATE := "00100000";
		--	constant BL23 		: SSD_BLINK_STATE := "01000000";
		--	constant BLALL 	: SSD_BLINK_STATE := "10000000";	
		--------------calendar setting buttons is enabled--------------------
		enb <= '1';

		--type TIMER_STATE is (READY, START, PAULSE, SET_MIN, SET_HOUR,TMR_ALARM, TMR_RESET);	
		
		--SET_MIN state active
		--tm_blink will equal to constant BL01 		: SSD_BLINK_STATE := "00001000";
		event_btn3 <= '1';	
		wait for 10 ns;
		event_btn3 <= '0';	
		wait for 50 ns;
		
		--increase minute
		hold_btn3 <= '1';	
		wait for 5000 ns;
		hold_btn3 <= '0';	
		wait for 50 ns;


--   short the time to see alarm 		
--	   --SET_HOUR state active, time continue increase
--		--constant BL23 		: SSD_BLINK_STATE := "01000000";
--		event_btn3 <= '1';	
--		wait for 10 ns;
--		event_btn3 <= '0';	
--		wait for 50 ns;
--		
--		--increase hour
--		hold_btn3 <= '1';	
--		wait for 2000 ns;
--		hold_btn3 <= '0';	
--		wait for 50 ns;
		
		--READT state active, time  increase
		--tm_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 50 ns;
	
		
		--START state active, time stop increase
		--tm_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 50 ns;
		
		--PAULAE state active
 		--tm_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 50 ns;
		
		--START state active, time continue to decrease
 		--tm_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 50 ns;
	   --wait for TMR_ALARM state,tm_alarm will become '1'
		wait for 10000 ns;
      
   end process;
END;
