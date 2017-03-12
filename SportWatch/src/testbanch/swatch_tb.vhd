--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:48:30 02/04/2016
-- Design Name:   
-- Module Name:   C:/Users/Charlie/Documents/smartWatch/swatch_tb.vhd
-- Project Name:  smartWatch
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Swatch_Module
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
 
ENTITY swatch_tb IS
END swatch_tb;
 
ARCHITECTURE behavior OF swatch_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Swatch_Module
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         enb : IN  std_logic;
         event_btn2 : IN  std_logic;
         event_btn3 : IN  std_logic;
         sw_blink : OUT  std_logic_vector(7 downto 0);
         sw_bcd : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal enb : std_logic := '0';
   signal event_btn2 : std_logic := '0';
   signal event_btn3 : std_logic := '0';

 	--Outputs
   signal sw_blink : std_logic_vector(7 downto 0);
   signal sw_bcd : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
--         change to source codes
-- 		  --if (counter = 999999) then
--			  if (counter = 1) then-- used for simulation 10ns stand for 1s
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Swatch_Module PORT MAP (
          clk => clk,
          rst => rst,
          enb => enb,
          event_btn2 => event_btn2,
          event_btn3 => event_btn3,
          sw_blink => sw_blink,
          sw_bcd => sw_bcd
        );

   -- Clock process definitions
   clk_process :process
   begin
		wait for clk_period/2;
			clk <= not (clk);
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
		
		--stopwatch mode inside states declaration
	   --type STOPWATCH_STATE is (STOP, TIMING, PAULSE, LAP, STW_RESET);		
		
		--sw_blink states
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
--		--STOP state active
--		--sw_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
--		event_btn2 <= '1';	
--		wait for 10 ns;
--		event_btn2 <= '0';	
--		wait for 50 ns;
		
		--TIMING state active
		--sw_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 50 ns;
		-- time increase
		wait for 100 ns;
		
	   --LAP state active, time continue increase
		--sw_blink will equal to constant BLALL 	: SSD_BLINK_STATE := "10000000";	
		event_btn3 <= '1';	
		wait for 10 ns;
		event_btn3 <= '0';	
		wait for 50 ns;
		
		--TIMING state active, time  increase
		--sw_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 50 ns;
		-- time increase
		wait for 100 ns;
		
		--PAUSE state active, time stop increase
		--sw_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn2 <= '1';	
		wait for 10 ns;
		event_btn2 <= '0';	
		wait for 50 ns;
		
		--STOP state active
 		--sw_blink will equal to constant NO_BLINK : SSD_BLINK_STATE := "00000001";
		event_btn3 <= '1';	
		wait for 10 ns;
		event_btn3 <= '0';	
		wait for 50 ns;      
   end process;
END;
