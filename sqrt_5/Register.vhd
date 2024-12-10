library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg is
    generic( 
        N_data : integer := 32
    );
    port (
        data_in : in std_logic_vector(N_data-1 downto 0);
        data_out : out std_logic_vector(N_data-1 downto 0);
        clk : in std_logic;
        reset : in std_logic
    );
end Reg;

architecture Behavioral of Reg is
    signal data : std_logic_vector(N_data-1 downto 0);
begin
    process(reset, clk)
    begin
        if reset = '0' then
            data <= (others => '0'); -- Reset the data to all zeros
        elsif rising_edge(clk) then
            data <= data_in; -- Load input data on clock edge
        end if;
    end process;
    data_out <= data; -- Assign the signal to output
end Behavioral;

