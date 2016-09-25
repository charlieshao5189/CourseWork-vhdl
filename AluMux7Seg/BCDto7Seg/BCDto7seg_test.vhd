
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY BCDto7seg_test IS
END BCDto7seg_test;
 
ARCHITECTURE behavior OF BCDto7seg_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT BCDto7seg
    PORT(
         HEX : IN  std_logic_vector(3 downto 0);
         Dec : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal HEX : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal Dec : std_logic_vector(6 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

 
BEGIN
 	-- Instantiate the Unit Under Test (UUT)
   uut: BCDto7seg PORT MAP (
          HEX => HEX,
          Dec => Dec
        );

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 50 ns;	
		HEX <= HEX + 1;
   end process;

END;
