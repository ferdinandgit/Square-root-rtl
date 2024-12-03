library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sqrt_2 is 
	generic(
	N: integer );
	port(
	reset, clk, start: in std_logic; 
	A: in std_logic_vector (2*N-1 downto 0);
	Result: out std_logic_vector (N-1 downto 0); 
	done: out std_logic);
end sqrt_2; 

architecture rtl of sqrt_2 is
	type t_state is (sleep, compute, init, finished);
	signal state : t_state;
	signal counter : integer range N-1 downto -1; 
	signal D : std_logic_vector (2*N-1 downto 0);
	signal R : std_logic_vector (2*N-1 downto 0);
	signal Z : std_logic_vector (2*N-1 downto 0);

begin
	process(clk,reset)
		variable temp: std_logic_vector(4*N-1 downto 0);
		variable R_temp: std_logic_vector(2*N-1 downto 0);
	begin
		if reset = '1' then
			state <= sleep; 
		end if;
		
		if rising_edge(clk) then
			case state is
				when sleep =>
					if start = '1' then
						state <= init;
					else 
						state <= sleep;
					end if;
				
				when init =>
					D <= A;
					R <= (others => '0');
					Z <= (others => '0');
					done <= '0';
					counter <= N-1;
					state <= compute;

				when compute => 
					if counter < 0 then 
						state <= finished;
					else
						R_temp := R;
						if  signed(R_temp) >= 0 then 
							temp := std_logic_vector((signed(R) sll 2) + 
              ((signed(D) srl (2*N-2)) ) - 
              (4 * signed(Z) + 1));
            	R_temp := temp(2*N-1 downto 0);
            else 
							temp := std_logic_vector((signed(R) sll 2) + 
            	(signed(D) srl (2*N-2)) + 
        			(4 * signed(Z) + 3));	
        			R_temp := temp(2*N-1 downto 0);
          	end if; 
          	R <= R_temp;
						if signed(R_temp) >= 0 then
          		Z<=std_logic_vector((unsigned(Z) sll 1) + 1);
          	else
          		Z<=std_logic_vector((unsigned(Z) sll 1));     
          	end if;
          	D <= std_logic_vector(unsigned(D) sll 2);
						counter <= counter-1;
						state <= compute;
					end if;

				when finished =>
					Result <= Z(N-1 downto 0);
					done <= '1';
					state <= finished;
					if start = '0' then
						done <= '0';
					 	state <= sleep;
					end if;			
			end case;
		end if;
	end process;
end rtl; 

