----------------------------------------------------------------------------------
-- Company: HSN	
-- Engineer: Qinghui Liu , Zhili Shao, Joseph Fotso
-- 
-- Create Date:    14:27:31 02/01/2016 
-- Design Name: 
-- Module Name:    smtWatch - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use work.ssd_pkg.all;
use work.FSM_process_pkg.all;


entity smtWatch is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           btn1 : in  STD_LOGIC;
			  btn2: in	STD_LOGIC;
			  btn3: in  STD_LOGIC;
           mode_led : out  std_logic_vector (4 downto 0);
			  ssd : out std_logic_vector(7 downto 0);
			  anode : out std_logic_vector(3 downto 0));
end smtWatch;

architecture Behavioral of smtWatch is

	COMPONENT dButton
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		btn : IN std_logic;          
		btn_press 	: OUT std_logic;
		btn_hold 	: OUT std_logic;
		btn_release : OUT std_logic
		);
	END COMPONENT;

	COMPONENT SSD_Mux
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		in0 : IN std_logic_vector(7 downto 0);
		in1 : IN std_logic_vector(7 downto 0);
		in2 : IN std_logic_vector(7 downto 0);
		in3 : IN std_logic_vector(7 downto 0);          
		sseg 	: OUT std_logic_vector(7 downto 0);
		an 	: OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	COMPONENT LED_Blink
	PORT(
		clk : IN std_logic;
		led_in : IN std_logic_vector(4 downto 0);
		blink_flag : IN SSD_BLINK_STATE;         
		led_out : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;

	COMPONENT Clock_Module
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		enb : IN std_logic;
		event_btn2 : IN std_logic;
		event_btn3 : IN std_logic;          
		ck_blink : OUT SSD_BLINK_STATE;  
      hours 	: INOUT  STD_LOGIC_VECTOR (15 downto 0);
      minues 	: INOUT  STD_LOGIC_VECTOR (15 downto 0);
      seconds 	: INOUT  STD_LOGIC_VECTOR (15 downto 0);			
		ck_bcd	: OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Alarm_Module
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		enb  : IN std_logic;
		event_btn2 : IN std_logic;
		event_btn3 : IN std_logic;
		hold_btn3 : IN std_logic;
		hours : IN std_logic_vector(15 downto 0);
		minues : IN std_logic_vector(15 downto 0);
		seconds : IN std_logic_vector(15 downto 0);          
		alarm_flag : INOUT std_logic;
		al_blink	  : OUT SSD_BLINK_STATE; 
		al_bcd : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	COMPONENT Calendar_Module
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		enb : IN std_logic;
		event_btn2 : IN std_logic;
		event_btn3 : IN std_logic;
		hold_btn3 : IN std_logic;
		hours : IN std_logic_vector(15 downto 0);
		minues : IN std_logic_vector(15 downto 0);
		seconds : IN std_logic_vector(15 downto 0);          
		cd_blink : OUT SSD_BLINK_STATE;  
		cd_bcd  : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Swatch_Module
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		enb : IN std_logic;
		event_btn2 : IN std_logic;
		event_btn3 : IN std_logic;          
		sw_blink : OUT SSD_BLINK_STATE; 
		sw_bcd : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	COMPONENT Timer_Module
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		enb : IN std_logic;
		event_btn2 : IN std_logic;
		event_btn3 : IN std_logic;
		hold_btn3 : IN std_logic;      
		tm_alarm : inout  STD_LOGIC;		
		tm_blink : OUT  SSD_BLINK_STATE; 
		tm_bcd : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	COMPONENT MD_Switch
	PORT(
		envent_btn1 : IN std_logic;
		pr_modul : IN MODULE_STATES;	
		ck_blink : IN SSD_BLINK_STATE;
		al_blink : IN SSD_BLINK_STATE;
		cd_blink : IN SSD_BLINK_STATE;
		sw_blink : IN SSD_BLINK_STATE;
		tm_blink : IN SSD_BLINK_STATE;
		clock_alarm : in  STD_LOGIC;
		timer_alarm : in  STD_LOGIC;         
		nx_modul : OUT MODULE_STATES;	
		modul_set : OUT std_logic_vector(4 downto 0);
		blink_flag : OUT SSD_BLINK_STATE
		);
	END COMPONENT;


	COMPONENT MD_BLINK
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		modul_sel : IN std_logic_vector(5 downto 0);
		blink_flag : IN std_logic_vector(7 downto 0);
		ck_bcd : IN std_logic_vector(31 downto 0);
		al_bcd : IN std_logic_vector(31 downto 0);
		cd_bcd : IN std_logic_vector(31 downto 0);
		sw_bcd : IN std_logic_vector(31 downto 0);
		tm_bcd : IN std_logic_vector(31 downto 0);          
		ssd0 : OUT std_logic_vector(7 downto 0);
		ssd1 : OUT std_logic_vector(7 downto 0);
		ssd2 : OUT std_logic_vector(7 downto 0);
		ssd3 : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	signal blink_flag : SSD_BLINK_STATE; -- blink on/off for led and ssd, refer to FSM_process_pkg
	signal pr_modul, nx_modul : MODULE_STATES;	-- modules switch signal,refer to FSM_process_pkg
	
	-- button events signal 
	signal press_btn, hold_btn, release_btn : std_logic_vector (1 to 3) := (others => '0');
	-- enable module seleted and indicate it by lit on LED accordingly
	signal MODUL_SET  : std_logic_vector (4 downto 0) := (others => '0');
	
	--store real time used to caculate calendar or clock alarm generating
	signal hours, minues, seconds     : std_logic_vector(15 downto 0) := x"0000";
	
	-- 7-segement data
	signal ssd0, ssd1, ssd2, ssd3: std_logic_vector(7 downto 0):= x"FF";
	--output data form each module
	signal ck_bcd, al_bcd, cd_bcd, sw_bcd, tm_bcd : std_logic_vector (31 downto 0);
	--output blink_flag from each module
	signal ck_blink, al_blink, cd_blink, sw_blink, tm_blink: SSD_BLINK_STATE;	
	--output alarm flag from alarm module
	signal clock_alarm  : std_logic := '0';	
	signal timer_alarm  : std_logic := '0';	
	
begin
	--lower section of state transitions process--
	process(clk, rst)
	begin	
		if(clk'EVENT and clk = '1') then
			if (rst = '1') then
				pr_modul <= UNKNOWN;
			else 
				pr_modul<= nx_modul;
			end if;
		end if;
	end process;
	--operation buttons initialization...
	--button 1 used to switch on/off modules, 
	--button 2 and button 3 used to inside operation of each module
	--btn1_ev: dButton PORT MAP(clk,rst, btn1, press_btn(1) ,hold_btn(1) ,release_btn(1) );
	--btn2_ev: dButton PORT MAP(clk,rst, btn2, press_btn(2) ,hold_btn(2) ,release_btn(2) );
	--btn3_ev: dButton PORT MAP(clk,rst, btn3, press_btn(3) ,hold_btn(3) ,release_btn(3) );
	btn1_ev: dButton PORT MAP(clk,rst, btn1, open ,open ,release_btn(1) );
	btn2_ev: dButton PORT MAP(clk,rst, btn2, open ,open ,release_btn(2) );	
	btn3_ev: dButton PORT MAP(clk,rst, btn3, open ,hold_btn(3) ,release_btn(3) );
	
	--modules switch unit used to  
	--each press&release button 1 will change among five moduls
	--clock, alarm, calendar, stopwatch, and timer
	switch: MD_Switch PORT MAP(release_btn(1), pr_modul, 
										ck_blink,al_blink, cd_blink, sw_blink, tm_blink, 
										clock_alarm, timer_alarm, 
										nx_modul, MODUL_SET,	blink_flag);
										
	--five functional modules initializations
	clock_md: Clock_Module PORT MAP(	clk, rst, MODUL_SET(0), 
												release_btn(2), hold_btn(3), ck_blink, 
												hours, minues, seconds, ck_bcd );

	alarm_md: Alarm_Module PORT MAP(clk, rst, MODUL_SET(1), 
											release_btn(2) ,release_btn(3),hold_btn(3),
											hours, minues, seconds, clock_alarm, al_blink, al_bcd);
											
	clder_md: Calendar_Module PORT MAP(clk, rst, MODUL_SET(2), 							
												 release_btn(2) ,release_btn(3),hold_btn(3), 
												 hours, minues, seconds, cd_blink, cd_bcd); 	
											 
	swatch_md: Swatch_Module PORT MAP(clk, rst, MODUL_SET(3), release_btn(2), release_btn(3), 
												 sw_blink, sw_bcd );

	timer_md: Timer_Module PORT MAP( clk, rst, MODUL_SET(4), 
												release_btn(2), release_btn(3), hold_btn(3),
												timer_alarm, tm_blink, tm_bcd );

	-- process ssd blink and bcd data for each module selected 
	md_blink_ssd: MD_BLINK PORT MAP(clk, rst, pr_modul, blink_flag, 
												ck_bcd, al_bcd, cd_bcd, sw_bcd, tm_bcd,
												ssd0, ssd1, ssd2, ssd3);

	-- process led blink for each module seleted											
	led_mode: LED_Blink PORT MAP(clk, MODUL_SET, blink_flag, mode_led);											


	-- process ssd blink for each module seleted													
	ssd_dsp: SSD_Mux PORT MAP(clk ,rst, ssd0, ssd1, ssd2, ssd3, ssd, anode);

end Behavioral;

