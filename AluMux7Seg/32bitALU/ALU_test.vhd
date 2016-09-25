--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:11:41 11/15/2015
-- Design Name:   
-- Project Name:  ALU_4bit
-- Description:   

-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ALU_test IS
END ALU_test;
 
ARCHITECTURE behavior OF ALU_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         clk : IN  std_logic;
         opco : IN  std_logic_vector(3 downto 0);
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         Y : OUT  std_logic_vector(31 downto 0);
         nzco : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '1';
   signal opco : std_logic_vector(3 downto 0) := (others => '0');
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Y : std_logic_vector(31 downto 0);
   signal nzco : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          clk => clk,
          opco => opco,
          A => A,
          B => B,
          Y => Y,
          nzco => nzco
        );

   -- Clock process definitions
   clk_process :process
   begin
		wait for clk_period/2;
		clk <= not clk;
   end process clk_process;
 

   -- Stimulus process
   opco_proc: process
   begin		
      wait for clk_period;
		opco <= opco+1;
   end process opco_proc;
	
   ab_proc: process
   begin	
		b <= X"7C7A7F5B";	
      wait for clk_period*16;
		a <= a+X"01F9FBED";
   end process ab_proc;	

END;
