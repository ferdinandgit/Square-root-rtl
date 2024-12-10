library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AddSub is
    Generic (
        N : integer := 32
    );
    Port (
        A      : in  std_logic_vector(N+1 downto 0);
        B      : in  std_logic_vector(N+1 downto 0);
        sel    : in  std_logic; -- 0: A - B, 1: A + B
        Result : out std_logic_vector(N+1 downto 0)
    );
end AddSub;

architecture Behavioral of AddSub is
begin
    process(A, B, sel)
    begin
        if sel = '1' then
            Result <= std_logic_vector(unsigned(A) + unsigned(B));
        else
            Result <= std_logic_vector(unsigned(A) - unsigned(B));
        end if;
    end process;
end Behavioral;
