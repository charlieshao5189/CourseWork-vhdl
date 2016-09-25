----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:00:16 11/15/2015 
-- Design Name: 
-- Module Name:    alu4b - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity ALU is
	generic (TOTAL_BITS : natural := 32);
	port (
			clk 	: in  std_logic;
			opco 	: in  std_logic_vector(3 downto 0);
			A		: in  std_logic_vector(TOTAL_BITS - 1 downto 0);
			B		: in  std_logic_vector(TOTAL_BITS - 1 downto 0);
			Y		: out std_logic_vector(TOTAL_BITS - 1 downto 0);
			nzco	: out std_logic_vector(3 downto 0)			
			);
end ALU;

architecture alu_arc of ALU is
begin
	process (clk,A,B,opco)
		variable temp : std_logic_vector(TOTAL_BITS downto 0):= (others =>'0');
		variable yv: std_logic_vector(TOTAL_BITS-1 downto 0);
		variable cfv, zfv: std_logic;
	begin
		zfv := '0';
		if rising_edge(clk) then
			case opco is
				when "0000" =>							-- A+B
					temp := ('0' & A) + ('0' & B);
					yv := temp(TOTAL_BITS-1 downto 0);
					cfv:= temp(TOTAL_BITS);
					nzco(0) <= yv(TOTAL_BITS-1) 
									xor cfv 
									xor A(TOTAL_BITS -1)
									xor B(TOTAL_BITS -1);
					nzco(1) <= cfv;
				when "0001" =>							-- A-B
					temp := ('0' & A) - ('0' & B);
					yv := temp(TOTAL_BITS-1 downto 0);
					cfv:= temp(TOTAL_BITS);
					nzco(0) <= yv(TOTAL_BITS-1) 
									xor cfv 
									xor A(TOTAL_BITS -1)
									xor B(TOTAL_BITS -1);
					nzco(1) <= cfv;
				when "0010" =>							-- A+1
					temp := ('0' & A) + 1;
					yv := temp(TOTAL_BITS-1 downto 0);
					cfv:= temp(TOTAL_BITS);
					nzco(0) <= yv(TOTAL_BITS-1) 
									xor cfv 
									xor A(TOTAL_BITS -1);
					nzco(1) <= cfv;
				when "0011" =>							-- B+1
					temp := ('0' & B) + 1;
					yv := temp(TOTAL_BITS-1 downto 0);
					cfv:= temp(TOTAL_BITS);
					nzco(0) <= yv(TOTAL_BITS-1) 
									xor cfv 
									xor B(TOTAL_BITS -1);
					nzco(1) <= cfv;
				when "0100" =>							-- A-1
					temp := ('0' & A) - 1;
					yv := temp(TOTAL_BITS-1 downto 0);
					cfv:= temp(TOTAL_BITS);
					nzco(0) <= yv(TOTAL_BITS-1) 
									xor cfv 
									xor A(TOTAL_BITS -1);
					nzco(1) <= cfv;
				when "0101" =>							-- B-1
					temp := ('0' & B) - 1;
					yv := temp(TOTAL_BITS-1 downto 0);
					cfv:= temp(TOTAL_BITS);
					nzco(0) <= yv(TOTAL_BITS-1) 
									xor cfv 
									xor B(TOTAL_BITS -1);
					nzco(1) <= cfv;
				when "0110" =>							-- A
					yv := A;
				when "0111" =>							-- B
					yv := B;
				when "1000" =>							-- AND
					yv := A and B;
				when "1001" =>							-- OR
					yv := A or B;
				when "1010" =>							-- NOT A
					yv := not A;
				when "1011" =>							-- NOT B
					yv := not B;
				when "1100" =>							-- NAND
					yv := A nand B;
				when "1101" =>							-- NOR
					yv := A nor B;
				when "1110" =>							-- XOR
					yv := A xor B;
				when "1111" =>							-- EX-NOR
					yv := not (A xor B);
				when others =>
					yv := A;
			end case;
			
			for i in 0 to TOTAL_BITS-1 loop
				zfv:= zfv or yv(i);
			end loop;
			
			y <= yv;
			nzco(2) <= not zfv;
			nzco(3) <= yv(TOTAL_BITS-1);	
		end if;
	end process;
end alu_arc;

