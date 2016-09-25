-- full_adder define
library IEEE;
use ieee.std_logic_1164.ALL;

entity fulladder is
	port (
			a, b, cin : in std_logic;
			sum, cout: out std_logic
			);
end fulladder;

architecture behavior of fulladder is
begin 
	sum <= (a XOR b) XOR cin;
	cout <= (a AND b) or (a AND cin) or (b AND cin);
end behavior;

-- N bits adder_subtractor define
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_sub is
	generic ( N : natural := 4);	-- initiallize 4-bit adder/substractor
	port(
			A, B : in std_logic_vector(N-1 downto 0);
			Mode : in std_logic;
			Sum  : out std_logic_vector(N-1 downto 0);
			Cout : out std_logic
		  );
end add_sub;

architecture fbas_arc of add_sub is
	component fulladder
		port(
				a, b, cin : in std_logic;
				sum, cout: out std_logic
			  );	
	end component;
	signal co 	: std_logic_vector(N downto 0);	
	signal xorB : std_logic_vector(N-1 downto 0);	
begin
	co(0) <= Mode;
	Cout <= co(N-1);
	
	SUB: for i in 0 to N-1 generate
		mod_b: xorB(i) <= B(i) XOR Mode;
	end generate SUB;
	
	GEN: for i in 0 to N-1 generate
		nb_adder: fulladder port map(A(i), xorB(i), co(i), 
												Sum(i),co(i+1) );
	end generate GEN;
end fbas_arc;

