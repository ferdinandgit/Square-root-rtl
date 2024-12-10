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
        sel_D_mux : out std_logic;
        sel_result_mux : out std_logic
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
            sel_D_mux <= '0';
            sel_result_mux <= '0';
            
        elsif rising_edge(clk) then
            case state is
                when sleep =>
                    sel_D_mux <= '0';
                    sel_result_mux <= '0';
                    if start = '1' then
                        state <= init;
                    end if;

                when init =>
                    -- Initialisation
                    sel_D_mux <= '0';
                    sel_result_mux <= '0';
                    done <= '0';
					counter <= N-1;
					state <= compute;

                when compute => 
                    if counter < 0 then 
                        state <= finished;
                    else
                        sel_D_mux <= '1';
                        sel_result_mux <= '1';
                        counter <= counter-1;
                    end if;

                when finished =>
                    sel_D_mux <= '0';
                    sel_result_mux <= '1';
                    done <= '1'; -- Indiquer que le calcul est terminé
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
