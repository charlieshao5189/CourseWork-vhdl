--- define component 2to4 decoder for anode_select
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder2to4 is
	port(
			A : in std_logic_vector(1 downto 0);
			AN : out std_logic_vector(3 downto 0)
		  );
end Decoder2to4;

architecture dec_arc of Decoder2to4 is
begin
	AN <= "1110" when A="00" else
			"1101" when A="01" else
			"1011" when A="10" else
			"0111";
end dec_arc;

--- define component Mux4to1 for  dp_select
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux4to1 is
	port(
			inp : in std_logic_vector(3 downto 0);
			sel : in std_logic_vector(1 downto 0);
			oup : out std_logic
		  );
end Mux4to1;
	
architecture mux4_arc of Mux4to1 is
begin
	with sel select 
	 oup <= inp(3) when "00",
			  inp(2) when "01",
			  inp(1) when "10",
			  inp(0) when others;

end mux4_arc;

--- define component Mux16to4vector for digit_select
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux16to4 is
	port(
			seg0, seg1, seg2,seg3 : in std_logic_vector(3 downto 0);
			sel : in std_logic_vector(1 downto 0);
			o_hex: out std_logic_vector(3 downto 0)
		  );
	
end Mux16to4;

architecture mux16_arc of Mux16to4 is

begin
	with sel select 
	 o_hex <= seg0 when "00",
				 seg1 when "01",
			    seg2 when "10",
			    seg3 when others;

end mux16_arc;

--- define component BCD-7seg decoder for LED_display
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

--- build 4 digit 7-segment display
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity fd7d is
	port (
			clk: in std_logic;
			seg0, seg1, seg2, seg3 : in std_logic_vector(3 downto 0);
			DP : in std_logic_vector(3 downto 0);
			segments : out std_logic_vector(6 downto 0);
			dp_out : out std_logic;
			an_out : out std_logic_vector(3 downto 0)	
		   );
	
end fd7d;

architecture Behavioral of fd7d is
	COMPONENT Mux4to1
	PORT(
		inp : IN std_logic_vector(3 downto 0);
		sel : IN std_logic_vector(1 downto 0);          
		oup : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT Mux16to4
	PORT(
		seg0 : IN std_logic_vector(3 downto 0);
		seg1 : IN std_logic_vector(3 downto 0);
		seg2 : IN std_logic_vector(3 downto 0);
		seg3 : IN std_logic_vector(3 downto 0);
		sel : IN std_logic_vector(1 downto 0);          
		o_hex : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;	
	
	COMPONENT Decoder2to4
	PORT(
		A : IN std_logic_vector(1 downto 0);          
		AN : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT BCDto7seg
	PORT(
		HEX : IN std_logic_vector(3 downto 0);          
		Dec : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;	

	signal hex_in : std_logic_vector(3 downto 0);
	signal sel : std_logic_vector(1 downto 0) := (others => '0');
	
begin
	sel_pro: process(clk)
	begin
		if ( clk'EVENT and clk = '1' ) then
			sel <= sel + '1';
		end if;
	end process ;

	comp0: Decoder2to4 port map(sel, an_out);
	comp1: Mux16to4 port map(seg0, seg1, seg2, seg3, 
									 sel, hex_in);
	comp2: BCDto7seg port map(hex_in, segments);
	comp3: Mux4to1 port map(DP, sel, dp_out);
	
	
end Behavioral;

