library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sqrt_5_tb is
    -- Pas de ports pour un testbench
end sqrt_5_tb;

architecture Behavioral of sqrt_5_tb is
    -- Param�tres g�n�riques
    constant n : integer := 32;

    -- Composant � tester
    component sqrt_5
         generic (
        N : integer -- Nombre de bits pour la partie enti�re de sqrtA
    );
    Port (
        clk   : in  std_logic; -- Horloge
        reset : in  std_logic; -- Reset synchrone
        start   : in  std_logic; -- start the process
        done : out  std_logic; -- sqrt calcul�e
        A     : in  std_logic_vector(2*N-1 downto 0); -- Entr�e sur 2N bits
        Result : out std_logic_vector(N-1 downto 0)  -- Racine carr�e sur N bits
    );
    end component sqrt_5;

    -- Signaux de test
    signal clk   : std_logic := '0';  -- Horloge
    signal reset : std_logic := '1';  -- R�initialisation active au
    signal start : std_logic := '0';
    signal finished : std_logic := '0';
    signal a     : std_logic_vector(2*n-1 downto 0) := (others => '0'); -- Entr�e
    signal result : std_logic_vector(n-1 downto 0); -- Sortie

    constant clk_period : time := 10 ns;
    constant wait_time : time := 500 ns;
    
begin
    -- G�n�ration de l'horloge
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
    uut: sqrt_5
        generic map (N => n)
        port map (
            clk   => clk,
            reset => reset,
            A     => a,
            Result => result,
            start => start,
            done => finished
        );

    -- Processus de g�n�ration des stimuli
    stim_proc: process
    begin
        -- Initialisation : Activer le reset
        reset <= '1';
        a <= std_logic_vector(to_unsigned(0, 2*N));
        wait for clk_period;
        reset <= '0'; -- D�sactiver le reset
        wait for clk_period;
        
        -- Cas de test 1 : Racine carr�e de 16
        a <= std_logic_vector(to_unsigned(4096, 2*N));
        start <= '1';
        wait until finished = '1'; -- Attendre suffisamment de temps pour convergence
        start <= '0';
        wait for 5*clk_period;

        -- Cas de test 2 : Racine carr�e de 64
        a <= std_logic_vector(to_unsigned(64, 2*N));
        start <= '1';
        wait until finished = '1';
        start <= '0';
        wait for clk_period;

        -- Cas de test 3 : Racine carr�e de 0
        a <= std_logic_vector(to_unsigned(0, 2*N));
        start <= '1';
        wait until finished = '1';
        start <= '0';
        wait for clk_period;
        
        -- Cas de test 4 : Racine carr�e de 4
        a <= std_logic_vector(to_unsigned(4, 2*N));
        start <= '1';
        wait until finished = '1'; -- Attendre suffisamment de temps pour convergence
        start <= '0';
        wait for clk_period;

        a <= std_logic_vector(to_unsigned(1, 2*N));
        start <= '1';
        wait until finished = '1';
        start <= '0';
        wait for clk_period;
        
        -- Cas de test 5 : Racine carr�e de 512
        a <= std_logic_vector(to_unsigned(512, 2*N));
        start <= '1';
        wait until finished = '1';
        start <= '0';
        wait for clk_period;
        
         -- Cas de test 8 : Racine carr�e de 5499030
        a <= std_logic_vector(to_unsigned(5499030, 2*N));
        start <= '1';
        wait until finished = '1';
        start <= '0';
        wait for clk_period;

        
        -- Cas de test 9 : Racine carr�e de 1194877489
        a <= std_logic_vector(to_unsigned(1194877489, 2*N));
        start <= '1';
        wait until finished = '1';
        start <= '0';
        wait for clk_period;

        -- Fin des tests
        wait;
    end process;

end Behavioral;