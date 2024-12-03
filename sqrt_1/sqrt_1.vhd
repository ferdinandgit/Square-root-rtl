library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sqrt_1 is
    generic (
        N : integer -- Nombre de bits pour la partie entière de sqrtA
    );
    Port (
        clk      : in  std_logic; -- Horloge
        reset    : in  std_logic; -- Reset synchrone
        start    : in  std_logic; -- Démarrage du processus
        done : out std_logic; -- Indique que le calcul est terminé
        A        : in  std_logic_vector(2*N-1 downto 0); -- Entrée sur 2N bits
        Result    : out std_logic_vector(N-1 downto 0) -- Racine carrée sur N bits
    );
end sqrt_1;

architecture Behavioral of sqrt_1 is
    -- Déclaration des signaux
    signal xn0 : std_logic_vector(2*N-1 downto 0); -- xn
    signal xn1 : std_logic_vector(2*N-1 downto 0); -- xn+1
    signal converged : std_logic; -- Indique la convergence
begin

process(clk, reset)
    variable xn0_temp : std_logic_vector(2*N-1 downto 0);
    variable xn1_temp : std_logic_vector(2*N-1 downto 0);
    variable temp : unsigned(2*N-1 downto 0); -- Valeur intermédiaire
begin
    if reset = '1' then
                -- Réinitialisation des signaux
                xn0 <= (others => '0');
                xn1 <= std_logic_vector(to_unsigned(2**(N-2), 2*N));
                converged <= '0';
                Result <= (others => '0');
    elsif rising_edge(clk) then
        if start = '0' then
            -- Initialisation des variables
            xn0_temp := std_logic_vector(to_unsigned(2**(N-2), 2*N));
            xn1_temp := std_logic_vector(shift_right(resize(
                            (unsigned(xn0_temp)  + unsigned(A) / unsigned(xn0_temp)), 2 * N),1));
            converged <= '0';
            Result <= (others => '0');
            xn0 <= xn0_temp;
            xn1 <= xn1_temp;
        elsif converged = '0' and start = '1' then
            -- Calcul de la nouvelle approximation si non convergé
            if unsigned(xn1) /= 0 then
                xn1_temp := std_logic_vector(shift_right(resize(unsigned(xn1) + unsigned(A) / unsigned(xn1), 2*N),1));
                xn0_temp := xn1;
                -- Vérification de la convergence
                if unsigned(xn1_temp) = unsigned(xn0_temp) then
                    converged <= '1'; -- Convergence atteinte
                end if;
            else -- cas xn+1 = 0
                xn1_temp := (others => '0');
                xn0_temp := (others => '0');
                converged <= '1'; -- Convergence atteinte
            end if;
            -- Mise à jour des signaux internes
            xn1 <= xn1_temp;
            xn0 <= xn0_temp;
            Result <= std_logic_vector(resize(unsigned(xn1_temp), N));
        elsif converged = '1' then
            Result <= std_logic_vector(resize(unsigned(xn1), N));
        end if;

        done <= converged;
    end if;
end process;

end Behavioral;
