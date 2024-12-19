library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit is
    generic(
        N: integer := 32 );
    Port (
        start      : in  std_logic;
        clk        : in  std_logic;
        reset      : in  std_logic;
        done       : out std_logic;
        start_out : out std_logic
    );
end ControlUnit;

architecture Behavioral of ControlUnit is
    type t_state is (sleep, init, compute, finished);
    signal state : t_state;
    signal counter : integer range 2*N-1 downto -1 := 0; 
begin
    -- Process principal
    process(clk, reset)
    begin
        if reset = '1' then
            state <= sleep; 
            done <= '0';
            counter <= N;
            start_out <= '0';
            
        elsif rising_edge(clk) then
            case state is
                when sleep =>
                    if start = '1' then
                        state <= init;
                        start_out <= '1';
                    end if;

                when init =>
                    -- Initialisation
                    done <= '0';
					counter <= N-2;
					state <= compute;
					start_out <= '0';

                when compute => 
                    if counter < 0 then 
                        state <= finished;
                        done <= '1'; -- Indiquer que le calcul est terminé
                    else
                        counter <= counter-1;
                    end if;

                when finished =>
                    if start = '0' then
                        state <= sleep;
                        done <= '0';
                    end if;

                when others =>
                    state <= sleep;
            end case;
        end if;
    end process;
end Behavioral;
