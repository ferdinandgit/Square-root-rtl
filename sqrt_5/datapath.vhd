library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
    generic(
        N: integer := 32 -- Default value for safety
    );
    port (
        clk             : in  std_logic;
        A               : in  std_logic_vector(2*N-1 downto 0);
        start_in        : in  std_logic;
        done            : in  std_logic;
        reset           : in  std_logic;
        result          : out std_logic_vector(N-1 downto 0)
    );
end datapath;

architecture Behavioral of datapath is
    signal R, out_addsub         : std_logic_vector(N+1 downto 0);
    signal Q         : std_logic_vector(N-1 downto 0);
    signal D         : std_logic_vector(2*N-1 downto 0);
    signal sel_sig   : std_logic;
begin

-- Add/Subtract Unit
AddSub : entity work.AddSub
    port map (
        in1_R => R(N-1 downto 0),
        in1_D => D(2*N-1 downto 2*N-2),
        in2_Q => Q,
        in2_R_MSB => R(N+1),
        sel    => sel_sig,
        result => out_addsub
    );

-- Process to update registers
process(clk, reset)
begin
    if reset = '1' then
        -- Initialisation des registres lors du reset
        Q <= (others => '0');
        D <= (others => '0');
        sel_sig <= '1';
        R <= (others => '0');
        result <= (others => '0'); -- Optionnel, mais garantit une sortie propre
        
    elsif rising_edge(clk) then
        if start_in = '1' then
            -- Initialisation avec A au début
            D <= A;
            sel_sig <= '0';
            Q <= (others => '0');
            R <= (others => '0');
            result <= (others => '0');
            
        elsif done = '1' then
            -- État final, affectation du résultat
            result <= Q;
        else
            -- Comportement normal
            D <= std_logic_vector(shift_left(unsigned(D), 2));
            Q <= Q(N-2 downto 0) & not(out_addsub(N+1));
            sel_sig <= out_addsub(N+1);
            R <= out_addsub;
        end if;                
    end if;
end process;

end Behavioral;

