library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit is
    generic(
        N: integer := 32 );
    Port (
        A          : in  std_logic_vector(2*N-1 downto 0);
        start      : in  std_logic;
        clk        : in  std_logic;
        reset      : in  std_logic;
        done       : out std_logic;
        result     : out std_logic_vector(N-1 downto 0);
        sel_addsub : out std_logic;
        in1_addsub : out std_logic_vector(N+1 downto 0);
        in2_addsub : out std_logic_vector(N+1 downto 0);
        out_addsub : in  std_logic_vector(N+1 downto 0)
    );
end ControlUnit;

architecture Behavioral of ControlUnit is
    type t_state is (sleep, init, compute, finished);
    signal state : t_state;
    signal counter : integer range 2*N-1 downto -1 := 0; 
    signal D : std_logic_vector(2*N-1 downto 0);
    signal R : std_logic_vector(N-1 downto 0); -- Inclut 1 bit supplémentaire pour le MSB
    signal Q : std_logic_vector(N-1 downto 0);
    signal R_MSB : std_logic;
begin
    -- Process principal
    process(clk, reset)
    begin
        if reset = '1' then
            state <= sleep; 
            done <= '0';
            counter <= N;
            D <= (others => '0');
            R <= (others => '0');
            Q <= (others => '0');
            in1_addsub <= (others => '0');
            in2_addsub <= (others => '0');
        elsif rising_edge(clk) then
            case state is
                when sleep =>
                    if start = '1' then
                        state <= init;
                    end if;

                when init =>
                    -- Initialisation
                    D <= A;
                    R <= (others => '0');
                    Q <= (others => '0');
                    counter <= N;
                    done <= '0';
                    state <= compute;
                    R_MSB <= '0';
                    in1_addsub <= (N+1 downto 2 => '0') & A(2*N-1 downto 2*N-2);
                    in2_addsub <= (N+1 downto 1 => '0') & '1';
                    result <= (others => '0');

                when compute => 
                    if counter < 0 then 
                        state <= finished;
                    else
                        -- Préparer les entrées pour le Add/Sub
                        in1_addsub <= R & D(2*N-1 downto 2*N-2); -- Bits les plus significatifs de D
                        in2_addsub <= Q & R_MSB & '1';           -- Concaténer Q, MSB et "1"
                        sel_addsub <= R_MSB;                    -- Sélectionne addition ou soustraction
                        
                        -- Mettre à jour R, Q, et D
                        R_MSB <= out_addsub(N+1);               -- MSB du résultat
                        R <= out_addsub(N-1 downto 0);            -- Nouveau reste
                        Q <= Q(N-2 downto 0) & not out_addsub(N+1); -- Mettre à jour Q avec le nouveau bit
                        D <= std_logic_vector(shift_left(unsigned(D), 2)); -- Décaler D de 2 bits
                        
                        -- Décrémenter le compteur
                        counter <= counter - 1;
                        state <= compute;
                        result <= Q;
                    end if;

                when finished =>
                    result <= Q; -- Résultat final
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
