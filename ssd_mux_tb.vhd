--------------------------------------------------------------------------------
-- Company: 	HSB	
-- Engineer:	Qinghui Liu, Zhili Shao, Joseph
--
-- Create Date:   21:19:36 01/30/2016
-- Design Name:   
-- Module Name:   C:/Users/qhsam/Desktop/VHDLv2/digital_clock/ssd_mux_tb.vhd
-- Project Name:  digital_clock
-- Target Device:  
-- Tool versions:  
-- Description:   
-- Testbench for SSD_Mux modul

-- VHDL Test Bench Created by ISE for module: SSD_Mux
-- 
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use work.ssd_pkg.all;
use work.FSM_process_pkg.all;
 
ENTITY ssd_mux_tb IS
END ssd_mux_tb;
 
ARCHITECTURE behavior OF ssd_mux_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SSD_Mux
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         in0 : IN  std_logic_vector(7 downto 0);
         in1 : IN  std_logic_vector(7 downto 0);
         in2 : IN  std_logic_vector(7 downto 0);
         in3 : IN  std_logic_vector(7 downto 0);
         sseg : OUT  std_logic_vector(7 downto 0);
         an : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal in0 : std_logic_vector(7 downto 0) := (others => '0');
   signal in1 : std_logic_vector(7 downto 0) := (others => '0');
   signal in2 : std_logic_vector(7 downto 0) := (others => '0');
   signal in3 : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal sseg : std_logic_vector(7 downto 0);
   signal an : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	--(NO_BLINK, BL0, BL1, BL01, BL2, BL3, BL23, BLALL);
	signal  blink_flag: SSD_BLINK_STATE := NO_BLINK; 

	shared   variable test  : std_logic_vector(15 downto 0);
	shared	variable bcd0	: std_logic_vector (7 downto 0);
	shared	variable bcd1	: std_logic_vector (7 downto 0);
	shared	variable bcd2	: std_logic_vector (7 downto 0);
	shared	variable bcd3	: std_logic_vector (7 downto 0);	
		
	shared	variable test1:integer := 1230;
	shared	variable test2:integer := 4567;
	shared	variable test3:integer := 8901;
	shared	variable test4:integer := 2345;	
	
	shared 	variable bcd_tm : std_logic_vector (19 downto 0);
	shared 	variable delay_cnt : integer range 0 to 1;
	constant BLINK_TM  : integer := 2;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SSD_Mux PORT MAP (
          clk => clk,
          rst => rst,
          in0 => in0,
          in1 => in1,
          in2 => in2,
          in3 => in3,
          sseg => sseg,
          an => an
        );

   -- Clock process definitions
   clk_process :process
   begin
		wait for clk_period/2;
			clk <= not (clk);
   end process;
 
   -- Stimulus process
   number_proc: process
   begin		
		test := std_logic_vector(to_unsigned(test1, 16));

		bcd_tm := Bin2BCD(test);
		
		bcd0 := '1' & BCD2ssd(bcd_tm(3 downto 0));
		bcd1 := '1' & BCD2ssd(bcd_tm(7 downto 4));
		bcd2 := '1' & BCD2ssd(bcd_tm(11 downto 8));
		bcd3 := '1' & BCD2ssd(bcd_tm(15 downto 12));	
		
      wait for clk_period*4;
		test := std_logic_vector(to_unsigned(test2, 16));

		bcd_tm := Bin2BCD(test);
		
		bcd0 := '0' & BCD2ssd(bcd_tm(3 downto 0));
		bcd1 := '0' & BCD2ssd(bcd_tm(7 downto 4));
		bcd2 := '1' & BCD2ssd(bcd_tm(11 downto 8));
		bcd3 := '1' & BCD2ssd(bcd_tm(15 downto 12));			
		
		wait for clk_period*4;
		test := std_logic_vector(to_unsigned(test3, 16));

		bcd_tm := Bin2BCD(test);
		
		bcd0 := '1' & BCD2ssd(bcd_tm(3 downto 0));
		bcd1 := '1' & BCD2ssd(bcd_tm(7 downto 4));
		bcd2 := '0' & BCD2ssd(bcd_tm(11 downto 8));
		bcd3 := '0' & BCD2ssd(bcd_tm(15 downto 12));
		
		wait for clk_period*4;
		test := std_logic_vector(to_unsigned(test4, 16));

		bcd_tm := Bin2BCD(test);
		
		bcd0 := '0' & BCD2ssd(bcd_tm(3 downto 0));
		bcd1 := '1' & BCD2ssd(bcd_tm(7 downto 4));
		bcd2 := '0' & BCD2ssd(bcd_tm(11 downto 8));
		bcd3 := '1' & BCD2ssd(bcd_tm(15 downto 12));	

   end process;

   -- Stimulus process
   ssd_proc: process(clk)
   begin	
		ssd_Blink_Display( blink_flag, delay_cnt, BLINK_TM,
								 bcd0, bcd1, bcd2, bcd3,
								 in0, in1, in2, in3  
								);
	end process;
END;
