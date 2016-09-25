
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
Use ieee.std_logic_unsigned.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY addsub_test IS
END addsub_test;
 
ARCHITECTURE behavior OF addsub_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT add_sub
    PORT(
         A : IN  std_logic_vector(3 downto 0);
         B : IN  std_logic_vector(3 downto 0);
         Mode : IN  std_logic;
         Sum : OUT  std_logic_vector(3 downto 0);
         Cout : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(3 downto 0) := (others => '0');
   signal B : std_logic_vector(3 downto 0) := (others => '0');
   signal Mode : std_logic := '0';

 	--Outputs
   signal Sum : std_logic_vector(3 downto 0);
   signal Cout : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: add_sub PORT MAP (
          A => A,
          B => B,
          Mode => Mode,
          Sum => Sum,
          Cout => Cout
        );

   -- Stimulus process
   ab_proc: process
   begin		
      wait for 100 ns;	
		A <= A+2;
		B <= B+3;
   end process;

   mode_proc: process
   begin		
      wait for 50 ns;	
		Mode <= not Mode;
   end process;

END;
