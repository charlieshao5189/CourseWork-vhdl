library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux16to4v is
    Port ( Seg0, Seg1, Seg2, Seg3 : in  STD_LOGIC_VECTOR (3 downto 0);
           Sel : in  STD_LOGIC_VECTOR (1 downto 0);
           HEX : out  STD_LOGIC_VECTOR (3 downto 0));
end Mux16to4v;

architecture Behavioral of Mux16to4v is

begin
	HEX <= Seg0 when Sel="00" else
			 Seg1 when Sel="01" else
			 Seg2 when Sel="10" else
			 Seg3 ;
			 
end Behavioral;
