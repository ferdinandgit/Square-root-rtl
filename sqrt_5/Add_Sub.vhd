library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AddSub is
    Generic (
        N : integer := 32
    );
    Port (
        in1_R      : in  std_logic_vector(N-1 downto 0);
        in1_D      : in  std_logic_vector(1 downto 0);
        in2_Q      : in  std_logic_vector(N-1 downto 0);
        in2_R_MSB  : in std_logic;
        sel        : in  std_logic; -- 0: A - B, 1: A + B
        Result     : out std_logic_vector(N+1 downto 0)
    );
end AddSub;

architecture Behavioral of AddSub is
begin
    process(in1_R,in1_D,in2_Q,in2_R_MSB, sel)
    begin
        if sel = '1' then
            Result <= std_logic_vector(unsigned(in1_R & in1_D) + unsigned(in2_Q & in2_R_MSB & '1'));
        else
            Result <= std_logic_vector(unsigned(in1_R & in1_D) - unsigned(in2_Q & in2_R_MSB & '1'));
        end if;
    end process;
end Behavioral;
