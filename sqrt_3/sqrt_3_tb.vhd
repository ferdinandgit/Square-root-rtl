library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sqrt_3_tb is
    -- Pas de ports pour un testbench
end sqrt_3_tb;

architecture Behavioral of sqrt_3_tb is
    -- Paramètres génériques
    constant n : integer := 32;

    -- Composant à tester
    component sqrt_3
         generic (
        N : integer -- Nombre de bits pour la partie entière de sqrtA
    );
    Port (
        A     : in  std_logic_vector(2*N-1 downto 0); -- Entrée sur 2N bits
        Result : out std_logic_vector(N-1 downto 0)  -- Racine carrée sur N bits
    );
    end component sqrt_3;

    -- Signaux de test
    signal a     : std_logic_vector(2*n-1 downto 0) := (others => '0'); -- Entrée
    signal result : std_logic_vector(n-1 downto 0); -- Sortie

    constant wait_time : time := 500 ns;
    
begin
    -- Instanciation du composant
    uut: sqrt_3
        generic map (N => n)
        port map (
            A     => a,
            Result => result
        );

    -- Processus de génération des stimuli
    stim_proc: process
    begin
        -- Initialisation : Activer le reset
        a <= std_logic_vector(to_unsigned(0, 2*N));
        wait for wait_time;
        
        -- Cas de test 1 : Racine carrée de 16
        a <= std_logic_vector(to_unsigned(16, 2*N));
        wait for wait_time; -- Attendre suffisamment de temps pour convergence

        -- Cas de test 2 : Racine carrée de 64
        a <= std_logic_vector(to_unsigned(64, 2*N));
        wait for wait_time;

        -- Cas de test 3 : Racine carrée de 0
        a <= std_logic_vector(to_unsigned(0, 2*N));
        wait for wait_time;
        
        -- Cas de test 4 : Racine carrée de 4
        a <= std_logic_vector(to_unsigned(4, 2*N));
        wait for wait_time; -- Attendre suffisamment de temps pour convergence

        a <= std_logic_vector(to_unsigned(1, 2*N));
        wait for wait_time;
        
        -- Cas de test 5 : Racine carrée de 512
        a <= std_logic_vector(to_unsigned(512, 2*N));
        wait for wait_time;
        
         -- Cas de test 8 : Racine carrée de 5499030
        a <= std_logic_vector(to_unsigned(5499030, 2*N));
        wait for wait_time;

        
        -- Cas de test 9 : Racine carrée de 1194877489
        a <= std_logic_vector(to_unsigned(1194877489, 2*N));
        wait for wait_time;

        -- Fin des tests
        wait;
    end process;

end Behavioral;
