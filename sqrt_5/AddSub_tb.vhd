library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_AddSub is
-- Pas de ports nécessaires pour un testbench
end TB_AddSub;

architecture Behavioral of TB_AddSub is
    -- Déclaration des constantes et signaux locaux
    constant N : integer := 32; -- Taille des mots
    signal A, B : std_logic_vector(N+1 downto 0); -- Entrées du composant
    signal sel : std_logic; -- Sélection d'opération
    signal Result : std_logic_vector(N+1 downto 0); -- Résultat du composant

begin
    -- Instanciation du composant AddSub
    DUT : entity work.AddSub
        Generic map (
            N => N
        )
        Port map (
            A => A,
            B => B,
            sel => sel,
            Result => Result
        );

    -- Processus de simulation
    stimulus : process
    begin
        -- Cas 1 : Addition de deux nombres positifs
        A <= std_logic_vector(to_unsigned(15, N+2)); -- A = 15
        B <= std_logic_vector(to_unsigned(10, N+2)); -- B = 10
        sel <= '1'; -- Addition
        wait for 10 ns;
        assert (unsigned(Result) = 25) report "Erreur : Addition de 15 + 10 incorrecte" severity error;

        -- Cas 2 : Soustraction de deux nombres positifs (résultat positif)
        A <= std_logic_vector(to_unsigned(20, N+2)); -- A = 20
        B <= std_logic_vector(to_unsigned(5, N+2)); -- B = 5
        sel <= '0'; -- Soustraction
        wait for 10 ns;
        assert (unsigned(Result) = 15) report "Erreur : Soustraction de 20 - 5 incorrecte" severity error;

        -- Cas 3 : Soustraction de deux nombres positifs (résultat négatif)
        A <= std_logic_vector(to_unsigned(5, N+2)); -- A = 5
        B <= std_logic_vector(to_unsigned(20, N+2)); -- B = 20
        sel <= '0'; -- Soustraction
        wait for 10 ns;
        
        -- Cas 5 : Soustraction donnant zéro
        A <= std_logic_vector(to_unsigned(100, N+2)); -- A = 100
        B <= std_logic_vector(to_unsigned(100, N+2)); -- B = 100
        sel <= '0'; -- Soustraction
        wait for 10 ns;

        -- Fin de la simulation
        wait;
    end process;

end Behavioral;
