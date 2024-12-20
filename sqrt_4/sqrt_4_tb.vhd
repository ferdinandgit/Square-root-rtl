library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.uniform;
use ieee.math_real.floor;

entity sqrt_4_tb is
    -- Pas de ports pour un testbench
end sqrt_4_tb;

architecture Behavioral of sqrt_4_tb is
    -- Paramètres génériques
    constant n : integer := 32;

    -- Composant à tester
    component sqrt_4
         generic (
        N : integer -- Nombre de bits pour la partie entière de sqrtA
    );
    Port (
        clk   : in  std_logic; -- Horloge
        reset : in  std_logic; -- Reset synchrone
        start   : in  std_logic; -- start the process
        done   : out  std_logic; -- sqrt calculée
        A     : in  std_logic_vector(2*N-1 downto 0); -- Entrée sur 2N bits
        Result : out std_logic_vector(N-1 downto 0)  -- Racine carrée sur N bits
    );
    end component sqrt_4;

    -- Signaux de test
    signal clk   : std_logic := '0';  -- Horloge
    signal reset : std_logic := '1';  -- Réinitialisation active au
    signal start : std_logic := '0';
    signal done : std_logic := '0';
    signal a     : std_logic_vector(2*n-1 downto 0) := (others => '0'); -- Entrée
    signal result : std_logic_vector(n-1 downto 0); -- Sortie
    
    signal start_time : time := 0 ns;
    signal finish_time : time := 0 ns;

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
    uut: sqrt_4
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
    variable latency_ns : integer := 0;
    variable seed1 : positive;
    variable seed2 : positive;
    variable x : real;
    variable int_value : integer;
    variable y : integer;
    begin
        seed1 := 1;
        seed2 := 1;

        -- Initialisation : Activer le reset
        reset <= '1';
        start <= '0';
        a <= std_logic_vector(to_unsigned(0, 2*N));
        wait for clk_period;
        reset <= '0'; -- Désactiver le reset
        wait for clk_period;
        
        for n in 1 to 60 loop
            -- Générer un nombre aléatoire
            uniform(seed1, seed2, x);
            y := integer(floor(x * 10000000.0));
            A <= std_logic_vector(to_unsigned(y, A'length));
            wait for clk_period;
        end loop;
        
        -- Cas de test 1 : Racine carrée de 16
        a <= std_logic_vector(to_unsigned(16, 2*N));
        start <= '1';
        wait for clk_period;
        
        for n in 1 to 60 loop
            -- Générer un nombre aléatoire
            uniform(seed1, seed2, x);
            y := integer(floor(x * 10000000.0));
            A <= std_logic_vector(to_unsigned(y, A'length));
            wait for clk_period;
        end loop;
        
        
        
        -- Fin des tests
        reset <= '1';
        a <= std_logic_vector(to_unsigned(0, 2*N));
        wait;
    end process;

end Behavioral;
