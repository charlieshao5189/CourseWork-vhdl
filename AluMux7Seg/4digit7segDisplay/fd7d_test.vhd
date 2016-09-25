--------------------------------------------------------------------------------
-- Engineer:	Qinghui Liu (Brian Liu)
-- Create Date:   08:37:23 11/14/2015
-- Design Name:   
-- VHDL Test Bench Created by ISE for module: fd7d
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY fd7d_test IS
END fd7d_test;
 
ARCHITECTURE behavior OF fd7d_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fd7d
    PORT(
         clk : IN  std_logic;
         seg0 : IN  std_logic_vector(3 downto 0);
         seg1 : IN  std_logic_vector(3 downto 0);
         seg2 : IN  std_logic_vector(3 downto 0);
         seg3 : IN  std_logic_vector(3 downto 0);
         DP : IN  std_logic_vector(3 downto 0);
         segments : OUT  std_logic_vector(6 downto 0);
         dp_out : OUT  std_logic;
         an_out : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '1';
   signal seg0 : std_logic_vector(3 downto 0) := (others => '0');
   signal seg1 : std_logic_vector(3 downto 0) := "0100";
   signal seg2 : std_logic_vector(3 downto 0) := "1000";
   signal seg3 : std_logic_vector(3 downto 0) := "1100";
   signal DP : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal segments : std_logic_vector(6 downto 0);
   signal dp_out : std_logic;
   signal an_out : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fd7d PORT MAP (
          clk => clk,
          seg0 => seg0,
          seg1 => seg1,
          seg2 => seg2,
          seg3 => seg3,
          DP => DP,
          segments => segments,
          dp_out => dp_out,
          an_out => an_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		wait for clk_period/2;
			clk <= not (clk);
   end process clk_process;
	
	-- segment process definitions
   seg_proc: process 
   begin	
			wait for 4*clk_period;
			seg0 <= seg0 + 1;
			seg1 <= seg1 + 1;
			seg2 <= seg2 + 1;
			seg3 <= seg3 + 1;
   end process seg_proc;

	-- dp input process definitions
   dp_proc: process (seg0, seg1, seg2,seg3)
		variable no_dp : integer := 0;
   begin	
			no_dp := no_dp + 1;

			if (no_dp = 1) then
				dp <= "0111";
			elsif (no_dp = 2) then
				dp <= "1011";
			elsif (no_dp = 3) then
				dp <= "1101";
			elsif (no_dp = 4) then
				dp <= "1110";
			else
				dp <= "1111";
				no_dp := 0;
			end if;
   end process dp_proc;

END;
