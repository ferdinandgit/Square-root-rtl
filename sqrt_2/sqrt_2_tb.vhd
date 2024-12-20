library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sqrt_2_tb is
    -- Pas de ports pour un testbench
end sqrt_2_tb;

architecture Behavioral of sqrt_2_tb is
    -- Paramètres génériques
    constant n : integer := 32;

    -- Composant à tester
    component sqrt_2
         generic (
        N : integer -- Nombre de bits pour la partie entière de sqrtA
    );
    Port (
        clk   : in  std_logic; -- Horloge
        reset : in  std_logic; -- Reset synchrone
        start   : in  std_logic; -- start the process
        done : out  std_logic; -- sqrt calculée
        A     : in  std_logic_vector(2*N-1 downto 0); -- Entrée sur 2N bits
        Result : out std_logic_vector(N-1 downto 0)  -- Racine carrée sur N bits
    );
    end component sqrt_2;

    -- Signaux de test
    signal clk   : std_logic := '0';  -- Horloge
    signal reset : std_logic := '1';  -- Réinitialisation active au
    signal start : std_logic := '0';
    signal done : std_logic := '0';
    signal a     : std_logic_vector(2*n-1 downto 0) := (others => '0'); -- Entrée
    signal result : std_logic_vector(n-1 downto 0); -- Sortie

    constant clk_period : time := 10 ns;
    constant wait_time : time := 500 ns;
    
begin
    -- Génération de l'horloge
    clk_process : process
    begin
        while True loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Instanciation du composant
    uut: sqrt_2
        generic map (N => n)
        port map (
            clk   => clk,
            reset => reset,
            A     => a,
            Result => result,
            start => start,
            done => done
        );

    -- Processus de génération des stimuli
    stim_proc: process
    begin
        -- Initialisation : Activer le reset
        reset <= '1';
        a <= std_logic_vector(to_unsigned(0, 2*N));
        wait for clk_period;
        reset <= '0'; -- Désactiver le reset
        wait for 2*clk_period;
        
        -- Cas de test 1 : Racine carrée de 16
        a <= std_logic_vector(to_unsigned(16, 2*N));
        start <= '1';
        wait until done = '1';
        start <= '0';
        wait for 2*clk_period;

        -- Cas de test 2 : Racine carrée de 64
        a <= std_logic_vector(to_unsigned(64, 2*N));
        start <= '1';
        wait until done = '1';
        start <= '0';
        wait for 2*clk_period;

        -- Cas de test 3 : Racine carrée de 0
        a <= std_logic_vector(to_unsigned(0, 2*N));
        start <= '1';
        wait until done = '1';
        start <= '0';
        wait for 2*clk_period;
        
        -- Cas de test 4 : Racine carrée de 4
        a <= std_logic_vector(to_unsigned(4, 2*N));
        start <= '1';
        wait until done = '1';
        start <= '0';
        wait for 2*clk_period;

        a <= std_logic_vector(to_unsigned(1, 2*N));
        start <= '1';
        wait until done = '1';
        start <= '0';
        wait for 2*clk_period;
        
        -- Cas de test 5 : Racine carrée de 512
        a <= std_logic_vector(to_unsigned(512, 2*N));
        start <= '1';
        wait until done = '1';
        start <= '0';
        wait for 2*clk_period;
        
         -- Cas de test 8 : Racine carrée de 5499030
        a <= std_logic_vector(to_unsigned(5499030, 2*N));
        start <= '1';
        wait until done = '1';
        start <= '0';
        wait for 2*clk_period;

        
        -- Cas de test 9 : Racine carrée de 1194877489
        a <= std_logic_vector(to_unsigned(1194877489, 2*N));
        start <= '1';
        wait for wait_time;
        start <= '0';
        wait for 2*clk_period;

        -- Fin des tests
        wait;
    end process;

end Behavioral;
