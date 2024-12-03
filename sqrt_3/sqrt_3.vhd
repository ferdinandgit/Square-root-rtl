library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sqrt_3 is 
	generic(
	N: integer );
	port(
	A: in std_logic_vector (2*N-1 downto 0);
	Result: out std_logic_vector (N-1 downto 0) 
	);
end sqrt_3; 

architecture rtl of sqrt_3 is
	
begin
	process(A)
		
		variable temp: signed(4*N-1 downto 0);
		variable R: signed(2*N-1 downto 0);
		variable Z: signed(2*N-1 downto 0);
		variable D: signed(2*N-1 downto 0);
		
		begin	
		D := signed(A);
		R := (others => '0');
		Z := (others => '0');
		
		for k in (N-1) downto 0 loop
			if R >= 0 then 
				temp := ( R sll 2) + 
      	(D srl (2*N-2)) - 
      	(4 * Z + 1);
      	R := temp(2*N-1 downto 0);
    	else 
				temp := (R sll 2) + 
      	(D srl (2*N-2)) + 
      	(4 * Z + 3);	
      	R := temp(2*N-1 downto 0);
    	end if;

			if R >= 0 then
      	Z := (Z sll 1) + 1;
    	else
      	Z := Z sll 1;     
    	end if;
      D := D sll 2;
    end loop;
    Result <= std_logic_vector(Z(N-1 downto 0));
	end process;
end rtl; 

