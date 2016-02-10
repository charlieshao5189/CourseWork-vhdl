--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:33:20 02/04/2016
-- Design Name:   
-- Module Name:   C:/Users/Charlie/Documents/smartWatch/md_blink_ssd_tb.vhd
-- Project Name:  smartWatch
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MD_BLINK
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
use work.FSM_process_pkg.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY md_blink_ssd_tb IS
END md_blink_ssd_tb;
 
ARCHITECTURE behavior OF md_blink_ssd_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MD_BLINK
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         modul_sel : IN  std_logic_vector(5 downto 0);
         blink_flag : IN  std_logic_vector(7 downto 0);
         ck_bcd : IN  std_logic_vector(31 downto 0);
         al_bcd : IN  std_logic_vector(31 downto 0);
         cd_bcd : IN  std_logic_vector(31 downto 0);
         sw_bcd : IN  std_logic_vector(31 downto 0);
         tm_bcd : IN  std_logic_vector(31 downto 0);
         ssd0 : OUT  std_logic_vector(7 downto 0);
         ssd1 : OUT  std_logic_vector(7 downto 0);
         ssd2 : OUT  std_logic_vector(7 downto 0);
         ssd3 : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal modul_sel : std_logic_vector(5 downto 0) := (others => '0');
   signal blink_flag : std_logic_vector(7 downto 0) := (others => '0');
   signal ck_bcd : std_logic_vector(31 downto 0) := x"11111111";
   signal al_bcd : std_logic_vector(31 downto 0) := x"22222222";
   signal cd_bcd : std_logic_vector(31 downto 0) := x"33333333";
   signal sw_bcd : std_logic_vector(31 downto 0) := x"44444444";
   signal tm_bcd : std_logic_vector(31 downto 0) := x"55555555";

 	--Outputs
   signal ssd0 : std_logic_vector(7 downto 0);
   signal ssd1 : std_logic_vector(7 downto 0);
   signal ssd2 : std_logic_vector(7 downto 0);
   signal ssd3 : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
--         change to source codes
-- 		  --if (counter = 999999) then
--			  if (counter = 1) then-- used for simulation 10ns stand for 1s
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MD_BLINK PORT MAP (
          clk => clk,
          rst => rst,
          modul_sel => modul_sel,
          blink_flag => blink_flag,
          ck_bcd => ck_bcd,
          al_bcd => al_bcd,
          cd_bcd => cd_bcd,
          sw_bcd => sw_bcd,
          tm_bcd => tm_bcd,
          ssd0 => ssd0,
          ssd1 => ssd1,
          ssd2 => ssd2,
          ssd3 => ssd3
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
--   --main 5 moduls switch on/off enable states
--	subtype MODULE_STATES is std_logic_vector (5 downto 0);
--	constant UNKNOWN  		: MODULE_STATES := "000001";
--	constant CLOCK_MD			: MODULE_STATES := "000010";
--	constant ALARM_MD			: MODULE_STATES := "000100";
--	constant CALENDAR_MD		: MODULE_STATES := "001000";	
--	constant STOPWATCH_MD	: MODULE_STATES := "010000";	
--	constant TIMER_MD			: MODULE_STATES := "100000";	
--   end process;
----7segment LCD blink flag							
--	subtype SSD_BLINK_STATE is std_logic_vector (7 downto 0); 
--	constant NO_BLINK : SSD_BLINK_STATE := "00000001";
--	constant BL0 		: SSD_BLINK_STATE := "00000010";
--	constant BL1 		: SSD_BLINK_STATE := "00000100";
--	constant BL01 		: SSD_BLINK_STATE := "00001000";
--	constant BL2 		: SSD_BLINK_STATE := "00010000";
--	constant BL3 		: SSD_BLINK_STATE := "00100000";
--	constant BL23 		: SSD_BLINK_STATE := "01000000";
--	constant BLALL 	: SSD_BLINK_STATE := "10000000";	

  -- hold reset state for 100 ns.
      wait for 100 ns;	
		rst<='1';--rest signal keep 100ns
	   wait for 100 ns;	
		rst<='0';
      wait for 100 ns;	
				
				
	   blink_flag<=NO_BLINK;
		wait for 200 ns;
		
	   modul_sel<=UNKNOWN;
		wait for 500 ns;
		modul_sel<=CLOCK_MD;	
		wait for 500 ns;
		modul_sel<=ALARM_MD;	
		wait for 500 ns;
		modul_sel<=CALENDAR_MD;	
		wait for 500 ns;
		modul_sel<=STOPWATCH_MD;
		wait for 500 ns;
		modul_sel<=TIMER_MD;	
		wait for 500 ns;
		
		
		blink_flag<=BLALL;
		wait for 200 ns;
		
	   modul_sel<=UNKNOWN;
		wait for 500 ns;
		modul_sel<=CLOCK_MD;	
		wait for 500 ns;
		modul_sel<=ALARM_MD;	
		wait for 500 ns;
		modul_sel<=CALENDAR_MD;	
		wait for 500 ns;
		modul_sel<=STOPWATCH_MD;
		wait for 500 ns;
		modul_sel<=TIMER_MD;	
		wait for 500 ns;
		
		
		end process;

END;
