library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNCHRONIZER is
    port (
        SIG         : in  STD_LOGIC;
        SYNCED_SIG  : out STD_LOGIC;
        CLK         : in  STD_LOGIC;
        RST_DP      : in  STD_LOGIC
    );
end entity SYNCHRONIZER;

architecture SYNCHRONIZER_BODY of SYNCHRONIZER is
    signal SIG_12   : STD_LOGIC;
begin
    
    REG_1 : process
    begin
        if CLK = '1' and CLK'EVENT then
            if RST_DP = '1' then
                SIG_12 <= '0';
            else
                SIG_12 <= SIG;
            end if;
        end if;
    end process REG_1;
    
    REG_2 : process
    begin
        if CLK = '1' and CLK'EVENT then
            if RST_DP = '1' then
                SYNCED_SIG <= '0';
            else
                SYNCED_SIG <= SIG_12;
            end if;
        end if;
    end process REG_2;

end architecture SYNCHRONIZER_BODY;