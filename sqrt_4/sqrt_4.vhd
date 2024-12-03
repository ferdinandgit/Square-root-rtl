library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sqrt_4 is 
	generic(
	N: integer );
	port(
	clk,start,reset: in std_logic;
	A: in std_logic_vector (2*N-1 downto 0);
	Result: out std_logic_vector (N-1 downto 0);
	done: out std_logic
	);
end sqrt_4; 

architecture rtl of sqrt_4 is
	type signed_array is array(0 to N) of signed(2*N-1 downto 0);
	signal start_pipeline : std_logic_vector(N downto 0);
	signal pipeline_R: signed_array;
	signal pipeline_Z: signed_array;
	signal pipeline_D: signed_array;


begin
		
	process(clk,reset)
		variable temp: signed(4*N-1 downto 0);
		variable R: signed(2*N-1 downto 0);
		
		begin	
		if reset = '1' then
		 	pipeline_D <= (others => (others => '0'));
			pipeline_R <= (others => (others => '0'));
			pipeline_Z <= (others => (others => '0'));
			R := (others => '0');
		end if;

		if rising_edge(clk) then 
			pipeline_D(0) <= signed(A);
			for k in 0 to N-1 loop
				if pipeline_R(k) >= 0 then 
					temp := ( pipeline_R(k) sll 2) + 
      		(pipeline_D(k) srl (2*N-2)) - 
      		(4 * pipeline_Z(k) + 1);
      		R := temp(2*N-1 downto 0);
    		else 
					temp := (pipeline_R(k) sll 2) + 
      		(pipeline_D(k) srl (2*N-2)) + 
      		(4 * pipeline_Z(k) + 3);	
      		R := temp(2*N-1 downto 0);
    		end if;
    		pipeline_R(k+1) <= R;

				if R >= 0 then
      		pipeline_Z(k+1) <= (pipeline_Z(k) sll 1) + 1;
    		else
      		pipeline_Z(k+1) <= pipeline_Z(k) sll 1;     
    		end if;
      	pipeline_D(k+1) <= pipeline_D(k) sll 2;
    	end loop;	
    Result <= std_logic_vector(pipeline_Z(N)(N-1 downto 0));
		start_pipeline <= start_pipeline(N-1 downto 0) & start;
    done <= start_pipeline(N);
  	end if; 
	end process;
end rtl; 

