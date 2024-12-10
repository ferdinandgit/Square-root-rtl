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
        sel_mux_result  : in  std_logic;
        sel_mux_D       : in  std_logic;
        reset           : in  std_logic;
        result          : out std_logic_vector(N-1 downto 0)
    );
end datapath;

architecture Structural of datapath is
    signal sel_addsub   : std_logic;
    signal in1_addsub, in2_addsub, out_addsub : std_logic_vector(N+1 downto 0);
    signal mux_D_out    : std_logic_vector(2*N-1 downto 0); -- Adjusted range to match the intended size
    signal R            : std_logic_vector(N+1 downto 0); -- Adjusted size to align with signals
    signal Q            : std_logic_vector(N-1 downto 0);
    signal D            : std_logic_vector(2*N-1 downto 0);
begin

mux_D : entity work.Mux
    generic map ( 
        N => 2*N
    )
    port map (
        A => A,
        B => D,
        sel => sel_mux_D,
        Y => mux_D_out
    );

-- Multiplexer for result
mux_result : entity work.Mux
    generic map ( 
        N => N
    )
    port map (
        A => (others => '0'),
        B => Q,
        sel => sel_mux_result,
        Y => result
    );

-- Register R
reg_R : entity work.Reg
    generic map ( 
        N_data => N+2
    )
    port map (
        data_in => out_addsub,
        data_out => R,
        clk => clk,
        reset => reset
    );

-- Register Q
reg_Q : entity work.Reg
    generic map ( 
        N_data => N
    )
    port map (
        data_in => Q, 
        data_out => Q,
        clk => clk,
        reset => reset
    );

-- Register D
reg_D : entity work.Reg
    generic map ( 
        N_data => 2*N
    )
    port map (
        data_in => mux_D_out, 
        data_out => D,
        clk => clk,
        reset => reset
    );


-- Add/Subtract Unit
AddSub : entity work.AddSub
    port map (
        A => in1_addsub,
        B => in2_addsub,
        sel => R(N+1),
        result => out_addsub
    );

process(clk, reset)
begin
    if reset = '1' then
        R <= (others => '0');
        Q <= (others => '0');
        D <= (others => '0');
        sel_addsub <= '0';
    elsif rising_edge(clk) then
        -- Inputs to AddSub
        in1_addsub <= R(N-1 downto 0) & D(2*N-1 downto 2*N-2);
        in2_addsub <= Q & R(N+1) & '1';
        D <=  std_logic_vector(shift_left(unsigned(D), 2));
        Q <= Q(N-2 downto 0) & not out_addsub(N+1);
    end if;


end Structural;
