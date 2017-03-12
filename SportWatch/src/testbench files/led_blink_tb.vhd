--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:18:33 02/03/2016
-- Design Name:   
-- Module Name:   /home/charlie/Documents/VHDL/Nexys3Projects/Brian/smartWatch/led_blink_tb.vhd
-- Project Name:  smartWatch
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: LED_Blink
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
 
ENTITY led_blink_tb IS
END led_blink_tb;
 
ARCHITECTURE behavior OF led_blink_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT LED_Blink
    PORT(
         clk : IN  std_logic;
         led_in : IN  std_logic_vector(4 downto 0);
         blink_flag : IN  std_logic_vector(7 downto 0);
         led_out : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    


----blink_flag input, 7segment LCD blink flag, led only blink when blink_flag /= NO_BLINK							
--	subtype SSD_BLINK_STATE is std_logic_vector (7 downto 0); 
--	constant NO_BLINK : SSD_BLINK_STATE := "00000001";
--	constant BL0 		: SSD_BLINK_STATE := "00000010";
--	constant BL1 		: SSD_BLINK_STATE := "00000100";
--	constant BL01 		: SSD_BLINK_STATE := "00001000";
--	constant BL2 		: SSD_BLINK_STATE := "00010000";
--	constant BL3 		: SSD_BLINK_STATE := "00100000";
--	constant BL23 		: SSD_BLINK_STATE := "01000000";
--	constant BLALL 	: SSD_BLINK_STATE := "10000000";	
   --Inputs
   signal clk : std_logic := '0';
   signal led_in : std_logic_vector(4 downto 0) := "11111";
   signal blink_flag : std_logic_vector(7 downto 0) := NO_BLINK;

 	--Outputs
   signal led_out : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: LED_Blink PORT MAP (
          clk => clk,
          led_in => led_in,
          blink_flag => blink_flag,
          led_out => led_out
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		blink_flag<= NO_BLINK;
      wait for 1000 ns;	--led_out="100000";
		
		led_in<="11111";
      wait for 1000 ns;	--led_out="11111";

      led_in<="00001";
      wait for 1000 ns;	--led_out="00001";
		
      led_in<="00010";
      wait for 1000 ns;	--led_out="00010";

      led_in<="00100";
      wait for 1000 ns;	--led_out="00100";

      led_in<="01000";
      wait for 1000 ns;	--led_out="01000";

      led_in<="10000";
      wait for 1000 ns;	--led_out="10000";
		
		blink_flag<= BLALL; -- can be any states except NO_BLINK
      wait for 1000 ns;	--led_out="100000";

   end process;

END;
