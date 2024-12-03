library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sqrt_1_tb is
    -- Pas de ports pour un testbench
end sqrt_1_tb;

architecture Behavioral of sqrt_1_tb is
    -- Param�tres g�n�riques
    constant n : integer := 32;

    -- Composant � tester
    component sqrt_1
         generic (
        N : integer -- Nombre de bits pour la partie enti�re de sqrtA
    );
    Port (
        clk   : in  std_logic; -- Horloge
        reset : in  std_logic; -- Reset synchrone
        start   : in  std_logic; -- start the process
        done   : out  std_logic; -- sqrt calcul�e
        A     : in  std_logic_vector(2*N-1 downto 0); -- Entr�e sur 2N bits
        Result : out std_logic_vector(N-1 downto 0)  -- Racine carr�e sur N bits
    );
    end component sqrt_1;

    -- Signaux de test
    signal clk   : std_logic := '0';  -- Horloge
    signal reset : std_logic := '1';  -- R�initialisation active au 
    signal start : std_logic := '0';
    signal done : std_logic := '0';
    signal a     : std_logic_vector(2*n-1 downto 0) := (others => '0'); -- Entr�e
    signal result : std_logic_vector(n-1 downto 0); -- Sortie
    
    signal start_time : time := 0 ns;
    signal finish_time : time := 0 ns;

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
    uut: sqrt_1
        generic map (N => n)
        port map (
            clk   => clk,
            reset => reset,
            A     => a,
            Result => result,
            start => start,
            done => done
        );

    -- Processus de g�n�ration des stimuli
    stim_proc: process
    variable latency_ns : integer := 0;
    begin
        -- Initialisation : Activer le reset
        reset <= '1';
        a <= std_logic_vector(to_unsigned(0, 2*N));
        wait for clk_period;
        reset <= '0'; -- D�sactiver le reset
        wait for clk_period;
        
        -- Cas de test 1 : Racine carr�e de 16
        a <= std_logic_vector(to_unsigned(16, 2*N));
        start <= '1';
        wait until done = '1';
        wait for clk_period;
        start <= '0';
        wait for clk_period;

        -- Cas de test 2 : Racine carr�e de 64
        a <= std_logic_vector(to_unsigned(64, 2*N));
        start <= '1';
        wait until done = '1';
        wait for clk_period;
        start <= '0';
        wait for clk_period;

        -- Cas de test 3 : Racine carr�e de 0
        a <= std_logic_vector(to_unsigned(0, 2*N));
        start <= '1';
        wait until done = '1';
        wait for clk_period;
        start <= '0';
        wait for clk_period;
        
        -- Cas de test 4 : Racine carr�e de 4
        a <= std_logic_vector(to_unsigned(4, 2*N));
        start <= '1';
        wait until done = '1';
        wait for clk_period;
        start <= '0';
        wait for clk_period;

        a <= std_logic_vector(to_unsigned(1, 2*N));
        start <= '1';
        wait until done = '1';
        wait for clk_period;
        start <= '0';
        wait for clk_period;
        
        -- Cas de test 5 : Racine carr�e de 512
        a <= std_logic_vector(to_unsigned(512, 2*N));
        start <= '1';
        wait until done = '1';
        wait for clk_period;
        start <= '0';
        wait for clk_period;
        
         -- Cas de test 8 : Racine carr�e de 5499030
        a <= std_logic_vector(to_unsigned(5499030, 2*N));
        start <= '1';
        wait until done = '1';
        wait for clk_period;
        start <= '0';
        wait for clk_period;

        
        -- Cas de test 9 : Racine carr�e de 1194877489
        a <= std_logic_vector(to_unsigned(1194877489, 2*N));
        start <= '1';
        wait until done = '1';
        wait for clk_period;
        start <= '0';
        wait for clk_period;

        -- Fin des tests
        reset <= '1';
        a <= std_logic_vector(to_unsigned(0, 2*N));
        wait;
    end process;

end Behavioral;
