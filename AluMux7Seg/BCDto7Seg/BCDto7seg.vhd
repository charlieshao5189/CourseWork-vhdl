library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCDto7seg is
    Port ( HEX : in  STD_LOGIC_VECTOR(3 downto 0);
           Dec : out  STD_LOGIC_VECTOR(6 downto 0)
			 );
end BCDto7seg;

architecture BCD_arc of BCDto7seg is
	signal digit : std_logic_vector(6 downto 0);
begin
	process (HEX)
		variable sel : std_logic_vector(3 downto 0);
	begin
		sel := HEX;
		case sel is 
			when x"0" => digit <= "0000001";--display_0;
			when x"1" => digit <= "1001111";--display_1;
			when x"2" => digit <= "0010010";--display_2;
			when x"3" => digit <= "0000110";--display_3;
			when x"4" => digit <= "1001100";--display_4;
			when x"5" => digit <= "0100100";--display_5;
			when x"6" => digit <= "0100000";--display_6;
			when x"7" => digit <= "0001111";--display_7;
			when x"8" => digit <= "0000000";--display_8;
			when x"9" => digit <= "0000100";--display_9;
			when x"A" => digit <= "0001000";--display_A;
			when x"b" => digit <= "1100000";--display_b;
			when x"C" => digit <= "0110001";--display_C;
			when x"d" => digit <= "1000010";--display_d;
			when x"E" => digit <= "0110000";--display_E;
			when others => digit <= "0111000";--display_F;
		end case;
	end process;
	Dec<= digit;
end BCD_arc;



