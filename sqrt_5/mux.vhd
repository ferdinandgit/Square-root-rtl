library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux is
    generic( 
        N : integer := 32 -- Default value for safety
    );
    port (
        A : in std_logic_vector(N-1 downto 0);
        B : in std_logic_vector(N-1 downto 0);
        sel : in std_logic;
        Y : out std_logic_vector(N-1 downto 0) -- Renamed to 'Y' for clarity
    );
end Mux;

architecture Behavioral of Mux is
begin
    process(sel, A, B) -- Include sensitivity list properly
    begin
        if sel = '0' then
            Y <= A; -- Select input A
        else 
            Y <= B; -- Select input B
        end if;
    end process;
end Behavioral;
