--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:59:48 02/03/2016
-- Design Name:   
-- Module Name:   C:/Users/qhsam/Desktop/VHDLv2/smt_watch/md_switch_tb.vhd
-- Project Name:  smt_watch
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MD_Switch
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
USE ieee.numeric_std.ALL;
use work.ssd_pkg.all;
use work.FSM_process_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY md_switch_tb IS
END md_switch_tb;
 
ARCHITECTURE behavior OF md_switch_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MD_Switch
    PORT(
         envent_btn1 : IN  std_logic;
         pr_modul : IN  std_logic_vector(5 downto 0);
         ck_blink : IN  std_logic_vector(7 downto 0);
         al_blink : IN  std_logic_vector(7 downto 0);
         cd_blink : IN  std_logic_vector(7 downto 0);
         sw_blink : IN  std_logic_vector(7 downto 0);
         tm_blink : IN  std_logic_vector(7 downto 0);
         clock_alarm : IN  std_logic;
         timer_alarm : IN  std_logic;
         nx_modul : OUT  std_logic_vector(5 downto 0);
         modul_set : OUT  std_logic_vector(4 downto 0);
         blink_flag : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
--	constant UNKNOWN  		: MODULE_STATES := "000001";
--	constant CLOCK_MD			: MODULE_STATES := "000010";
--	constant ALARM_MD			: MODULE_STATES := "000100";
--	constant CALENDAR_MD		: MODULE_STATES := "001000";	
--	constant STOPWATCH_MD	: MODULE_STATES := "010000";	
--	constant TIMER_MD			: MODULE_STATES := "100000";	
	
--	constant NO_BLINK : SSD_BLINK_STATE := "00000001";
--	constant BL0 		: SSD_BLINK_STATE := "00000010";
--	constant BL1 		: SSD_BLINK_STATE := "00000100";
--	constant BL01 		: SSD_BLINK_STATE := "00001000";
--	constant BL2 		: SSD_BLINK_STATE := "00010000";
--	constant BL3 		: SSD_BLINK_STATE := "00100000";
--	constant BL23 		: SSD_BLINK_STATE := "01000000";
--	constant BLALL 	: SSD_BLINK_STATE := "10000000";	

   signal envent_btn1 : std_logic := '0';
   signal pr_modul : std_logic_vector(5 downto 0) := UNKNOWN ;
   signal ck_blink : std_logic_vector(7 downto 0) := NO_BLINK;
   signal al_blink : std_logic_vector(7 downto 0) := BL0;
   signal cd_blink : std_logic_vector(7 downto 0) := BL01;
   signal sw_blink : std_logic_vector(7 downto 0) := BL2;
   signal tm_blink : std_logic_vector(7 downto 0) := BL23;
   signal clock_alarm : std_logic := '0';
   signal timer_alarm : std_logic := '0';

 	--Outputs
   signal nx_modul : std_logic_vector(5 downto 0);
   signal modul_set : std_logic_vector(4 downto 0);
   signal blink_flag : std_logic_vector(7 downto 0);

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MD_Switch PORT MAP (
          envent_btn1 => envent_btn1,
          pr_modul => pr_modul,
          ck_blink => ck_blink,
          al_blink => al_blink,
          cd_blink => cd_blink,
          sw_blink => sw_blink,
          tm_blink => tm_blink,
          clock_alarm => clock_alarm,
          timer_alarm => timer_alarm,
          nx_modul => nx_modul,
          modul_set => modul_set,
          blink_flag => blink_flag
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 30 ns;	
		envent_btn1 <= '1';
		wait for 10 ns;	
		envent_btn1 <= '0';
	
   end process;
	
	   -- Stimulus process
   modul_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;	
		pr_modul <= nx_modul;
	
   end process;
	
	blink_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 40 ns;	
		 ck_blink <= blink_flag;
		 al_blink <= std_logic_vector(unsigned(al_blink) + unsigned(al_blink));
		 cd_blink <= std_logic_vector(unsigned(cd_blink) + unsigned(cd_blink));
		 sw_blink <= BL3;
		 tm_blink <= BLALL;	
		wait for 40 ns;
		 sw_blink <= std_logic_vector(unsigned(cd_blink) + unsigned(cd_blink));
		 tm_blink <= blink_flag;
		 ck_blink <= std_logic_vector(unsigned(cd_blink) + unsigned(cd_blink));

	 
	end process;
	
	alarm_proc: process
   begin		
		 wait for 80 ns;
		 clock_alarm <= not clock_alarm;
	end process;
	
	alarm2_proc: process
   begin		
		 wait for 50 ns;
		 timer_alarm <= not timer_alarm;
	end process;
	

END;
