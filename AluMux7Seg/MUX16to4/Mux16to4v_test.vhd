--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:44:37 10/31/2015
-- Design Name:   
-- Module Name:   D:/Workspace/Ass/MUX16to4Vector/Mux16to4v_test.vhd
-- Project Name:  MUX16to4Vector
-- Target Device:  
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
 
ENTITY Mux16to4v_test IS
END Mux16to4v_test;
 
ARCHITECTURE behavior OF Mux16to4v_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Mux16to4v
    PORT(
         Seg0 : IN  std_logic_vector(3 downto 0);
         Seg1 : IN  std_logic_vector(3 downto 0);
         Seg2 : IN  std_logic_vector(3 downto 0);
         Seg3 : IN  std_logic_vector(3 downto 0);
         Sel : IN  std_logic_vector(1 downto 0);
         HEX : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Seg0 : std_logic_vector(3 downto 0) := (others => '0');
   signal Seg1 : std_logic_vector(3 downto 0) := (others => '0');
   signal Seg2 : std_logic_vector(3 downto 0) := (others => '0');
   signal Seg3 : std_logic_vector(3 downto 0) := (others => '0');
   signal Sel : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal HEX : std_logic_vector(3 downto 0);
 
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: Mux16to4v PORT MAP (
          Seg0 => Seg0,
          Seg1 => Seg1,
          Seg2 => Seg2,
          Seg3 => Seg3,
          Sel => Sel,
          HEX => HEX
        );

   -- Stimulus process
   stim_proc_sel: process
   begin		
      wait for 50 ns;	
		sel <= sel + 1;
	end process;

   stim_proc_seg: process
   begin		
		wait for 200 ns;
		seg0 <= seg0+1;
		seg1 <= seg1+3;
		seg2 <= seg2+7;
		seg3 <= seg3+5;
	end process;

END;
