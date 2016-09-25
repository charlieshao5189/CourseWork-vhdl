-- full_adder define
library IEEE;
use ieee.std_logic_1164.ALL;

entity full_adder is
	port (
			a, b, cin : in std_logic;
			sum, cout: out std_logic
			);
end full_adder;

architecture behavior of full_adder is
begin 
	sum <= (a XOR b) XOR cin;
	cout <= (a AND b) or (a AND cin) or (b AND cin);
end behavior;

-- N bits adder define
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nbit_adder is
	generic ( N : natural := 4);	-- initiallize 4-bit adder
	port(
			A, B : in std_logic_vector(N-1 downto 0);
			Cin  : in std_logic;
			Sum  : out std_logic_vector(N-1 downto 0);
			Cout : out std_logic
		  );
end nbit_adder;

architecture behavior of nbit_adder is
	component full_adder
		port(
				a, b, cin : in std_logic;
				sum, cout: out std_logic
			  );	
	end component;
	signal co : std_logic_vector(N downto 0);	
begin
	co(0) <= Cin;
	Cout <= co(N-1);
	
	GEN: for i in 0 to N-1 generate
		nb_adder: full_adder port map(A(i), B(i), co(i), 
												Sum(i),co(i+1) );
	end generate GEN;

end behavior;

