--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:09:51 02/04/2016
-- Design Name:   
-- Module Name:   C:/Users/Charlie/Documents/smartWatch/calendar_md_tb.vhd
-- Project Name:  smartWatch
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Calendar_Module
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
 
ENTITY calendar_md_tb IS
END calendar_md_tb;
 
ARCHITECTURE behavior OF calendar_md_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Calendar_Module
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
         cd_blink : OUT  std_logic_vector(7 downto 0);
         cd_bcd : OUT  std_logic_vector(31 downto 0)
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


----cd_blink states
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
 	--Outputs
   signal cd_blink : std_logic_vector(7 downto 0);
   signal cd_bcd : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	
--         change to source codes
-- 				--if (counter = 999999) then
--				if (counter = 1) then-- used for simulation 10ns stand for 1s
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Calendar_Module PORT MAP (
          clk => clk,
          rst => rst,
          enb => enb,
          event_btn2 => event_btn2,
          event_btn3 => event_btn3,
          hold_btn3 => hold_btn3,
          hours => hours,
          minues => minues,
          seconds => seconds,
          cd_blink => cd_blink,
          cd_bcd => cd_bcd
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
				
		--------------calendar setting buttons is enabled--------------------
		enb <= '1';
		
		
		--cd_blink will equal to constant BL01: SSD_BLINK_STATE := "00001000";
		--SET_DAY state active
		event_btn3 <= '1';	
		wait for 10 ns;
		event_btn3 <= '0';	
		wait for 50 ns;
		
		--hold button3 
		--day will increase
		hold_btn3 <= '1';	
		wait for 10000 ns;
		hold_btn3 <= '0';	
		wait for 20 ns;
		 
		--cd_blink will equal to constant BL23 : SSD_BLINK_STATE := "01000000";
		--SET_MON state active
		event_btn3 <= '1';	
		wait for 10 ns;
		event_btn3 <= '0';	
		wait for 20 ns;
		
		--hold button3 
		--month will increase
		hold_btn3 <= '1';	
		wait for 10000 ns;
		hold_btn3 <= '0';	
		wait for 20 ns;
		
		
		--CALENDAR state active
		--cd_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 20 ns;
		 
		--CLD_YEAR state active
		--cd_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 20 ns;

      --cd_blink will equal to constant BL0 		: SSD_BLINK_STATE := "00000010";
		--SET_Y0 state active
		event_btn3 <= '1';	
		wait for 10 ns;
		event_btn3 <= '0';	
		wait for 20 ns;
		
		--hold button3 
		--year 1st bit will increase
		hold_btn3 <= '1';	
		wait for 10000 ns;
		hold_btn3 <= '0';	
		wait for 20 ns;
		
      --cd_blink will equal to constant BL1 		: SSD_BLINK_STATE := "00000100";
		--SET_Y1 state active
		event_btn3 <= '1';	
		wait for 10 ns;
		event_btn3 <= '0';	
		wait for 20 ns;
		
		--hold button3 
		--year 2nd bit will increase
		hold_btn3 <= '1';	
		wait for 10000 ns;
		hold_btn3 <= '0';	
		wait for 20 ns;
		
		--cd_blink will equal to constant BL2 		: SSD_BLINK_STATE := "00001000";
		--SET_Y2 state active
		event_btn3 <= '1';	
		wait for 10 ns;
		event_btn3 <= '0';	
		wait for 20 ns;
		
		--hold button3 
		--year 3rd bit will increase
		hold_btn3 <= '1';	
		wait for 10000 ns;
		hold_btn3 <= '0';	
		wait for 20 ns;
		
		--cd_blink will equal to constant BL3 		: SSD_BLINK_STATE := "00010000";
		--SET_Y3 state active
		event_btn3 <= '1';	
		wait for 10 ns;
		event_btn3 <= '0';	
		wait for 20 ns;
		
		--hold button3 
		--year 4th bit will increase
		hold_btn3 <= '1';	
		wait for 10000 ns;
		hold_btn3 <= '0';	
		wait for 20 ns;		

      --CLD_YEAR state active
		--cd_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 20 ns;		
		
		--CLD_DWK state active
		--cd_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 20 ns;	
	
		
		--cd_blink will equal to constant BL0 		: SSD_BLINK_STATE := "00000010";
		--SET_DWK state active
		event_btn3 <= '1';	
		wait for 10 ns;
		event_btn3 <= '0';	
		wait for 20 ns;
		
		--hold button3 
		--weekday will increase
		hold_btn3 <= '1';	
		wait for 10000 ns;
		hold_btn3 <= '0';	
		wait for 20 ns;
		
		--CLD_DWK state active
		--cd_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 20 ns;	
		
		--CALENDAR state active
		--cd_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 20 ns;
		
		--see the calender:days increase
		for I in 0 to 10 loop
		hours <= x"0018";
		minues <= x"0000";
		seconds <= x"0000" ;
		wait for 100 ns;
		hours <= x"0001";--can be any number except x"0018";
		minues <= x"0000";
		seconds <= x"0000" ;
		wait for 100 ns;
		end loop;
		
	
      
   end process;
END;
